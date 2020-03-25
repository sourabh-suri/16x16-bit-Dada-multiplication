library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 
Entity pgblock is
Port ( a_i: in std_logic;
 b_i: in std_logic;
g_i : out std_logic;
p_i: out std_logic);
end pgblock;
architecture Behavioral of pgblock is
begin
g_i <=( a_i and b_i);-- after 250 ps; -- AND = NAND + Inverter
p_i <= (a_i xor b_i);-- after 200 ps;
end behavioral;