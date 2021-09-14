-- This code generates a 100Hz PWM signal with 4 options for duty-cycle
-- and activates a 7-segment accordingly

library ieee;
use ieee.std_logic_1164.all;

entity ac_pwm is
	port (to_ac: in bit_vector (1 downto 0);
			clk: in bit;
			ac_out: out bit;
			seven_seg: out bit_vector (6 downto 0));
end ac_pwm;

architecture behave of ac_pwm is
signal num, cnt: integer range 0 to 251749;


begin
	process(clk)
		begin 
			if clk'event and clk='1' then	
				if cnt < 251749 then
				cnt <= cnt+1;
				else
				cnt <=0;
				end if;
				if cnt < num then
				ac_out <='1';
				else
				ac_out <='0';
				end if;
		        end if;
	end process;


with to_ac select
num <= 0 when "00",  -- 0% 
	201400 when "01", --80%
	226575 when "10", --90%
	249232 when "11"; --99%

with to_ac select
seven_seg <= "0111111" when "00", -- 0
			"0000110" when "01", -- 1
			"1011011" when "10", -- 2
			"1001111" when "11"; -- 3

end behave;
