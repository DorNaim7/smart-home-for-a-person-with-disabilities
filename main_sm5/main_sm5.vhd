-- The main state machine of the project

library ieee;
use ieee.std_logic_1164.all;
entity main_sm5 is
	port (rst, clk, pb: in bit;
	leds: out bit_vector (22 downto 0);
	to_tv, to_door: out bit;
	to_menora,  to_ac, to_tris: integer range 0 to 3);
end;
architecture behave of main_sm5 is
type state_type is (TV, tv_on, tv_on_do, tv_off, tv_off_do, tv_exit, menora,menora_up, menora_up_do, menora_down, menora_down_do, menora_off, menoraoff_do, 
menora_exit,  tris, tris_up, tris_up_do ,tris_down, tris_down_do, tris_stop, tris_stop_do, tris_exit, door, door_open, door_open_do, door_close, door_close_do,  door_exit,
ac, ac_up, ac_up_do, ac_down, ac_down_do, ac_off, ac_off_do, ac_exit);
signal state: state_type;
begin
	process (clk, rst)
		begin
			if rst='0' then
				to_menora<= 0;
				to_tris<= 0;
				to_ac<=0;
				to_tv<='1';
				to_door<='0';
				state<= TV;
	
			elsifclk'event and clk = '1' then
				case state is		
					when TV => if pb='1' then state<=tv_on; elsif pb= '0' then state<=tris; end if;
					when tv_on => if pb='1' then state<= tv_on_do; elsif pb= '0' then state<=tv_off; end if;
					when tv_on_do=>to_tv<='0';  state<= tv_off;
					when tv_off => if pb='1' then state<= tv_off_do; elsif pb= '0' then state<= tv_exit; end if;
					when tv_off_do=>to_tv<='1'; state<= tv_exit;
					when tv_exit => if pb='1' then state<= tris; elsif pb= '0' then state <=tv_on; end if;
					when tris=> if pb='1' then state<= tris_up; elsif pb= '0' then state<= ac; end if;
					when tris_up=> if pb='1' then state<= tris_up_do; elsif pb='0' then state<= tris_down; end if;
					when tris_up_do=> to_tris <= 1; state<= tris_down;
					when tris_down=> if pb='1' then state<= tris_down_do; elsif pb='0' then state<= tris_stop; end if;			
					when tris_down_do=> to_tris<=2; state<= tris_stop;
					when tris_stop=> if pb='1' then state<= tris_stop_do; elsif pb='0' then state<= tris_exit; end if;
					when tris_stop_do=> to_tris <=0; state<= tris_exit;
					when tris_exit=> if pb='1' then state<= ac; elsif pb= '0' then state<=tris_up; end if;
					when ac => if pb='1' then state<= ac_up; elsifpb= '0' then state<= menora; end if;
					when ac_up=> if pb='1' then state<= ac_up_do; elsifpb='0' then state<= ac_down; end if;
					when ac_up_do=> if to_ac<3 then to_ac<=to_ac+1; else to_ac<=3;end if; state<=ac_down;
					when ac_down=> if pb='1' then state<= ac_down_do; elsifpb='0' then state<= ac_off; end if;
					when ac_down_do=> if to_ac>0 then to_ac<=to_ac-1; else to_ac<=0;end if; state<= ac_off;
					when ac_off=> if pb='1' then state<= ac_off_do; elsifpb='0' then state<= ac_exit;end if;
					when ac_off_do=>to_ac<=0; state<= ac_exit;
					when ac_exit=> if pb='1' then state<=menora; elsifpb= '0' then  state<= ac_up; end if;	
					when menora=> if pb='1' then state<=menora_up; elsifpb= '0' then state<= door; end if; 
					when menora_up=> if pb='1' then state<= menora_up_do; elsifpb='0' then state<=menora_down; end if; 
					when menora_up_do=>ifto_menora<3 then to_menora<= to_menora+1; else to_menora<= 3; end if; state<= menora_down;
					when menora_down=> if pb='1' then state<= menora_down_do; elsifpb='0' then state<= menora_off; end if;
					when menora_down_do=> if to_menora>0 then to_menora<= to_menora-1; else to_menora<= 0 ; end if; state<= menora_off;
					when menora_off=> if pb='1' then state<= menora_off_do; elsifpb='0' then state<= menora_exit; end if; 
					when menora_off_do=>to_menora<=0; state<=menora_exit;
					when menora_exit=> if pb='1' then state<= door; elsifpb= '0' then state<= menora_up; end if; 
					when door=> if pb='1' then state<= door_open; elsifpb= '0' then state<= TV; end if; 
					when door_open=> if pb='1' then state<= door_open_do; elsifpb='0' then state<= door_close; end if; 
					when door_open_do=>to_door<= '1'; state<= door_close;
					when door_close_do=>to_door<= '0';  state<=door_exit;
					when door_exit=> if pb= '1' then state <= TV; elsifpb= '0' then state<= door_open; end if; 
				end case;
			end if;
	end process;

		with state select
		leds<= 	"11111111111111111111110" when TV,
				"11111111111111111111100" when tv_on | tv_on_do,
				"11111111111111111111010" when tv_off | tv_off_do,
				"11111111111111111110110" when tv_exit,
				"11111111111111111101111" when tris,
				"11111111111111111001111" when tris_up | tris_up_do,
				"11111111111111110101111" when tris_down|tris_down_do,
				"11111111111111101101111" when tris_stop| tris_stop_do,
				"11111111111111011101111" when tris_exit,	
				"11111111111110111111111" when ac,
				"11111111111100111111111" when ac_up|ac_up_do,
				"11111111111010111111111" when ac_down|ac_down_do,
				"11111111110110111111111" when ac_off| ac_off_do,
				"11111111101110111111111" when ac_exit,		
				"11111111011111111111111" when menora,
				"11111110011111111111111" when menora_up| menora_up_do,
				"11111101011111111111111" when menora_down | menora_down_do,
				"11111011011111111111111" when menora_off | menora_off_do,
				"11110111011111111111111" when menora_exit,
				"11101111111111111111111" when door,
				"11001111111111111111111" when door_open | door_open_do,
				"10101111111111111111111" when door_close| door_close_do,
				"01101111111111111111111" when door_exit;
end behave;