
library ieee;
use ieee.std_logic_1164.all;
 
entity Test_Bench is
end Test_Bench;
 
architecture behave of Test_Bench is
  signal input1 : STD_LOGIC_VECTOR (15 downto 0);
  signal input2 : STD_LOGIC_VECTOR (15 downto 0);
  signal output: STD_LOGIC_VECTOR (31 downto 0);
   
   
component Dadda_Mul is
 Port 	(	m : in STD_LOGIC_VECTOR (15 downto 0);
			n : in STD_LOGIC_VECTOR (15 downto 0);
			Product : out STD_LOGIC_VECTOR (31 downto 0)
		);
end component Dadda_Mul;


begin
   
   
  INST : Dadda_Mul
    port map (
      m    => input1,
      n    => input2,
      Product => output);
 
  process is
  begin

   input1 <= "1111111111111111";
    input2 <= "0000011110000001";

  end process;
     
end behave;