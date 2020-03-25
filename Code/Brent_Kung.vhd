library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Brent_Kung is
 Port ( a : in STD_LOGIC_VECTOR (31 downto 0);
 b : in STD_LOGIC_VECTOR (31 downto 0);
 c : in STD_LOGIC;
 sum : out STD_LOGIC_VECTOR (31 downto 0);
 cout : out STD_LOGIC);
end Brent_Kung;
architecture Behavioral of Brent_Kung is

--component buffer1 is
 --Port (G : in std_logic;
--c : out std_logic);
--end component;

Component Dot_Operator is
 Port ( g_i : in std_logic;
 p_i : in std_logic;
 g_j : in std_logic;
 p_j : in std_logic;
 G : out STD_LOGIC;
 P : out STD_LOGIC);
end Component;

Component pgblock is
 Port ( a_i : in STD_LOGIC;
 b_i : in STD_LOGIC;
 g_i : out STD_LOGIC;
 p_i : out STD_LOGIC);
end Component;


component SUMBLOCK is
port ( P : in std_logic;
c : in std_logic;
sum : out std_logic);
end component;

component Carry_generator is
port (g_i : in std_logic;
 p_i : in std_logic;
 c_0 : in std_logic;
 C_i : out STD_LOGIC);
end component ;

signal G0,P0: std_logic_vector(31 downto 0); -- G&Ps of stage 0
signal G1,P1: std_logic_vector(15 downto 0); -- G&Ps of stage 1
signal G2, P2: std_logic_vector(7 downto 0); -- G&Ps of stage 2
signal G3,P3 : std_logic_vector(3 downto 0); -- G&Ps of stage 3
signal G4,P4 : std_logic_vector(1 downto 0); -- G&Ps of stage 4
signal G5,P5 : std_logic;		     -- G&Ps of stage 5
signal G6,P6: std_logic;		     -- G&Ps of stage 6
signal G7,P7 : std_logic_vector(2 downto 0); -- G&Ps of stage 7
signal G8,P8 : std_logic_vector(6 downto 0); -- G&Ps of stage 8
signal G9,P9: std_logic_vector(14 downto 0); -- G&Ps of stage 9
signal c_i : std_logic_vector(31 downto 0);  -- Carry for each bit
signal k : std_logic_vector(31 downto 0); 
begin


	PG_Block: for I in 0 to 31 generate
         Block_PG :  pgblock port map
              ( a(I), b(I), G0(I), P0(I) );
         end generate PG_Block;

	Dot_Block_Stage1: for I in 0 to 15 generate
         Block_Dot_1 :  Dot_Operator port map
              ( G0(2*I+1), P0(2*I+1), G0(2*I), P0(2*I), G1(I), P1(I) );
         end generate Dot_Block_Stage1;

	Dot_Block_Stage2: for I in 0 to 7 generate
         Block_Dot_2 :  Dot_Operator port map
              ( G1(2*I+1), P1(2*I+1), G1(2*I), P1(2*I),  G2(I), P2(I) );
         end generate Dot_Block_Stage2;

	Dot_Block_Stage3: for I in 0 to 3 generate
         Block_Dot_3 :  Dot_Operator port map
              (  G2(2*I+1), P2(2*I+1), G2(2*I), P2(2*I), G3(I), P3(I) );
         end generate Dot_Block_Stage3;

	Dot_Block_Stage4: for I in 0 to 1 generate
         Block_Dot_4 :  Dot_Operator port map
              ( G3(2*I+1), P3(2*I+1), G3(2*I), P3(2*I), G4(I), P4(I) );
         end generate Dot_Block_Stage4;

	 Dot_Block_Stage5:  Dot_Operator port map
              ( G4(1), P4(1), G4(0), P4(0), G5, P5 );
        
	 Dot_Block_Stage6:  Dot_Operator port map
              ( G3(2), P3(2), G4(0), P4(0), G6, P6 );


	 Dot_Block_Stage7_1:  Dot_Operator port map
              ( G3(0), P3(0), G2(2), P2(2),  G7(0), P7(0) );
	 Dot_Block_Stage7_2:  Dot_Operator port map
              ( G2(4), P2(4), G4(0), P4(0), G7(1), P7(1) );
	 Dot_Block_Stage7_3:  Dot_Operator port map
              ( G2(6), P2(6), G6, P6, G7(2), P7(2) );


	 Dot_Block_Stage8_1:  Dot_Operator port map
              ( G1(2), P1(2), G2(0), P2(0), G8(0), P8(0) );
	 Dot_Block_Stage8_2:  Dot_Operator port map
              ( G1(4), P1(4), G3(0), P3(0), G8(1), P8(1) );
	 Dot_Block_Stage8_3:  Dot_Operator port map
              (  G1(6), P1(6), G7(0), P7(0), G8(2), P8(2) );
	 Dot_Block_Stage8_4:  Dot_Operator port map
              ( G1(8), P1(8), G4(0), P4(0), G8(3), P8(3) );
	 Dot_Block_Stage8_5:  Dot_Operator port map
              (  G1(10), P1(10), G7(1), P7(1), G8(4), P8(4) );
	 Dot_Block_Stage8_6:  Dot_Operator port map
              ( G1(12), P1(12), G6, P6, G8(5), P8(5) );
	 Dot_Block_Stage8_7:  Dot_Operator port map
              ( G1(14), P1(14), G7(2), P7(2), G8(6), P8(6) );




	Dot_Block_Stage9: for I in 0 to 6 generate
         Block_Dot_4 :  Dot_Operator port map
              ( G0(4*I+6), P0(4*I+6), G8(I), P8(I), G9(2*I+2), P9(2*I+2) );
         end generate Dot_Block_Stage9;


         Dot_Block_Stage9_0:  Dot_Operator port map
              (G0(2), P0(2), G1(0), P1(0), G9(0), P9(0) );
	 Dot_Block_Stage9_1:  Dot_Operator port map
              (  G0(4), P0(4), G2(0), P2(0), G9(1), P9(1) );
	 Dot_Block_Stage9_3:  Dot_Operator port map
              (  G0(8), P0(8), G3(0), P3(0), G9(3), P9(3) );
	 Dot_Block_Stage9_5:  Dot_Operator port map
              ( G0(12), P0(12), G7(0), P7(0), G9(5), P9(5) );
	 Dot_Block_Stage9_7:  Dot_Operator port map
              (  G0(16), P0(16), G4(0), P4(0), G9(7), P9(7) );
	 Dot_Block_Stage9_9:  Dot_Operator port map
              (  G0(20), P0(20), G7(1), P7(1), G9(9), P9(9) );
	 Dot_Block_Stage9_11:  Dot_Operator port map
              ( G0(24), P0(24),  G6, P6, G9(11), P9(11) );
	 Dot_Block_Stage9_13:  Dot_Operator port map
              ( G0(28), P0(28), G7(2), P7(2), G9(13), P9(13) );


	Carry_generator_even: for I in 0 to 14 generate
         Carry :  Carry_generator port map
              ( G9(I), P9(I), c, c_i(2*I+2) );
         end generate Carry_generator_even;


	 Carry_generator_0:  Carry_generator port map
              ( G0(0), P0(0), c, c_i(0) );
	 Carry_generator_1:  Carry_generator port map
              ( G1(0), P1(0), c, c_i(1) );
	 Carry_generator_3:  Carry_generator port map
              ( G2(0), P2(0), c, c_i(3) );
	 Carry_generator_5:  Carry_generator port map
              ( G8(0), P8(0), c, c_i(5) );
	 Carry_generator_7:  Carry_generator port map
              ( G3(0), P3(0), c, c_i(7) );
	 Carry_generator_9:  Carry_generator port map
              ( G8(1), P8(1), c, c_i(9) );
	 Carry_generator_11:  Carry_generator port map
              ( G7(0), P7(0), c, c_i(11) );
	 Carry_generator_13:  Carry_generator port map
              ( G8(2), P8(2), c, c_i(13) );
	 Carry_generator_15:  Carry_generator port map
              ( G4(0), P4(0), c, c_i(15) );
	 Carry_generator_17:  Carry_generator port map
              ( G8(3), P8(3), c, c_i(17) );
	 Carry_generator_19:  Carry_generator port map
              ( G7(1), P7(1), c, c_i(19) );
	 Carry_generator_21:  Carry_generator port map
              ( G8(4), P8(4), c, c_i(21) );
	 Carry_generator_23:  Carry_generator port map
              ( G6, P6, c, c_i(23) );
	 Carry_generator_25:  Carry_generator port map
              ( G8(5), P8(5), c, c_i(25) );
	 Carry_generator_27:  Carry_generator port map
              ( G7(2), P7(2), c, c_i(27) );
	 Carry_generator_29:  Carry_generator port map
              ( G8(6), P8(6), c, c_i(29) );
	 Carry_generator_31:  Carry_generator port map
              ( G5, P5, c, c_i(31) );

	 Sum_0:  SUMBLOCK port map
              ( P0(0), c, k(0) );
 
	 Sum_generator: for I in 1 to 31 generate
         Sum :  SUMBLOCK port map
              ( P0(I), c_i(I-1), k(I) );
         end generate Sum_generator;

sum<=k;
cout<=c_i(31);
end behavioral;