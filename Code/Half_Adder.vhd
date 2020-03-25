library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity Half_Adder is
 Port	(	a_h : in STD_LOGIC;
			b_h : in STD_LOGIC;
			s_h : out STD_LOGIC;
			c_h : out STD_LOGIC
		);
end Half_Adder;
architecture Behavioral of Half_Adder is
begin
s_h <= (a_h xor b_h) after 200 ps;
c_h <= (a_h and b_h) after 250 ps;
end behavioral;

