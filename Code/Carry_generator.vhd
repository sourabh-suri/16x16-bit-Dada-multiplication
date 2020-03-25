library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Carry_generator is
port (g_i : in std_logic;
 p_i : in std_logic;
 c_0 : in std_logic;
 C_i : out STD_LOGIC);
end Carry_generator ;
architecture Behavioral of Carry_generator is
begin
C_i <=( g_i or(p_i and c_0));-- after 300 ps ;--(A+B.C)' + Inverter
End behavioral;