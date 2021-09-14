-- Frequency divider by 6293750 to create a 1hz frequency signal

library ieee;
use ieee.std_logic_1164.all;

entity f_div_4hz is

port (clk: in bit;
		f_out: out bit);

end f_div_4hz;


architecture behave of f_div_4hz is

signal cnt: integer range 0 to 6293749;

begin

process (clk)
			begin
				if clk'event and clk= '1' then
					if cnt < 6293749 then
							cnt<= cnt+1;
					else 
						cnt<= 0;
					end if;
					
					if cnt< 3146874 then 
						f_out<= '1';
					else
						f_out<= '0';
					end if;
				end if;

end process;

		end behave;