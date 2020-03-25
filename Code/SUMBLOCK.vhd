library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


Entity SUMBLOCK is
port ( P: in std_logic;
c: in std_logic;
sum : out std_logic);
end sumblock;
 architecture Behavioral of sumblock is
begin
sum <= (P xor c);-- after 200 ps;
end behavioral;