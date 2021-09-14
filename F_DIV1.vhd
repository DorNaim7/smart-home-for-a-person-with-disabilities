-- Frequency divider by 25.175M to create a 1hz frequency signal

library ieee;
use ieee.std_logic_1164.all;
entity f_div1 is
	port (clk: in bit;
	f_out: out bit);
end f_div1;
architecture behave of f_div1 is
	signal cnt: integer range 0 to 12587499;
	signal f_out_tmp: bit;
begin
	process(clk)
		begin
			if clk'event and clk= '1' then 		
				if cnt< 12587499 then  
				cnt<= cnt+1;
				else
				cnt<=0;
				f_out_tmp<= not f_out_tmp;
				end if;
				end if;
	end process;
f_out<=f_out_tmp;
end behave;			