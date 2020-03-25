library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


Entity And_1bit is
	Port	(	a : in STD_LOGIC;
				b : in STD_LOGIC;
				output : out STD_LOGIC
			);
end And_1bit;
architecture Behavioral of And_1bit is
begin
output <= a and b after 250 ps;
end behavioral;
