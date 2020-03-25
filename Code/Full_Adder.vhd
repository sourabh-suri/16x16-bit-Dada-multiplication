library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


Entity Full_Adder is
	Port	(	a_f : in STD_LOGIC;
				b_f : in STD_LOGIC;
				cin_f : in STD_LOGIC;
				s_f : out STD_LOGIC;
				co_f : out STD_LOGIC);
end Full_Adder;
architecture Behavioral of Full_Adder is
begin
s_f <= (a_f xor b_f xor cin_f) after 400 ps;
co_f <= (a_f and b_f) or (cin_f and b_f) or (a_f and cin_f) after 400 ps;
end behavioral;


