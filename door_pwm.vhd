-- This code generates a 100Hz PWM signal for a servo motor
-- which enables it to be at a 0 or at a 90 degrees angle

library ieee;
use ieee.std_logic_1164.all;

entity door_pwm is

		port (to_door, clk: in bit;
				door_out: out bit);

end door_pwm;

architecture behave of door_pwm is

signal num, cnt: integer range 0 to 251749;

begin 

		process (clk)
				begin
					if clk'event and clk = '1' then
						if cnt < 251749 then
							cnt <= cnt+1;
						else
							cnt<= 0;
						end if;
						
						if cnt<num then
							door_out<= '1';
						else
							door_out <= '0';
						end if;
					end if;
		end process;
with to_door select

num <= 10070 when '0',--0.4msec, 4%, 0deg
	50350 when '1';--2msec, 20%, 90deg



end behave;
