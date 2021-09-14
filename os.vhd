-- This code is a One-shot circuit with a pulse width of 1 second

library ieee;
use ieee.std_logic_1164.all;
entity os is	
	port (clk, trig: in bit;
		trig: in bit;
		os_out: out bit);
end;
architecture behave of os is
signal cnt: integer range 0 to 25175000;
signal ce, clr : bit;
	begin
		process (clr, clk, trig(
		begin
			if clr='1' then ce<='0';
			elsiftrig'event and trig='1' then
				ce<='1';
			end if;
	end process;

	process (clr,clk)
		begin
		if clr='1' then cnt<=0;
		elsifclk'event and clk='1' then
				if ce='1' then
					cnt<=cnt+1;
				end if;
		end if;
	end process;
	clr<='1' when cnt=25175000 else '0';
	os_out<=ce;
end behave;