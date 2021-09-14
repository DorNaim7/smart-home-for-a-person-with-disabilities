-- This code controls the step motor

library ieee;
use ieee.std_logic_1164.all;

entity step_motor_control is

		port (clk, rst: in bit;
				to_tris: in integer range 0 to 3;
			tris_out: out bit_vector (3 downto 0));

end step_motor_control;

architecture behave of step_motor_control is

type state_type is (S0, S1, S2, S3, S4);
signal state: state_type;

begin

		process (clk, rst)
				begin

						if rst= '0' then 
								state<= S0;
						elsif clk'event and clk = '1' then
									case state is
										when S0=> if to_tris= 1 then state<= S1; 
													elsif to_tris= 2 then state<= S4;
													else state<= S0;
													end if;
						
										when S1=> if to_tris= 1 then state<= S2;
													elsif to_tris= 2 then state<= S4;
													else state<= S0;
													end if;
							
										when S2=> if to_tris= 1 then state<= S3;
													elsif to_tris= 2 then state<= S1;
													else state<= S0;
													end if;
										
										when S3=> if to_tris= 1 then state<= S4;
													elsif to_tris= 2 then state<= S2;
													else state<= S0;
													end if;

										when S4=> if to_tris= 1 then state<= S1;
													elsif to_tris= 2 then state<= S3;
													else state<= S0;
													end if;
										when others => state<= S0;
									end case;
						end if;
			end process;
with state select
tris_out<= "0011" when S1,
			"0110" when S2,
			"1100" when S3,
			"1001" when S4,
			"1111" when S0;

end behave;