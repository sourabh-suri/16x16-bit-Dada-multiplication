library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Dot_Operator is
port (g_i : in std_logic;
 p_i : in std_logic;
 g_j : in std_logic;
 p_j : in std_logic;
 G : out STD_LOGIC;
 P : out STD_LOGIC);
end Dot_Operator ;
architecture Behavioral of Dot_Operator is
begin
G <=( g_i or(p_i and g_j)) ;--after 300 ps ;--(A+B.C)' + Inverter
P <= (p_i and p_j) ;--after 250 ps;
End behavioral;