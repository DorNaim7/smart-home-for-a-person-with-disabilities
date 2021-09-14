-- This code generates a 100Hz PWM signal with 4 options for duty-cycle as a function of the input

library ieee;
use ieee.std_logic_1164.all;

entity menora_pwm is

	port (to_menora: in bit_vector (1 downto 0);
			clk: in bit;
			menora_out: out bit);

end menora_pwm;

architecture behave of menora_pwm is

signal cnt, num: integer range 0 to 251749;

begin

		process (clk)
			begin
					if clk'event and clk='1' then
						if cnt< 251749 then
								cnt<= cnt+1;
						else
							cnt<= 0;
						end if;
						
						if cnt<num then 
							menora_out<= '1';
						else 
							menora_out<= '0';
						end if;
					end if;

		end process;

with to_menora select

num<= 	0 		when "00",--0%
		100700 	when "01",-- 40%
		201400	when "10",-- 80%
		249232	when others;-- 99%

end behave;