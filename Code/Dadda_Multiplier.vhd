library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Dadda_Mul is
 Port 	(	m : in STD_LOGIC_VECTOR (15 downto 0);
			n : in STD_LOGIC_VECTOR (15 downto 0);
			Product : out STD_LOGIC_VECTOR (31 downto 0)
		);
end Dadda_Mul;

architecture Behavioral of Dadda_Mul is


Component Half_Adder is
 Port	(	a_h : in STD_LOGIC;
			b_h : in STD_LOGIC;
			s_h : out STD_LOGIC;
			c_h : out STD_LOGIC
		);
end Component;

Component Full_Adder is
	Port	(	a_f : in STD_LOGIC;
				b_f : in STD_LOGIC;
				cin_f : in STD_LOGIC;
				s_f : out STD_LOGIC;
				co_f : out STD_LOGIC
			);
end Component;

Component And_1bit is
	Port	(	a : in STD_LOGIC;
				b : in STD_LOGIC;
				output : out STD_LOGIC
			);
end Component;

Component Brent_Kung is
 Port 	( 	a : in STD_LOGIC_VECTOR (31 downto 0);
			b : in STD_LOGIC_VECTOR (31 downto 0);
			c : in STD_LOGIC;
			sum : out STD_LOGIC_VECTOR (31 downto 0);
			cout : out STD_LOGIC
		);
end Component;


signal input1_final2bits : STD_LOGIC_VECTOR (31 downto 0);
signal input2_final2bits :STD_LOGIC_VECTOR (31 downto 0);
signal sum_32 :STD_LOGIC_VECTOR (31 downto 0);
signal cout_32 :STD_LOGIC;
signal cin_0 :STD_LOGIC;

signal P0: std_logic; 		--Partial Product at zero_th bit
signal P1: std_logic_vector(1 downto 0); -- Ps of stage 1
signal P2: std_logic_vector(2 downto 0); -- Ps of stage 2
signal P3: std_logic_vector(3 downto 0); --Ps of stage 3
signal P4: std_logic_vector(4 downto 0); --Ps of stage 4
signal P5: std_logic_vector(5 downto 0); -- Ps of stage 5
signal P6: std_logic_vector(6 downto 0);  -- Ps of stage 6
signal P7: std_logic_vector(7 downto 0); -- Ps of stage 7
signal P8: std_logic_vector(8 downto 0); --Ps of stage 8
signal P9: std_logic_vector(9 downto 0); --Ps of stage 9

signal P10:  std_logic_vector(10 downto 0); -- Ps of stage 10
signal P11:  std_logic_vector(11 downto 0); -- Ps of stage 11
signal P12:  std_logic_vector(12 downto 0); -- Ps of stage 12
signal P13: std_logic_vector(13 downto 0); -- Ps of stage 13
signal P14: std_logic_vector(14 downto 0); -- Ps of stage 14
signal P15: std_logic_vector(15 downto 0); -- Ps of stage 15
signal P16:  std_logic_vector(14 downto 0); -- Ps of stage 16
signal P17: std_logic_vector(13 downto 0); -- Ps of stage 17
signal P18: std_logic_vector(12 downto 0); -- G&Ps of stage 18
signal P19:  std_logic_vector(11 downto 0); -- G&Ps of stage 19

signal P20: std_logic_vector(10 downto 0); -- Ps of stage 20
signal P21: std_logic_vector(9 downto 0); -- Ps of stage 21
signal P22: std_logic_vector(8 downto 0); -- Ps of stage 22
signal P23: std_logic_vector(7 downto 0); --Ps of stage 23
signal P24: std_logic_vector(6 downto 0); --Ps of stage 24
signal P25: std_logic_vector(5 downto 0);-- Ps of stage 25
signal P26: std_logic_vector(4 downto 0);-- Ps of stage 26
signal P27: std_logic_vector(3 downto 0); --Ps of stage 27
signal P28: std_logic_vector(2 downto 0); --Ps of stage 28
signal P29: std_logic_vector(1 downto 0); -- Ps of stage 29
signal P30: std_logic; --Ps of stage 30
signal P31: std_logic;-- P of stage 31


------------------------------------------Signal Wires for Reduction stage from 16 to 11--------------------------------
signal PP11:  std_logic_vector(10 downto 0); -- PPs of stage 11
signal PP12:  std_logic_vector(10 downto 0); -- PPs of stage 12
signal PP13: std_logic_vector(10 downto 0); -- PPs of stage 13
signal PP14: std_logic_vector(10 downto 0); -- PPs of stage 14
signal PP15: std_logic_vector(10 downto 0); -- PPs of stage 15
signal PP16:  std_logic_vector(10 downto 0); -- PPs of stage 16
signal PP17: std_logic_vector(10 downto 0); -- PPs of stage 17
signal PP18: std_logic_vector(10 downto 0); -- G&PPs of stage 18
signal PP19:  std_logic_vector(10 downto 0); -- G&PPs of stage 19
signal PP20: std_logic_vector(10 downto 0); -- PPs of stage 20
signal PP21: std_logic_vector(10 downto 0); -- PPs of stage 21


------------------------------------------Signal Wires for Reduction stage from 11 to 8--------------------------------
signal PPP8: std_logic_vector(7 downto 0); --PPPs of stage 8
signal PPP9: std_logic_vector(7 downto 0); --PPPs of stage 9
signal PPP10:  std_logic_vector(7 downto 0); -- PPPs of stage 10
signal PPP11:  std_logic_vector(7 downto 0); -- PPPs of stage 11
signal PPP12:  std_logic_vector(7 downto 0); -- PPPs of stage 12
signal PPP13: std_logic_vector(7 downto 0); -- PPPs of stage 13
signal PPP14: std_logic_vector(7 downto 0); -- PPPs of stage 14
signal PPP15: std_logic_vector(7 downto 0); -- PPPs of stage 15
signal PPP16:  std_logic_vector(7 downto 0); -- PPPs of stage 16
signal PPP17: std_logic_vector(7 downto 0); -- PPPs of stage 17
signal PPP18: std_logic_vector(7 downto 0); -- G&PPPs of stage 18
signal PPP19:  std_logic_vector(7 downto 0); -- G&PPPs of stage 19
signal PPP20: std_logic_vector(7 downto 0); -- PPPs of stage 20
signal PPP21: std_logic_vector(7 downto 0); -- PPPs of stage 21
signal PPP22: std_logic_vector(7 downto 0); -- PPPs of stage 22
signal PPP23: std_logic_vector(7 downto 0); -- PPPs of stage 22
signal PPP24: std_logic_vector(7 downto 0); -- PPPs of stage 22

------------------------------------------Signal Wires for Reduction stage from 8 to 6--------------------------------
signal PPPP6: std_logic_vector(5 downto 0); --PPPPs of stage 6
signal PPPP7: std_logic_vector(5 downto 0); --PPPPs of stage 7
signal PPPP8: std_logic_vector(5 downto 0); --PPPPs of stage 8
signal PPPP9: std_logic_vector(5 downto 0); --PPPPs of stage 9
signal PPPP10:  std_logic_vector(5 downto 0); -- PPPPs of stage 10
signal PPPP11:  std_logic_vector(5 downto 0); -- PPPPs of stage 11
signal PPPP12:  std_logic_vector(5 downto 0); -- PPPPs of stage 12
signal PPPP13: std_logic_vector(5 downto 0); -- PPPPs of stage 13
signal PPPP14: std_logic_vector(5 downto 0); -- PPPPs of stage 14
signal PPPP15: std_logic_vector(5 downto 0); -- PPPPs of stage 15
signal PPPP16:  std_logic_vector(5 downto 0); -- PPPPs of stage 16
signal PPPP17: std_logic_vector(5 downto 0); -- PPPPs of stage 17
signal PPPP18: std_logic_vector(5 downto 0); -- G&PPPPs of stage 18
signal PPPP19:  std_logic_vector(5 downto 0); -- G&PPPPs of stage 19
signal PPPP20: std_logic_vector(5 downto 0); -- PPPPs of stage 20
signal PPPP21: std_logic_vector(5 downto 0); -- PPPPs of stage 21
signal PPPP22: std_logic_vector(5 downto 0); -- PPPPs of stage 22
signal PPPP23: std_logic_vector(5 downto 0); -- PPPPs of stage 23
signal PPPP24: std_logic_vector(5 downto 0); -- PPPPs of stage 24
signal PPPP25: std_logic_vector(5 downto 0); -- PPPPs of stage 25
signal PPPP26: std_logic_vector(5 downto 0); -- PPPPs of stage 26

------------------------------------------Signal Wires for Reduction stage from 6 to 4--------------------------------

signal Pfive4:  std_logic_vector(3 downto 0); --Pfives of stage 4
signal Pfive5:  std_logic_vector(3 downto 0); -- Pfives of stage 5
signal Pfive6:  std_logic_vector(3 downto 0);  -- Pfives of stage 6
signal Pfive7:  std_logic_vector(3 downto 0); -- Pfives of stage 7
signal Pfive8:  std_logic_vector(3 downto 0); --Pfives of stage 8
signal Pfive9:  std_logic_vector(3 downto 0); --Pfives of stage 9
signal Pfive10: std_logic_vector(3 downto 0); -- Pfives of stage 10
signal Pfive11: std_logic_vector(3 downto 0); -- Pfives of stage 11
signal Pfive12: std_logic_vector(3 downto 0); -- Pfives of stage 12
signal Pfive13: std_logic_vector(3 downto 0); -- Pfives of stage 13
signal Pfive14: std_logic_vector(3 downto 0); -- Pfives of stage 14
signal Pfive15: std_logic_vector(3 downto 0); -- Pfives of stage 15
signal Pfive16: std_logic_vector(3 downto 0); -- Pfives of stage 16
signal Pfive17: std_logic_vector(3 downto 0); -- Pfives of stage 17
signal Pfive18: std_logic_vector(3 downto 0); -- G&Pfives of stage 18
signal Pfive19: std_logic_vector(3 downto 0); -- G&Pfives of stage 19
signal Pfive20: std_logic_vector(3 downto 0); -- Pfives of stage 20
signal Pfive21: std_logic_vector(3 downto 0); -- Pfives of stage 21
signal Pfive22: std_logic_vector(3 downto 0); -- Pfives of stage 22
signal Pfive23: std_logic_vector(3 downto 0); --Pfives of stage 23
signal Pfive24: std_logic_vector(3 downto 0); --Pfives of stage 24
signal Pfive25: std_logic_vector(3 downto 0);-- Pfives of stage 25
signal Pfive26: std_logic_vector(3 downto 0);-- Pfives of stage 26
signal Pfive27: std_logic_vector(3 downto 0); --Pfives of stage 27
signal Pfive28: std_logic_vector(3 downto 0); --Pfives of stage 28

------------------------------------------Signal Wires for Reduction stage from 4 to 3--------------------------------

signal Psix3:  std_logic_vector(2 downto 0); --Psixs of stage 3
signal Psix4:  std_logic_vector(2 downto 0); --Psixs of stage 4
signal Psix5:  std_logic_vector(2 downto 0); -- Psixs of stage 5
signal Psix6:  std_logic_vector(2 downto 0);  -- Psixs of stage 6
signal Psix7:  std_logic_vector(2 downto 0); -- Psixs of stage 7
signal Psix8:  std_logic_vector(2 downto 0); --Psixs of stage 8
signal Psix9:  std_logic_vector(2 downto 0); --Psixs of stage 9
signal Psix10: std_logic_vector(2 downto 0); -- Psixs of stage 10
signal Psix11: std_logic_vector(2 downto 0); -- Psixs of stage 11
signal Psix12: std_logic_vector(2 downto 0); -- Psixs of stage 12
signal Psix13: std_logic_vector(2 downto 0); -- Psixs of stage 13
signal Psix14: std_logic_vector(2 downto 0); -- Psixs of stage 14
signal Psix15: std_logic_vector(2 downto 0); -- Psixs of stage 15
signal Psix16: std_logic_vector(2 downto 0); -- Psixs of stage 16
signal Psix17: std_logic_vector(2 downto 0); -- Psixs of stage 17
signal Psix18: std_logic_vector(2 downto 0); -- G&Psixs of stage 18
signal Psix19: std_logic_vector(2 downto 0); -- G&Psixs of stage 19
signal Psix20: std_logic_vector(2 downto 0); -- Psixs of stage 20
signal Psix21: std_logic_vector(2 downto 0); -- Psixs of stage 21
signal Psix22: std_logic_vector(2 downto 0); -- Psixs of stage 22
signal Psix23: std_logic_vector(2 downto 0); --Psixs of stage 23
signal Psix24: std_logic_vector(2 downto 0); --Psixs of stage 24
signal Psix25: std_logic_vector(2 downto 0);-- Psixs of stage 25
signal Psix26: std_logic_vector(2 downto 0);-- Psixs of stage 26
signal Psix27: std_logic_vector(2 downto 0); --Psixs of stage 27
signal Psix28: std_logic_vector(2 downto 0); --Psixs of stage 28
signal Psix29: std_logic_vector(2 downto 0); --Psixs of stage 29

------------------------------------------Signal Wires for Reduction stage from 3 to 2--------------------------------

signal Pfinal2:  std_logic_vector(1 downto 0); --Pfinals of stage 2
signal Pfinal3:  std_logic_vector(1 downto 0); --Pfinals of stage 3
signal Pfinal4:  std_logic_vector(1 downto 0); --Pfinals of stage 4
signal Pfinal5:  std_logic_vector(1 downto 0); -- Pfinals of stage 5
signal Pfinal6:  std_logic_vector(1 downto 0);  -- Pfinals of stage 6
signal Pfinal7:  std_logic_vector(1 downto 0); -- Pfinals of stage 7
signal Pfinal8:  std_logic_vector(1 downto 0); --Pfinals of stage 8
signal Pfinal9:  std_logic_vector(1 downto 0); --Pfinals of stage 9
signal Pfinal10: std_logic_vector(1 downto 0); -- Pfinals of stage 10
signal Pfinal11: std_logic_vector(1 downto 0); -- Pfinals of stage 11
signal Pfinal12: std_logic_vector(1 downto 0); -- Pfinals of stage 12
signal Pfinal13: std_logic_vector(1 downto 0); -- Pfinals of stage 13
signal Pfinal14: std_logic_vector(1 downto 0); -- Pfinals of stage 14
signal Pfinal15: std_logic_vector(1 downto 0); -- Pfinals of stage 15
signal Pfinal16: std_logic_vector(1 downto 0); -- Pfinals of stage 16
signal Pfinal17: std_logic_vector(1 downto 0); -- Pfinals of stage 17
signal Pfinal18: std_logic_vector(1 downto 0); -- G&Pfinals of stage 18
signal Pfinal19: std_logic_vector(1 downto 0); -- G&Pfinals of stage 19
signal Pfinal20: std_logic_vector(1 downto 0); -- Pfinals of stage 20
signal Pfinal21: std_logic_vector(1 downto 0); -- Pfinals of stage 21
signal Pfinal22: std_logic_vector(1 downto 0); -- Pfinals of stage 22
signal Pfinal23: std_logic_vector(1 downto 0); --Pfinals of stage 23
signal Pfinal24: std_logic_vector(1 downto 0); --Pfinals of stage 24
signal Pfinal25: std_logic_vector(1 downto 0);-- Pfinals of stage 25
signal Pfinal26: std_logic_vector(1 downto 0);-- Pfinals of stage 26
signal Pfinal27: std_logic_vector(1 downto 0); --Pfinals of stage 27
signal Pfinal28: std_logic_vector(1 downto 0); --Pfinals of stage 28
signal Pfinal29: std_logic_vector(1 downto 0); --Pfinals of stage 29
signal Pfinal30: std_logic_vector(1 downto 0); --Pfinals of stage 30


----------------------------------------Partial Product Generation-------------------------
Begin 

Final_Addition:  Brent_Kung port map 
	 	 	( input1_final2bits, input2_final2bits, cin_0 , sum_32, cout_32 );
Product <= sum_32; 


Partial_Product_P0_0:  And_1bit port map
	 	 	 	 	( m(0), n(0), P0 );
Partial_Product_P1_0:  And_1bit port map
	 	 	 	 	( m(1), n(0), P1(0) );
Partial_Product_P2_0:  And_1bit port map
	 	 	 	 	( m(2), n(0), P2(0) );
Partial_Product_P3_0:  And_1bit port map
	 	 	 	 	( m(3), n(0), P3(0) );
Partial_Product_P4_0:  And_1bit port map
	 	 	 	 	( m(4), n(0), P4(0) );
Partial_Product_P5_0:  And_1bit port map
	 	 	 	 	( m(5), n(0), P5(0) );
Partial_Product_P6_0:  And_1bit port map
	 	 	 	 	( m(6), n(0), P6(0) );
Partial_Product_P7_0:  And_1bit port map
	 	 	 	 	( m(7), n(0), P7(0) );
Partial_Product_P8_0:  And_1bit port map
	 	 	 	 	( m(8), n(0), P8(0) );
Partial_Product_P9_0:  And_1bit port map
	 	 	 	 	( m(9), n(0), P9(0) );
Partial_Product_P10_0:  And_1bit port map
	 	 	 	 	( m(10), n(0), P10(0) );
Partial_Product_P11_0:  And_1bit port map
	 	 	 	 	( m(11), n(0), P11(0) );
Partial_Product_P12_0:  And_1bit port map
	 	 	 	 	( m(12), n(0), P12(0) );
Partial_Product_P13_0:  And_1bit port map
	 	 	 	 	( m(13), n(0), P13(0) );
Partial_Product_P14_0:  And_1bit port map
	 	 	 	 	( m(14), n(0), P14(0) );
Partial_Product_P15_0:  And_1bit port map
	 	 	 	 	( m(15), n(0), P15(0) );

Partial_Product_P1_1:  And_1bit port map
	 	 	 	 	( m(0), n(1), P1(1) );
Partial_Product_P2_1:  And_1bit port map
	 	 	 	 	( m(1), n(1), P2(1) );
Partial_Product_P3_1:  And_1bit port map
	 	 	 	 	( m(2), n(1), P3(1) );
Partial_Product_P4_1:  And_1bit port map
	 	 	 	 	( m(3), n(1), P4(1) );
Partial_Product_P5_1:  And_1bit port map
	 	 	 	 	( m(4), n(1), P5(1) );
Partial_Product_P6_1:  And_1bit port map
	 	 	 	 	( m(5), n(1), P6(1) );
Partial_Product_P7_1:  And_1bit port map
	 	 	 	 	( m(6), n(1), P7(1) );
Partial_Product_P8_1:  And_1bit port map
	 	 	 	 	( m(7), n(1), P8(1) );
Partial_Product_P9_1:  And_1bit port map
	 	 	 	 	( m(8), n(1), P9(1) );
Partial_Product_P10_1:  And_1bit port map
	 	 	 	 	( m(9), n(1), P10(1) );
Partial_Product_P11_1:  And_1bit port map
	 	 	 	 	( m(10), n(1), P11(1) );
Partial_Product_P12_1:  And_1bit port map
	 	 	 	 	( m(11), n(1), P12(1) );
Partial_Product_P13_1:  And_1bit port map
	 	 	 	 	( m(12), n(1), P13(1) );
Partial_Product_P14_1:  And_1bit port map
	 	 	 	 	( m(13), n(1), P14(1) );
Partial_Product_P15_1:  And_1bit port map
	 	 	 	 	( m(14), n(1), P15(1) );
Partial_Product_P16_1:  And_1bit port map
	 	 	 	 	( m(15), n(1), P16(0) );

Partial_Product_P2_2:  And_1bit port map
	 	 	 	 	( m(0), n(2), P2(2) );
Partial_Product_P3_2:  And_1bit port map
	 	 	 	 	( m(1), n(2), P3(2) );
Partial_Product_P4_2:  And_1bit port map
	 	 	 	 	( m(2), n(2), P4(2) );
Partial_Product_P5_2:  And_1bit port map
	 	 	 	 	( m(3), n(2), P5(2) );
Partial_Product_P6_2:  And_1bit port map
	 	 	 	 	( m(4), n(2), P6(2) );
Partial_Product_P7_2:  And_1bit port map
	 	 	 	 	( m(5), n(2), P7(2) );
Partial_Product_P8_2:  And_1bit port map
	 	 	 	 	( m(6), n(2), P8(2) );
Partial_Product_P9_2:  And_1bit port map
	 	 	 	 	( m(7), n(2), P9(2) );
Partial_Product_P10_2:  And_1bit port map
	 	 	 	 	( m(8), n(2), P10(2) );
Partial_Product_P11_2:  And_1bit port map
	 	 	 	 	( m(9), n(2), P11(2) );
Partial_Product_P12_2:  And_1bit port map
	 	 	 	 	( m(10), n(2), P12(2) );
Partial_Product_P13_2:  And_1bit port map
	 	 	 	 	( m(11), n(2), P13(2) );
Partial_Product_P14_2:  And_1bit port map
	 	 	 	 	( m(12), n(2), P14(2) );
Partial_Product_P15_2:  And_1bit port map
	 	 	 	 	( m(13), n(2), P15(2) );
Partial_Product_P16_2:  And_1bit port map
	 	 	 	 	( m(14), n(2), P16(1) );
Partial_Product_P17_2:  And_1bit port map
	 	 	 	 	( m(15), n(2), P17(0) );

Partial_Product_P3_3:  And_1bit port map
	 	 	 	 	( m(0), n(3), P3(3) );
Partial_Product_P4_3:  And_1bit port map
	 	 	 	 	( m(1), n(3), P4(3) );
Partial_Product_P5_3:  And_1bit port map
	 	 	 	 	( m(2), n(3), P5(3) );
Partial_Product_P6_3:  And_1bit port map
	 	 	 	 	( m(3), n(3), P6(3) );
Partial_Product_P7_3:  And_1bit port map
	 	 	 	 	( m(4), n(3), P7(3) );
Partial_Product_P8_3:  And_1bit port map
	 	 	 	 	( m(5), n(3), P8(3) );
Partial_Product_P9_3:  And_1bit port map
	 	 	 	 	( m(6), n(3), P9(3) );
Partial_Product_P10_3:  And_1bit port map
	 	 	 	 	( m(7), n(3), P10(3) );
Partial_Product_P11_3:  And_1bit port map
	 	 	 	 	( m(8), n(3), P11(3) );
Partial_Product_P12_3:  And_1bit port map
	 	 	 	 	( m(9), n(3), P12(3) );
Partial_Product_P13_3:  And_1bit port map
	 	 	 	 	( m(10), n(3), P13(3) );
Partial_Product_P14_3:  And_1bit port map
	 	 	 	 	( m(11), n(3), P14(3) );
Partial_Product_P15_3:  And_1bit port map
	 	 	 	 	( m(12), n(3), P15(3) );
Partial_Product_P16_3:  And_1bit port map
	 	 	 	 	( m(13), n(3), P16(2) );
Partial_Product_P17_3:  And_1bit port map
	 	 	 	 	( m(14), n(3), P17(1) );
Partial_Product_P18_3:  And_1bit port map
	 	 	 	 	( m(15), n(3), P18(0) );

Partial_Product_P4_4:  And_1bit port map
	 	 	 	 	( m(0), n(4), P4(4) );
Partial_Product_P5_4:  And_1bit port map
	 	 	 	 	( m(1), n(4), P5(4) );
Partial_Product_P6_4:  And_1bit port map
	 	 	 	 	( m(2), n(4), P6(4) );
Partial_Product_P7_4:  And_1bit port map
	 	 	 	 	( m(3), n(4), P7(4) );
Partial_Product_P8_4:  And_1bit port map
	 	 	 	 	( m(4), n(4), P8(4) );
Partial_Product_P9_4:  And_1bit port map
	 	 	 	 	( m(5), n(4), P9(4) );
Partial_Product_P10_4:  And_1bit port map
	 	 	 	 	( m(6), n(4), P10(4) );
Partial_Product_P11_4:  And_1bit port map
	 	 	 	 	( m(7), n(4), P11(4) );
Partial_Product_P12_4:  And_1bit port map
	 	 	 	 	( m(8), n(4), P12(4) );
Partial_Product_P13_4:  And_1bit port map
	 	 	 	 	( m(9), n(4), P13(4) );
Partial_Product_P14_4:  And_1bit port map
	 	 	 	 	( m(10), n(4), P14(4) );
Partial_Product_P15_4:  And_1bit port map
	 	 	 	 	( m(11), n(4), P15(4) );
Partial_Product_P16_4:  And_1bit port map
	 	 	 	 	( m(12), n(4), P16(3) );
Partial_Product_P17_4:  And_1bit port map
	 	 	 	 	( m(13), n(4), P17(2) );
Partial_Product_P18_4:  And_1bit port map
	 	 	 	 	( m(14), n(4), P18(1) );
Partial_Product_P19_4:  And_1bit port map
	 	 	 	 	( m(15), n(4), P19(0) );

Partial_Product_P5_5:  And_1bit port map
	 	 	 	 	( m(0), n(5), P5(5) );
Partial_Product_P6_5:  And_1bit port map
	 	 	 	 	( m(1), n(5), P6(5) );
Partial_Product_P7_5:  And_1bit port map
	 	 	 	 	( m(2), n(5), P7(5) );
Partial_Product_P8_5:  And_1bit port map
	 	 	 	 	( m(3), n(5), P8(5) );
Partial_Product_P9_5:  And_1bit port map
	 	 	 	 	( m(4), n(5), P9(5) );
Partial_Product_P10_5:  And_1bit port map
	 	 	 	 	( m(5), n(5), P10(5) );
Partial_Product_P11_5:  And_1bit port map
	 	 	 	 	( m(6), n(5), P11(5) );
Partial_Product_P12_5:  And_1bit port map
	 	 	 	 	( m(7), n(5), P12(5) );
Partial_Product_P13_5:  And_1bit port map
	 	 	 	 	( m(8), n(5), P13(5) );
Partial_Product_P14_5:  And_1bit port map
	 	 	 	 	( m(9), n(5), P14(5) );
Partial_Product_P15_5:  And_1bit port map
	 	 	 	 	( m(10), n(5), P15(5) );
Partial_Product_P16_5:  And_1bit port map
	 	 	 	 	( m(11), n(5), P16(4) );
Partial_Product_P17_5:  And_1bit port map
	 	 	 	 	( m(12), n(5), P17(3) );
Partial_Product_P18_5:  And_1bit port map
	 	 	 	 	( m(13), n(5), P18(2) );
Partial_Product_P19_5:  And_1bit port map
	 	 	 	 	( m(14), n(5), P19(1) );
Partial_Product_P20_5:  And_1bit port map
	 	 	 	 	( m(15), n(5), P20(0) );

Partial_Product_P6_6:  And_1bit port map
	 	 	 	 	( m(0), n(6), P6(6) );
Partial_Product_P7_6:  And_1bit port map
	 	 	 	 	( m(1), n(6), P7(6) );
Partial_Product_P8_6:  And_1bit port map
	 	 	 	 	( m(2), n(6), P8(6) );
Partial_Product_P9_6:  And_1bit port map
	 	 	 	 	( m(3), n(6), P9(6) );
Partial_Product_P10_6:  And_1bit port map
	 	 	 	 	( m(4), n(6), P10(6) );
Partial_Product_P11_6:  And_1bit port map
	 	 	 	 	( m(5), n(6), P11(6) );
Partial_Product_P12_6:  And_1bit port map
	 	 	 	 	( m(6), n(6), P12(6) );
Partial_Product_P13_6:  And_1bit port map
	 	 	 	 	( m(7), n(6), P13(6) );
Partial_Product_P14_6:  And_1bit port map
	 	 	 	 	( m(8), n(6), P14(6) );
Partial_Product_P15_6:  And_1bit port map
	 	 	 	 	( m(9), n(6), P15(6) );
Partial_Product_P16_6:  And_1bit port map
	 	 	 	 	( m(10), n(6), P16(5) );
Partial_Product_P17_6:  And_1bit port map
	 	 	 	 	( m(11), n(6), P17(4) );
Partial_Product_P18_6:  And_1bit port map
	 	 	 	 	( m(12), n(6), P18(3) );
Partial_Product_P19_6:  And_1bit port map
	 	 	 	 	( m(13), n(6), P19(2) );
Partial_Product_P20_6:  And_1bit port map
	 	 	 	 	( m(14), n(6), P20(1) );
Partial_Product_P21_6:  And_1bit port map
	 	 	 	 	( m(15), n(6), P21(0) );

Partial_Product_P7_7:  And_1bit port map
	 	 	 	 	( m(0), n(7), P7(7) );
Partial_Product_P8_7:  And_1bit port map
	 	 	 	 	( m(1), n(7), P8(7) );
Partial_Product_P9_7:  And_1bit port map
	 	 	 	 	( m(2), n(7), P9(7) );
Partial_Product_P10_7:  And_1bit port map
	 	 	 	 	( m(3), n(7), P10(7) );
Partial_Product_P11_7:  And_1bit port map
	 	 	 	 	( m(4), n(7), P11(7) );
Partial_Product_P12_7:  And_1bit port map
	 	 	 	 	( m(5), n(7), P12(7) );
Partial_Product_P13_7:  And_1bit port map
	 	 	 	 	( m(6), n(7), P13(7) );
Partial_Product_P14_7:  And_1bit port map
	 	 	 	 	( m(7), n(7), P14(7) );
Partial_Product_P15_7:  And_1bit port map
	 	 	 	 	( m(8), n(7), P15(7) );
Partial_Product_P16_7:  And_1bit port map
	 	 	 	 	( m(9), n(7), P16(6) );
Partial_Product_P17_7:  And_1bit port map
	 	 	 	 	( m(10), n(7), P17(5) );
Partial_Product_P18_7:  And_1bit port map
	 	 	 	 	( m(11), n(7), P18(4) );
Partial_Product_P19_7:  And_1bit port map
	 	 	 	 	( m(12), n(7), P19(3) );
Partial_Product_P20_7:  And_1bit port map
	 	 	 	 	( m(13), n(7), P20(2) );
Partial_Product_P21_7:  And_1bit port map
	 	 	 	 	( m(14), n(7), P21(1) );
Partial_Product_P22_7:  And_1bit port map
	 	 	 	 	( m(15), n(7), P22(0) );

Partial_Product_P8_8:  And_1bit port map
	 	 	 	 	( m(0), n(8), P8(8) );
Partial_Product_P9_8:  And_1bit port map
	 	 	 	 	( m(1), n(8), P9(8) );
Partial_Product_P10_8:  And_1bit port map
	 	 	 	 	( m(2), n(8), P10(8) );
Partial_Product_P11_8:  And_1bit port map
	 	 	 	 	( m(3), n(8), P11(8) );
Partial_Product_P12_8:  And_1bit port map
	 	 	 	 	( m(4), n(8), P12(8) );
Partial_Product_P13_8:  And_1bit port map
	 	 	 	 	( m(5), n(8), P13(8) );
Partial_Product_P14_8:  And_1bit port map
	 	 	 	 	( m(6), n(8), P14(8) );
Partial_Product_P15_8:  And_1bit port map
	 	 	 	 	( m(7), n(8), P15(8) );
Partial_Product_P16_8:  And_1bit port map
	 	 	 	 	( m(8), n(8), P16(7) );
Partial_Product_P17_8:  And_1bit port map
	 	 	 	 	( m(9), n(8), P17(6) );
Partial_Product_P18_8:  And_1bit port map
	 	 	 	 	( m(10), n(8), P18(5) );
Partial_Product_P19_8:  And_1bit port map
	 	 	 	 	( m(11), n(8), P19(4) );
Partial_Product_P20_8:  And_1bit port map
	 	 	 	 	( m(12), n(8), P20(3) );
Partial_Product_P21_8:  And_1bit port map
	 	 	 	 	( m(13), n(8), P21(2) );
Partial_Product_P22_8:  And_1bit port map
	 	 	 	 	( m(14), n(8), P22(1) );
Partial_Product_P23_8:  And_1bit port map
	 	 	 	 	( m(15), n(8), P23(0) );

Partial_Product_P9_9:  And_1bit port map
	 	 	 	 	( m(0), n(9), P9(9) );
Partial_Product_P10_9:  And_1bit port map
	 	 	 	 	( m(1), n(9), P10(9) );
Partial_Product_P11_9:  And_1bit port map
	 	 	 	 	( m(2), n(9), P11(9) );
Partial_Product_P12_9:  And_1bit port map
	 	 	 	 	( m(3), n(9), P12(9) );
Partial_Product_P13_9:  And_1bit port map
	 	 	 	 	( m(4), n(9), P13(9) );
Partial_Product_P14_9:  And_1bit port map
	 	 	 	 	( m(5), n(9), P14(9) );
Partial_Product_P15_9:  And_1bit port map
	 	 	 	 	( m(6), n(9), P15(9) );
Partial_Product_P16_9:  And_1bit port map
	 	 	 	 	( m(7), n(9), P16(8) );
Partial_Product_P17_9:  And_1bit port map
	 	 	 	 	( m(8), n(9), P17(7) );
Partial_Product_P18_9:  And_1bit port map
	 	 	 	 	( m(9), n(9), P18(6) );
Partial_Product_P19_9:  And_1bit port map
	 	 	 	 	( m(10), n(9), P19(5) );
Partial_Product_P20_9:  And_1bit port map
	 	 	 	 	( m(11), n(9), P20(4) );
Partial_Product_P21_9:  And_1bit port map
	 	 	 	 	( m(12), n(9), P21(3) );
Partial_Product_P22_9:  And_1bit port map
	 	 	 	 	( m(13), n(9), P22(2) );
Partial_Product_P23_9:  And_1bit port map
	 	 	 	 	( m(14), n(9), P23(1) );
Partial_Product_P24_9:  And_1bit port map
	 	 	 	 	( m(15), n(9), P24(0) );

Partial_Product_P10_10:  And_1bit port map
	 	 	 	 	( m(0), n(10), P10(10) );
Partial_Product_P11_10:  And_1bit port map
	 	 	 	 	( m(1), n(10), P11(10) );
Partial_Product_P12_10:  And_1bit port map
	 	 	 	 	( m(2), n(10), P12(10) );
Partial_Product_P13_10:  And_1bit port map
	 	 	 	 	( m(3), n(10), P13(10) );
Partial_Product_P14_10:  And_1bit port map
	 	 	 	 	( m(4), n(10), P14(10) );
Partial_Product_P15_10:  And_1bit port map
	 	 	 	 	( m(5), n(10), P15(10) );
Partial_Product_P16_10:  And_1bit port map
	 	 	 	 	( m(6), n(10), P16(9) );
Partial_Product_P17_10:  And_1bit port map
	 	 	 	 	( m(7), n(10), P17(8) );
Partial_Product_P18_10:  And_1bit port map
	 	 	 	 	( m(8), n(10), P18(7) );
Partial_Product_P19_10:  And_1bit port map
	 	 	 	 	( m(9), n(10), P19(6) );
Partial_Product_P20_10:  And_1bit port map
	 	 	 	 	( m(10), n(10), P20(5) );
Partial_Product_P21_10:  And_1bit port map
	 	 	 	 	( m(11), n(10), P21(4) );
Partial_Product_P22_10:  And_1bit port map
	 	 	 	 	( m(12), n(10), P22(3) );
Partial_Product_P23_10:  And_1bit port map
	 	 	 	 	( m(13), n(10), P23(2) );
Partial_Product_P24_10:  And_1bit port map
	 	 	 	 	( m(14), n(10), P24(1) );
Partial_Product_P25_10:  And_1bit port map
	 	 	 	 	( m(15), n(10), P25(0) );

Partial_Product_P11_11:  And_1bit port map
	 	 	 	 	( m(0), n(11), P11(11) );
Partial_Product_P12_11:  And_1bit port map
	 	 	 	 	( m(1), n(11), P12(11) );
Partial_Product_P13_11:  And_1bit port map
	 	 	 	 	( m(2), n(11), P13(11) );
Partial_Product_P14_11:  And_1bit port map
	 	 	 	 	( m(3), n(11), P14(11) );
Partial_Product_P15_11:  And_1bit port map
	 	 	 	 	( m(4), n(11), P15(11) );
Partial_Product_P16_11:  And_1bit port map
	 	 	 	 	( m(5), n(11), P16(10) );
Partial_Product_P17_11:  And_1bit port map
	 	 	 	 	( m(6), n(11), P17(9) );
Partial_Product_P18_11:  And_1bit port map
	 	 	 	 	( m(7), n(11), P18(8) );
Partial_Product_P19_11:  And_1bit port map
	 	 	 	 	( m(8), n(11), P19(7) );
Partial_Product_P20_11:  And_1bit port map
	 	 	 	 	( m(9), n(11), P20(6) );
Partial_Product_P21_11:  And_1bit port map
	 	 	 	 	( m(10), n(11), P21(5) );
Partial_Product_P22_11:  And_1bit port map
	 	 	 	 	( m(11), n(11), P22(4) );
Partial_Product_P23_11:  And_1bit port map
	 	 	 	 	( m(12), n(11), P23(3) );
Partial_Product_P24_11:  And_1bit port map
	 	 	 	 	( m(13), n(11), P24(2) );
Partial_Product_P25_11:  And_1bit port map
	 	 	 	 	( m(14), n(11), P25(1) );
Partial_Product_P26_11:  And_1bit port map
	 	 	 	 	( m(15), n(11), P26(0) );

Partial_Product_P12_12:  And_1bit port map
	 	 	 	 	( m(0), n(12), P12(12) );
Partial_Product_P13_12:  And_1bit port map
	 	 	 	 	( m(1), n(12), P13(12) );
Partial_Product_P14_12:  And_1bit port map
	 	 	 	 	( m(2), n(12), P14(12) );
Partial_Product_P15_12:  And_1bit port map
	 	 	 	 	( m(3), n(12), P15(12) );
Partial_Product_P16_12:  And_1bit port map
	 	 	 	 	( m(4), n(12), P16(11) );
Partial_Product_P17_12:  And_1bit port map
	 	 	 	 	( m(5), n(12), P17(10) );
Partial_Product_P18_12:  And_1bit port map
	 	 	 	 	( m(6), n(12), P18(9) );
Partial_Product_P19_12:  And_1bit port map
	 	 	 	 	( m(7), n(12), P19(8) );
Partial_Product_P20_12:  And_1bit port map
	 	 	 	 	( m(8), n(12), P20(7) );
Partial_Product_P21_12:  And_1bit port map
	 	 	 	 	( m(9), n(12), P21(6) );
Partial_Product_P22_12:  And_1bit port map
	 	 	 	 	( m(10), n(12), P22(5) );
Partial_Product_P23_12:  And_1bit port map
	 	 	 	 	( m(11), n(12), P23(4) );
Partial_Product_P24_12:  And_1bit port map
	 	 	 	 	( m(12), n(12), P24(3) );
Partial_Product_P25_12:  And_1bit port map
	 	 	 	 	( m(13), n(12), P25(2) );
Partial_Product_P26_12:  And_1bit port map
	 	 	 	 	( m(14), n(12), P26(1) );
Partial_Product_P27_12:  And_1bit port map
	 	 	 	 	( m(15), n(12), P27(0) );

Partial_Product_P13_13:  And_1bit port map
	 	 	 	 	( m(0), n(13), P13(13) );
Partial_Product_P14_13:  And_1bit port map
	 	 	 	 	( m(1), n(13), P14(13) );
Partial_Product_P15_13:  And_1bit port map
	 	 	 	 	( m(2), n(13), P15(13) );
Partial_Product_P16_13:  And_1bit port map
	 	 	 	 	( m(3), n(13), P16(12) );
Partial_Product_P17_13:  And_1bit port map
	 	 	 	 	( m(4), n(13), P17(11) );
Partial_Product_P18_13:  And_1bit port map
	 	 	 	 	( m(5), n(13), P18(10) );
Partial_Product_P19_13:  And_1bit port map
	 	 	 	 	( m(6), n(13), P19(9) );
Partial_Product_P20_13:  And_1bit port map
	 	 	 	 	( m(7), n(13), P20(8) );
Partial_Product_P21_13:  And_1bit port map
	 	 	 	 	( m(8), n(13), P21(7) );
Partial_Product_P22_13:  And_1bit port map
	 	 	 	 	( m(9), n(13), P22(6) );
Partial_Product_P23_13:  And_1bit port map
	 	 	 	 	( m(10), n(13), P23(5) );
Partial_Product_P24_13:  And_1bit port map
	 	 	 	 	( m(11), n(13), P24(4) );
Partial_Product_P25_13:  And_1bit port map
	 	 	 	 	( m(12), n(13), P25(3) );
Partial_Product_P26_13:  And_1bit port map
	 	 	 	 	( m(13), n(13), P26(2) );
Partial_Product_P27_13:  And_1bit port map
	 	 	 	 	( m(14), n(13), P27(1) );
Partial_Product_P28_13:  And_1bit port map
	 	 	 	 	( m(15), n(13), P28(0) );

Partial_Product_P14_14:  And_1bit port map
	 	 	 	 	( m(0), n(14), P14(14) );
Partial_Product_P15_14:  And_1bit port map
	 	 	 	 	( m(1), n(14), P15(14) );
Partial_Product_P16_14:  And_1bit port map
	 	 	 	 	( m(2), n(14), P16(13) );
Partial_Product_P17_14:  And_1bit port map
	 	 	 	 	( m(3), n(14), P17(12) );
Partial_Product_P18_14:  And_1bit port map
	 	 	 	 	( m(4), n(14), P18(11) );
Partial_Product_P19_14:  And_1bit port map
	 	 	 	 	( m(5), n(14), P19(10) );
Partial_Product_P20_14:  And_1bit port map
	 	 	 	 	( m(6), n(14), P20(9) );
Partial_Product_P21_14:  And_1bit port map
	 	 	 	 	( m(7), n(14), P21(8) );
Partial_Product_P22_14:  And_1bit port map
	 	 	 	 	( m(8), n(14), P22(7) );
Partial_Product_P23_14:  And_1bit port map
	 	 	 	 	( m(9), n(14), P23(6) );
Partial_Product_P24_14:  And_1bit port map
	 	 	 	 	( m(10), n(14), P24(5) );
Partial_Product_P25_14:  And_1bit port map
	 	 	 	 	( m(11), n(14), P25(4) );
Partial_Product_P26_14:  And_1bit port map
	 	 	 	 	( m(12), n(14), P26(3) );
Partial_Product_P27_14:  And_1bit port map
	 	 	 	 	( m(13), n(14), P27(2) );
Partial_Product_P28_14:  And_1bit port map
	 	 	 	 	( m(14), n(14), P28(1) );
Partial_Product_P29_14:  And_1bit port map
	 	 	 	 	( m(15), n(14), P29(0) );

Partial_Product_P15_15:  And_1bit port map
	 	 	 	 	( m(0), n(15), P15(15) );
Partial_Product_P16_15:  And_1bit port map
	 	 	 	 	( m(1), n(15), P16(14) );
Partial_Product_P17_15:  And_1bit port map
	 	 	 	 	( m(2), n(15), P17(13) );
Partial_Product_P18_15:  And_1bit port map
	 	 	 	 	( m(3), n(15), P18(12) );
Partial_Product_P19_15:  And_1bit port map
	 	 	 	 	( m(4), n(15), P19(11) );
Partial_Product_P20_15:  And_1bit port map
	 	 	 	 	( m(5), n(15), P20(10) );
Partial_Product_P21_15:  And_1bit port map
	 	 	 	 	( m(6), n(15), P21(9) );
Partial_Product_P22_15:  And_1bit port map
	 	 	 	 	( m(7), n(15), P22(8) );
Partial_Product_P23_15:  And_1bit port map
	 	 	 	 	( m(8), n(15), P23(7) );
Partial_Product_P24_15:  And_1bit port map
	 	 	 	 	( m(9), n(15), P24(6) );
Partial_Product_P25_15:  And_1bit port map
	 	 	 	 	( m(10), n(15), P25(5) );
Partial_Product_P26_15:  And_1bit port map
	 	 	 	 	( m(11), n(15), P26(4) );
Partial_Product_P27_15:  And_1bit port map
	 	 	 	 	( m(12), n(15), P27(3) );
Partial_Product_P28_15:  And_1bit port map
	 	 	 	 	( m(13), n(15), P28(2) );
Partial_Product_P29_15:  And_1bit port map
	 	 	 	 	( m(14), n(15), P29(1) );
Partial_Product_P30_15:  And_1bit port map
	 	 	 	 	( m(15), n(15), P30 );
					
------------------------------------Reducing from 16 bit wires to 11--------------------
Reduction_11_P11_h:  Half_Adder port map
	 	 	 	 	( P11(0), P11(1), PP11(0),PP12(0) );
					
Reduction_11_P12_h:  Half_Adder port map
	 	 	 	 	( P12(0), P12(1), PP12(1),PP13(0) );

Reduction_11_P13_h:  Half_Adder port map
	 	 	 	 	( P13(0), P13(1), PP13(1),PP14(0) );

Reduction_11_P14_h:  Half_Adder port map
	 	 	 	 	( P14(0), P14(1), PP14(1),PP15(0) );

Reduction_11_P15_h:  Half_Adder port map
	 	 	 	 	( P15(0), P15(1), PP15(1),PP16(0) );

Reduction_11_P16_h:  Half_Adder port map
	 	 	 	 	( P16(0), P16(1), PP16(1),PP17(0) );


Reduction_11_P12_f:  Full_Adder port map
	 	 	 	 	( P12(2), P12(3),P12(4), PP12(2),PP13(2) );

Reduction_11_P13_f_1:  Full_Adder port map
	 	 	 	 	( P13(2), P13(3),P13(4), PP13(3),PP14(2) );
					
Reduction_11_P13_f_2:  Full_Adder port map
	 	 	 	 	( P13(5), P13(6),P13(7), PP13(4),PP14(3) );

Reduction_11_P14_f_1:  Full_Adder port map
	 	 	 	 	( P14(2), P14(3),P14(4), PP14(4),PP15(2) );

Reduction_11_P14_f_2:  Full_Adder port map
	 	 	 	 	( P14(5), P14(6),P14(7), PP14(5),PP15(3) );

Reduction_11_P14_f_3:  Full_Adder port map
	 	 	 	 	( P14(8), P14(9),P14(10), PP14(6),PP15(4) );
					
Reduction_11_P15_f_1:  Full_Adder port map
	 	 	 	 	( P15(2), P15(3),P15(4), PP15(5),PP16(2) );

Reduction_11_P15_f_2:  Full_Adder port map
	 	 	 	 	( P15(5), P15(6),P15(7), PP15(6),PP16(3) );

Reduction_11_P15_f_3:  Full_Adder port map
	 	 	 	 	( P15(8), P15(9),P15(10), PP15(7),PP16(4) );

Reduction_11_P15_f_4:  Full_Adder port map
	 	 	 	 	( P15(11), P15(12),P15(13), PP15(8),PP16(5) );
					
Reduction_11_P16_f_1:  Full_Adder port map
	 	 	 	 	( P16(2), P16(3),P16(4), PP16(6),PP17(1) );

Reduction_11_P16_f_2:  Full_Adder port map
	 	 	 	 	( P16(5), P16(6),P16(7), PP16(7),PP17(2) );

Reduction_11_P16_f_3:  Full_Adder port map
	 	 	 	 	( P16(8), P16(9),P16(10), PP16(8),PP17(3) );

Reduction_11_P16_f_4:  Full_Adder port map
	 	 	 	 	( P16(11), P16(12),P16(13), PP16(9),PP17(4) );					
					
Reduction_11_P17_f_1:  Full_Adder port map
	 	 	 	 	( P17(0), P17(1),P17(2), PP17(5),PP18(0) );

Reduction_11_P17_f_2:  Full_Adder port map
	 	 	 	 	( P17(3), P17(4),P17(5), PP17(6),PP18(1) );

Reduction_11_P17_f_3:  Full_Adder port map
	 	 	 	 	( P17(6), P17(7),P17(8), PP17(7),PP18(2) );

Reduction_11_P17_f_4:  Full_Adder port map
	 	 	 	 	( P17(9), P17(10),P17(11), PP17(8),PP18(3) );
					
Reduction_11_P18_f_1:  Full_Adder port map
	 	 	 	 	( P18(0), P18(1),P18(2), PP18(4),PP19(0) );

Reduction_11_P18_f_2:  Full_Adder port map
	 	 	 	 	( P18(3), P18(4),P18(5), PP18(5),PP19(1) );

Reduction_11_P18_f_3:  Full_Adder port map
	 	 	 	 	( P18(6), P18(7),P18(8), PP18(6),PP19(2) );
				
Reduction_11_P19_f_1:  Full_Adder port map
	 	 	 	 	( P19(0), P19(1),P19(2), PP19(3),PP20(0) );

Reduction_11_P19_f_2:  Full_Adder port map
	 	 	 	 	( P19(3), P19(4),P19(5), PP19(4),PP20(1) );

Reduction_11_P20_f_1:  Full_Adder port map
	 	 	 	 	( P20(0), P20(1),P20(2), PP20(2),PP21(0) );

PP11 (10 downto 1) <= P11 (11 downto 2);
PP12 (10 downto 3) <= P12 (12 downto 5); 
PP13 (10 downto 5) <= P13 (13 downto 8); 
PP14 (10 downto 7) <= P14 (14 downto 11); 
PP15 (10 downto 9) <= P15 (15 downto 14); 
PP16 (10) <= P16 (14); 
PP17 (10 downto 9) <= P17 (13 downto 12);
PP18 (10 downto 7) <= P18 (12 downto 9);
PP19 (10 downto 5) <= P19 (11 downto 6);
PP20 (10 downto 3) <= P20 (10 downto 3);
PP21 (10 downto 1) <= P21 (9 downto 0);
					
--------------------------------------------------------------------------------------------------------------------

------------------------------------Reducing from 11 bit wires to 8--------------------



Reduction_8_P8_h:  Half_Adder port map
	 	 	 	 	( P8(0), P8(1), PPP8(0),PPP9(0) );
PPP8 (7 downto 1) <= P8 (8 downto 2);

Reduction_8_P9_h:  Half_Adder port map
	 	 	 	 	( P9(0), P9(1), PPP9(1),PPP10(0) );
Reduction_8_P9_f:  Full_Adder port map
	 	 	 	 	( P9(2), P9(3),P9(4), PPP9(2),PPP10(1) );
PPP9 (7 downto 3) <= P9 (9 downto 5);

Reduction_8_P10_h:  Half_Adder port map
	 	 	 	 	( P10(0), P10(1), PPP10(2),PPP11(0) );
Reduction_8_P10_f_1:  Full_Adder port map
	 	 	 	 	( P10(2), P10(3),P10(4), PPP10(3),PPP11(1) );
Reduction_8_P10_f_2:  Full_Adder port map
	 	 	 	 	( P10(5), P10(6),P10(7), PPP10(4),PPP11(2) );
PPP10 (7 downto 5) <= P10 (10 downto 8);					

Reduction_8_P11_f_1:  Full_Adder port map 
	 	 	( PP11(0), PP11(1),PP11(2), PPP11(3),PPP12(0) );
Reduction_8_P11_f_2:  Full_Adder port map
			( PP11(3), PP11(4),PP11(5), PPP11(4),PPP12(1) );
Reduction_8_P11_f_3:  Full_Adder port map
 			( PP11(6), PP11(7),PP11(8), PPP11(5),PPP12(2) );
PPP11 (7 downto 6) <= PP11 (10 downto 9);

Reduction_8_P12_f_1:  Full_Adder port map 
	 	 	( PP12(0), PP12(1),PP12(2), PPP12(3),PPP13(0) );
Reduction_8_P12_f_2:  Full_Adder port map
			( PP12(3), PP12(4),PP12(5), PPP12(4),PPP13(1) );
Reduction_8_P12_f_3:  Full_Adder port map
 			( PP12(6), PP12(7),PP12(8), PPP12(5),PPP13(2) );
PPP12 (7 downto 6) <= PP12 (10 downto 9);

Reduction_8_P13_f_1:  Full_Adder port map 
	 	 	( PP13(0), PP13(1),PP13(2), PPP13(3),PPP14(0) );
Reduction_8_P13_f_2:  Full_Adder port map
			( PP13(3), PP13(4),PP13(5), PPP13(4),PPP14(1) );
Reduction_8_P13_f_3:  Full_Adder port map
 			( PP13(6), PP13(7),PP13(8), PPP13(5),PPP14(2) );
PPP13 (7 downto 6) <= PP13 (10 downto 9);

Reduction_8_P14_f_1:  Full_Adder port map 
	 	 	( PP14(0), PP14(1),PP14(2), PPP14(3),PPP15(0) );
Reduction_8_P14_f_2:  Full_Adder port map
			( PP14(3), PP14(4),PP14(5), PPP14(4),PPP15(1) );
Reduction_8_P14_f_3:  Full_Adder port map
 			( PP14(6), PP14(7),PP14(8), PPP14(5),PPP15(2) );
PPP14 (7 downto 6) <= PP14 (10 downto 9);

Reduction_8_P15_f_1:  Full_Adder port map 
	 	 	( PP15(0), PP15(1),PP15(2), PPP15(3),PPP16(0) );
Reduction_8_P15_f_2:  Full_Adder port map
			( PP15(3), PP15(4),PP15(5), PPP15(4),PPP16(1) );
Reduction_8_P15_f_3:  Full_Adder port map
 			( PP15(6), PP15(7),PP15(8), PPP15(5),PPP16(2) );
PPP15 (7 downto 6) <= PP15 (10 downto 9);

Reduction_8_P16_f_1:  Full_Adder port map 
	 	 	( PP16(0), PP16(1),PP16(2), PPP16(3),PPP17(0) );
Reduction_8_P16_f_2:  Full_Adder port map
			( PP16(3), PP16(4),PP16(5), PPP16(4),PPP17(1) );
Reduction_8_P16_f_3:  Full_Adder port map
 			( PP16(6), PP16(7),PP16(8), PPP16(5),PPP17(2) );
PPP16 (7 downto 6) <= PP16 (10 downto 9);

Reduction_8_P17_f_1:  Full_Adder port map 
	 	 	( PP17(0), PP17(1),PP17(2), PPP17(3),PPP18(0) );
Reduction_8_P17_f_2:  Full_Adder port map
			( PP17(3), PP17(4),PP17(5), PPP17(4),PPP18(1) );
Reduction_8_P17_f_3:  Full_Adder port map
 			( PP17(6), PP17(7),PP17(8), PPP17(5),PPP18(2) );
PPP17 (7 downto 6) <= PP17 (10 downto 9);

Reduction_8_P18_f_1:  Full_Adder port map 
	 	 	( PP18(0), PP18(1),PP18(2), PPP18(3),PPP19(0) );
Reduction_8_P18_f_2:  Full_Adder port map
			( PP18(3), PP18(4),PP18(5), PPP18(4),PPP19(1) );
Reduction_8_P18_f_3:  Full_Adder port map
 			( PP18(6), PP18(7),PP18(8), PPP18(5),PPP19(2) );
PPP18 (7 downto 6) <= PP18 (10 downto 9);

Reduction_8_P19_f_1:  Full_Adder port map 
	 	 	( PP19(0), PP19(1),PP19(2), PPP19(3),PPP20(0) );
Reduction_8_P19_f_2:  Full_Adder port map
			( PP19(3), PP19(4),PP19(5), PPP19(4),PPP20(1) );
Reduction_8_P19_f_3:  Full_Adder port map
 			( PP19(6), PP19(7),PP19(8), PPP19(5),PPP20(2) );
PPP19 (7 downto 6) <= PP19 (10 downto 9);

Reduction_8_P20_f_1:  Full_Adder port map 
	 	 	( PP20(0), PP20(1),PP20(2), PPP20(3),PPP21(0) );
Reduction_8_P20_f_2:  Full_Adder port map
			( PP20(3), PP20(4),PP20(5), PPP20(4),PPP21(1) );
Reduction_8_P20_f_3:  Full_Adder port map
 			( PP20(6), PP20(7),PP20(8), PPP20(5),PPP21(2) );
PPP20 (7 downto 6) <= PP20 (10 downto 9);

Reduction_8_P21_f_1:  Full_Adder port map 
	 	 	( PP21(0), PP21(1),PP21(2), PPP21(3),PPP22(0) );
Reduction_8_P21_f_2:  Full_Adder port map
			( PP21(3), PP21(4),PP21(5), PPP21(4),PPP22(1) );
Reduction_8_P21_f_3:  Full_Adder port map
 			( PP21(6), PP21(7),PP21(8), PPP21(5),PPP22(2) );
PPP21 (7 downto 6) <= PP21 (10 downto 9);

Reduction_8_P22_f_1:  Full_Adder port map
	 	 	 	 	( P22(0), P22(1),P22(2), PPP22(3),PPP23(0) );
Reduction_8_P22_f_2:  Full_Adder port map
	 	 	 	 	( P22(3), P22(4),P22(5), PPP22(4),PPP23(1) );
PPP22 (7 downto 5) <= P22 (8 downto 6);

Reduction_8_P23_f:  Full_Adder port map 
	 	 	( P23(0), P23(1),P23(2), PPP23(2),PPP24(0) );	
PPP23 (7 downto 3) <= P23 (7 downto 3);
PPP24 (7 downto 1) <= P24 (6 downto 0);


-----------------------------------------------------------------------------------------------------------------------
------------------------------------Reducing from 8 bit wires to 6--------------------


Reduction_6_P6_h:  Half_Adder port map
	 	 	 	 	( P6(0), P6(1), PPPP6(0),PPPP7(0) );
PPPP6 (5 downto 1) <= P6 (6 downto 2);

Reduction_6_P7_h:  Half_Adder port map
	 	 	 	 	( P7(0), P7(1), PPPP7(1),PPPP8(0) );
Reduction_6_P7_f:  Full_Adder port map
	 	 	 	 	( P7(2), P7(3), P7(4), PPPP7(2),PPPP8(1) );
PPPP7 (5 downto 3) <= P7 (7 downto 5);

Reduction_6_P8_f_1:  Full_Adder port map 
	 	 	( PPP8(0), PPP8(1),PPP8(2), PPPP8(2),PPPP9(0) );
Reduction_6_P8_f_2:  Full_Adder port map
			( PPP8(3), PPP8(4),PPP8(5), PPPP8(3),PPPP9(1) );
PPPP8 (5 downto 4) <= PPP8 (7 downto 6);

Reduction_6_P9_f_1:  Full_Adder port map 
	 	 	( PPP9(0), PPP9(1),PPP9(2), PPPP9(2),PPPP10(0) );
Reduction_6_P9_f_2:  Full_Adder port map
			( PPP9(3), PPP9(4),PPP9(5), PPPP9(3),PPPP10(1) );
PPPP9 (5 downto 4) <= PPP9 (7 downto 6);

Reduction_6_P10_f_1:  Full_Adder port map 
	 	 	( PPP10(0), PPP10(1),PPP10(2), PPPP10(2),PPPP11(0) );
Reduction_6_P10_f_2:  Full_Adder port map
			( PPP10(3), PPP10(4),PPP10(5), PPPP10(3),PPPP11(1) );
PPPP10 (5 downto 4) <= PPP10 (7 downto 6);

Reduction_6_P11_f_1:  Full_Adder port map 
	 	 	( PPP11(0), PPP11(1),PPP11(2), PPPP11(2),PPPP12(0) );
Reduction_6_P11_f_2:  Full_Adder port map
			( PPP11(3), PPP11(4),PPP11(5), PPPP11(3),PPPP12(1) );
PPPP11 (5 downto 4) <= PPP11 (7 downto 6);

Reduction_6_P12_f_1:  Full_Adder port map 
	 	 	( PPP12(0), PPP12(1),PPP12(2), PPPP12(2),PPPP13(0) );
Reduction_6_P12_f_2:  Full_Adder port map
			( PPP12(3), PPP12(4),PPP12(5), PPPP12(3),PPPP13(1) );
PPPP12 (5 downto 4) <= PPP12 (7 downto 6);

Reduction_6_P13_f_1:  Full_Adder port map 
	 	 	( PPP13(0), PPP13(1),PPP13(2), PPPP13(2),PPPP14(0) );
Reduction_6_P13_f_2:  Full_Adder port map
			( PPP13(3), PPP13(4),PPP13(5), PPPP13(3),PPPP14(1) );
PPPP13 (5 downto 4) <= PPP13 (7 downto 6);

Reduction_6_P14_f_1:  Full_Adder port map 
	 	 	( PPP14(0), PPP14(1),PPP14(2), PPPP14(2),PPPP15(0) );
Reduction_6_P14_f_2:  Full_Adder port map
			( PPP14(3), PPP14(4),PPP14(5), PPPP14(3),PPPP15(1) );
PPPP14 (5 downto 4) <= PPP14 (7 downto 6);

Reduction_6_P15_f_1:  Full_Adder port map 
	 	 	( PPP15(0), PPP15(1),PPP15(2), PPPP15(2),PPPP16(0) );
Reduction_6_P15_f_2:  Full_Adder port map
			( PPP15(3), PPP15(4),PPP15(5), PPPP15(3),PPPP16(1) );
PPPP15 (5 downto 4) <= PPP15 (7 downto 6);

Reduction_6_P16_f_1:  Full_Adder port map 
	 	 	( PPP16(0), PPP16(1),PPP16(2), PPPP16(2),PPPP17(0) );
Reduction_6_P16_f_2:  Full_Adder port map
			( PPP16(3), PPP16(4),PPP16(5), PPPP16(3),PPPP17(1) );
PPPP16 (5 downto 4) <= PPP16 (7 downto 6);

Reduction_6_P17_f_1:  Full_Adder port map 
	 	 	( PPP17(0), PPP17(1),PPP17(2), PPPP17(2),PPPP18(0) );
Reduction_6_P17_f_2:  Full_Adder port map
			( PPP17(3), PPP17(4),PPP17(5), PPPP17(3),PPPP18(1) );
PPPP17 (5 downto 4) <= PPP17 (7 downto 6);

Reduction_6_P18_f_1:  Full_Adder port map 
	 	 	( PPP18(0), PPP18(1),PPP18(2), PPPP18(2),PPPP19(0) );
Reduction_6_P18_f_2:  Full_Adder port map
			( PPP18(3), PPP18(4),PPP18(5), PPPP18(3),PPPP19(1) );
PPPP18 (5 downto 4) <= PPP18 (7 downto 6);

Reduction_6_P19_f_1:  Full_Adder port map 
	 	 	( PPP19(0), PPP19(1),PPP19(2), PPPP19(2),PPPP20(0) );
Reduction_6_P19_f_2:  Full_Adder port map
			( PPP19(3), PPP19(4),PPP19(5), PPPP19(3),PPPP20(1) );
PPPP19 (5 downto 4) <= PPP19 (7 downto 6);

Reduction_6_P20_f_1:  Full_Adder port map 
	 	 	( PPP20(0), PPP20(1),PPP20(2), PPPP20(2),PPPP21(0) );
Reduction_6_P20_f_2:  Full_Adder port map
			( PPP20(3), PPP20(4),PPP20(5), PPPP20(3),PPPP21(1) );
PPPP20 (5 downto 4) <= PPP20 (7 downto 6);

Reduction_6_P21_f_1:  Full_Adder port map 
	 	 	( PPP21(0), PPP21(1),PPP21(2), PPPP21(2),PPPP22(0) );
Reduction_6_P21_f_2:  Full_Adder port map
			( PPP21(3), PPP21(4),PPP21(5), PPPP21(3),PPPP22(1) );
PPPP21 (5 downto 4) <= PPP21 (7 downto 6);

Reduction_6_P22_f_1:  Full_Adder port map 
	 	 	( PPP22(0), PPP22(1),PPP22(2), PPPP22(2),PPPP23(0) );
Reduction_6_P22_f_2:  Full_Adder port map
			( PPP22(3), PPP22(4),PPP22(5), PPPP22(3),PPPP23(1) );
PPPP22 (5 downto 4) <= PPP22 (7 downto 6);

Reduction_6_P23_f_1:  Full_Adder port map 
	 	 	( PPP23(0), PPP23(1),PPP23(2), PPPP23(2),PPPP24(0) );
Reduction_6_P23_f_2:  Full_Adder port map
			( PPP23(3), PPP23(4),PPP23(5), PPPP23(3),PPPP24(1) );
PPPP23 (5 downto 4) <= PPP23 (7 downto 6);

Reduction_6_P24_f_1:  Full_Adder port map 
	 	 	( PPP24(0), PPP24(1),PPP24(2), PPPP24(2),PPPP25(0) );
Reduction_6_P24_f_2:  Full_Adder port map
			( PPP24(3), PPP24(4),PPP24(5), PPPP24(3),PPPP25(1) );
PPPP24 (5 downto 4) <= PPP24 (7 downto 6);

Reduction_6_P25_f:  Full_Adder port map 
	 	 	( P25(0), P25(1),P25(2), PPPP25(2),PPPP26(0) );
PPPP25 (5 downto 3) <= P25 (5 downto 3);

PPPP26 (5 downto 1) <= P26 (4 downto 0);

-------------------------------------------------------------------------------------------------------------
------------------------------------Reducing from 6 bit wires to 4--------------------

Reduction_4_Pfive4_h:  Half_Adder port map
	 	 	 	 	( P4(0), P4(1), Pfive4(0),Pfive5(0) );
Pfive4 (3 downto 1) <= P4 (4 downto 2);

Reduction_4_Pfive5_h:  Half_Adder port map
	 	 	 	 	( P5(0), P5(1), Pfive5(1), Pfive6(0) );
Reduction_4_Pfive5_f:  Full_Adder port map
	 	 	 	 	( P5(2), P5(3), P5(4), Pfive5(2), Pfive6(1) );
Pfive5 (3) <= P5 (5);

Reduction_4_Pfive6_f_1:  Full_Adder port map 
	 	 	( PPPP6(0), PPPP6(1),PPPP6(2), Pfive6(2),Pfive7(0) );
Reduction_4_Pfive6_f_2:  Full_Adder port map
			( PPPP6(3), PPPP6(4),PPPP6(5), Pfive6(3),Pfive7(1) );

Reduction_4_Pfive7_f_1:  Full_Adder port map 
	 	 	( PPPP7(0), PPPP7(1),PPPP7(2), Pfive7(2),Pfive8(0) );
Reduction_4_Pfive7_f_2:  Full_Adder port map
			( PPPP7(3), PPPP7(4),PPPP7(5), Pfive7(3),Pfive8(1) );

Reduction_4_Pfive8_f_1:  Full_Adder port map 
	 	 	( PPPP8(0), PPPP8(1),PPPP8(2), Pfive8(2),Pfive9(0) );
Reduction_4_Pfive8_f_2:  Full_Adder port map
			( PPPP8(3), PPPP8(4),PPPP8(5), Pfive8(3),Pfive9(1) );

Reduction_4_Pfive9_f_1:  Full_Adder port map 
	 	 	( PPPP9(0), PPPP9(1),PPPP9(2), Pfive9(2),Pfive10(0) );
Reduction_4_Pfive9_f_2:  Full_Adder port map
			( PPPP9(3), PPPP9(4),PPPP9(5), Pfive9(3),Pfive10(1) );

Reduction_4_Pfive10_f_1:  Full_Adder port map 
	 	 	( PPPP10(0), PPPP10(1),PPPP10(2), Pfive10(2),Pfive11(0) );
Reduction_4_Pfive10_f_2:  Full_Adder port map
			( PPPP10(3), PPPP10(4),PPPP10(5), Pfive10(3),Pfive11(1) );

Reduction_4_Pfive11_f_1:  Full_Adder port map 
	 	 	( PPPP11(0), PPPP11(1),PPPP11(2), Pfive11(2),Pfive12(0) );
Reduction_4_Pfive11_f_2:  Full_Adder port map
			( PPPP11(3), PPPP11(4),PPPP11(5), Pfive11(3),Pfive12(1) );

Reduction_4_Pfive12_f_1:  Full_Adder port map 
	 	 	( PPPP12(0), PPPP12(1),PPPP12(2), Pfive12(2),Pfive13(0) );
Reduction_4_Pfive12_f_2:  Full_Adder port map
			( PPPP12(3), PPPP12(4),PPPP12(5), Pfive12(3),Pfive13(1) );

Reduction_4_Pfive13_f_1:  Full_Adder port map 
	 	 	( PPPP13(0), PPPP13(1),PPPP13(2), Pfive13(2),Pfive14(0) );
Reduction_4_Pfive13_f_2:  Full_Adder port map
			( PPPP13(3), PPPP13(4),PPPP13(5), Pfive13(3),Pfive14(1) );

Reduction_4_Pfive14_f_1:  Full_Adder port map 
	 	 	( PPPP14(0), PPPP14(1),PPPP14(2), Pfive14(2),Pfive15(0) );
Reduction_4_Pfive14_f_2:  Full_Adder port map
			( PPPP14(3), PPPP14(4),PPPP14(5), Pfive14(3),Pfive15(1) );

Reduction_4_Pfive15_f_1:  Full_Adder port map 
	 	 	( PPPP15(0), PPPP15(1),PPPP15(2), Pfive15(2),Pfive16(0) );
Reduction_4_Pfive15_f_2:  Full_Adder port map
			( PPPP15(3), PPPP15(4),PPPP15(5), Pfive15(3),Pfive16(1) );

Reduction_4_Pfive16_f_1:  Full_Adder port map 
	 	 	( PPPP16(0), PPPP16(1),PPPP16(2), Pfive16(2),Pfive17(0) );
Reduction_4_Pfive16_f_2:  Full_Adder port map
			( PPPP16(3), PPPP16(4),PPPP16(5), Pfive16(3),Pfive17(1) );

Reduction_4_Pfive17_f_1:  Full_Adder port map 
	 	 	( PPPP17(0), PPPP17(1),PPPP17(2), Pfive17(2),Pfive18(0) );
Reduction_4_Pfive17_f_2:  Full_Adder port map
			( PPPP17(3), PPPP17(4),PPPP17(5), Pfive17(3),Pfive18(1) );

Reduction_4_Pfive18_f_1:  Full_Adder port map 
	 	 	( PPPP18(0), PPPP18(1),PPPP18(2), Pfive18(2),Pfive19(0) );
Reduction_4_Pfive18_f_2:  Full_Adder port map
			( PPPP18(3), PPPP18(4),PPPP18(5), Pfive18(3),Pfive19(1) );

Reduction_4_Pfive19_f_1:  Full_Adder port map 
	 	 	( PPPP19(0), PPPP19(1),PPPP19(2), Pfive19(2),Pfive20(0) );
Reduction_4_Pfive19_f_2:  Full_Adder port map
			( PPPP19(3), PPPP19(4),PPPP19(5), Pfive19(3),Pfive20(1) );

Reduction_4_Pfive20_f_1:  Full_Adder port map 
	 	 	( PPPP20(0), PPPP20(1),PPPP20(2), Pfive20(2),Pfive21(0) );
Reduction_4_Pfive20_f_2:  Full_Adder port map
			( PPPP20(3), PPPP20(4),PPPP20(5), Pfive20(3),Pfive21(1) );

Reduction_4_Pfive21_f_1:  Full_Adder port map 
	 	 	( PPPP21(0), PPPP21(1),PPPP21(2), Pfive21(2),Pfive22(0) );
Reduction_4_Pfive21_f_2:  Full_Adder port map
			( PPPP21(3), PPPP21(4),PPPP21(5), Pfive21(3),Pfive22(1) );

Reduction_4_Pfive22_f_1:  Full_Adder port map 
	 	 	( PPPP22(0), PPPP22(1),PPPP22(2), Pfive22(2),Pfive23(0) );
Reduction_4_Pfive22_f_2:  Full_Adder port map
			( PPPP22(3), PPPP22(4),PPPP22(5), Pfive22(3),Pfive23(1) );

Reduction_4_Pfive23_f_1:  Full_Adder port map 
	 	 	( PPPP23(0), PPPP23(1),PPPP23(2), Pfive23(2),Pfive24(0) );
Reduction_4_Pfive23_f_2:  Full_Adder port map
			( PPPP23(3), PPPP23(4),PPPP23(5), Pfive23(3),Pfive24(1) );

Reduction_4_Pfive24_f_1:  Full_Adder port map 
	 	 	( PPPP24(0), PPPP24(1),PPPP24(2), Pfive24(2),Pfive25(0) );
Reduction_4_Pfive24_f_2:  Full_Adder port map
			( PPPP24(3), PPPP24(4),PPPP24(5), Pfive24(3),Pfive25(1) );

Reduction_4_Pfive25_f_1:  Full_Adder port map 
	 	 	( PPPP25(0), PPPP25(1),PPPP25(2), Pfive25(2),Pfive26(0) );
Reduction_4_Pfive25_f_2:  Full_Adder port map
			( PPPP25(3), PPPP25(4),PPPP25(5), Pfive25(3),Pfive26(1) );

Reduction_4_Pfive26_f_1:  Full_Adder port map 
	 	 	( PPPP26(0), PPPP26(1),PPPP26(2), Pfive26(2),Pfive27(0) );
Reduction_4_Pfive26_f_2:  Full_Adder port map
			( PPPP26(3), PPPP26(4),PPPP26(5), Pfive26(3),Pfive27(1) );

Reduction_4_Pfive27_f:  Full_Adder port map 
	 	 	( P27(0), P27(1),P27(2), Pfive27(2),Pfive28(0) );
Pfive27 (3) <= P27 (3);
Pfive28 (3 downto 1) <= P28(2 downto 0);

-------------------------------------------------------------------------------------------------------------
------------------------------------Reducing from 4 bit wires to 3--------------------

Reduction_3_Psix3_h:  Half_Adder port map
	 	 	 	 	( P3(0), P3(1), Psix3(0),Psix4(0) );
Psix3 (2 downto 1) <= P3 (3 downto 2);


Reduction_3_Psix4_f_1:  Full_Adder port map 
	 	 	( Pfive4(0), Pfive4(1),Pfive4(2), Psix4(1),Psix5(0) );
Psix4(2)<= Pfive4(3);

Reduction_3_Psix5_f_1:  Full_Adder port map 
	 	 	( Pfive5(0), Pfive5(1),Pfive5(2), Psix5(1),Psix6(0) );
Psix5(2)<= Pfive5(3);

Reduction_3_Psix6_f_1:  Full_Adder port map 
	 	 	( Pfive6(0), Pfive6(1),Pfive6(2), Psix6(1),Psix7(0) );
Psix6(2)<= Pfive6(3);

Reduction_3_Psix7_f_1:  Full_Adder port map 
	 	 	( Pfive7(0), Pfive7(1),Pfive7(2), Psix7(1),Psix8(0) );
Psix7(2)<= Pfive7(3);

Reduction_3_Psix8_f_1:  Full_Adder port map 
	 	 	( Pfive8(0), Pfive8(1),Pfive8(2), Psix8(1),Psix9(0) );
Psix8(2)<= Pfive8(3);

Reduction_3_Psix9_f_1:  Full_Adder port map 
	 	 	( Pfive9(0), Pfive9(1),Pfive9(2), Psix9(1),Psix10(0) );
Psix9(2)<= Pfive9(3);

Reduction_3_Psix10_f_1:  Full_Adder port map 
	 	 	( Pfive10(0), Pfive10(1),Pfive10(2), Psix10(1),Psix11(0) );
Psix10(2)<= Pfive10(3);

Reduction_3_Psix11_f_1:  Full_Adder port map 
	 	 	( Pfive11(0), Pfive11(1),Pfive11(2), Psix11(1),Psix12(0) );
Psix11(2)<= Pfive11(3);

Reduction_3_Psix12_f_1:  Full_Adder port map 
	 	 	( Pfive12(0), Pfive12(1),Pfive12(2), Psix12(1),Psix13(0) );
Psix12(2)<= Pfive12(3);

Reduction_3_Psix13_f_1:  Full_Adder port map 
	 	 	( Pfive13(0), Pfive13(1),Pfive13(2), Psix13(1),Psix14(0) );
Psix13(2)<= Pfive13(3);

Reduction_3_Psix14_f_1:  Full_Adder port map 
	 	 	( Pfive14(0), Pfive14(1),Pfive14(2), Psix14(1),Psix15(0) );
Psix14(2)<= Pfive14(3);

Reduction_3_Psix15_f_1:  Full_Adder port map 
	 	 	( Pfive15(0), Pfive15(1),Pfive15(2), Psix15(1),Psix16(0) );
Psix15(2)<= Pfive15(3);

Reduction_3_Psix16_f_1:  Full_Adder port map 
	 	 	( Pfive16(0), Pfive16(1),Pfive16(2), Psix16(1),Psix17(0) );
Psix16(2)<= Pfive16(3);

Reduction_3_Psix17_f_1:  Full_Adder port map 
	 	 	( Pfive17(0), Pfive17(1),Pfive17(2), Psix17(1),Psix18(0) );
Psix17(2)<= Pfive17(3);

Reduction_3_Psix18_f_1:  Full_Adder port map 
	 	 	( Pfive18(0), Pfive18(1),Pfive18(2), Psix18(1),Psix19(0) );
Psix18(2)<= Pfive18(3);

Reduction_3_Psix19_f_1:  Full_Adder port map 
	 	 	( Pfive19(0), Pfive19(1),Pfive19(2), Psix19(1),Psix20(0) );
Psix19(2)<= Pfive19(3);

Reduction_3_Psix20_f_1:  Full_Adder port map 
	 	 	( Pfive20(0), Pfive20(1),Pfive20(2), Psix20(1),Psix21(0) );
Psix20(2)<= Pfive20(3);

Reduction_3_Psix21_f_1:  Full_Adder port map 
	 	 	( Pfive21(0), Pfive21(1),Pfive21(2), Psix21(1),Psix22(0) );
Psix21(2)<= Pfive21(3);

Reduction_3_Psix22_f_1:  Full_Adder port map 
	 	 	( Pfive22(0), Pfive22(1),Pfive22(2), Psix22(1),Psix23(0) );
Psix22(2)<= Pfive22(3);

Reduction_3_Psix23_f_1:  Full_Adder port map 
	 	 	( Pfive23(0), Pfive23(1),Pfive23(2), Psix23(1),Psix24(0) );
Psix23(2)<= Pfive23(3);

Reduction_3_Psix24_f_1:  Full_Adder port map 
	 	 	( Pfive24(0), Pfive24(1),Pfive24(2), Psix24(1),Psix25(0) );
Psix24(2)<= Pfive24(3);

Reduction_3_Psix25_f_1:  Full_Adder port map 
	 	 	( Pfive25(0), Pfive25(1),Pfive25(2), Psix25(1),Psix26(0) );
Psix25(2)<= Pfive25(3);

Reduction_3_Psix26_f_1:  Full_Adder port map 
	 	 	( Pfive26(0), Pfive26(1),Pfive26(2), Psix26(1),Psix27(0) );
Psix26(2)<= Pfive26(3);

Reduction_3_Psix27_f_1:  Full_Adder port map 
	 	 	( Pfive27(0), Pfive27(1),Pfive27(2), Psix27(1),Psix28(0) );
Psix27(2)<= Pfive27(3);

Reduction_3_Psix28_f_1:  Full_Adder port map 
	 	 	( Pfive28(0), Pfive28(1),Pfive28(2), Psix28(1),Psix29(0) );
Psix28(2)<= Pfive28(3);

Psix29(2 downto 1)<= P29(1 downto 0);
 

-------------------------------------------------------------------------------------------------------------
------------------------------------Reducing from 3 bit wires to 2--------------------

Reduction_2_Pfinal2_h:  Half_Adder port map
	 	 	 	 	( P2(0), P2(1), Pfinal2(0),Pfinal3(0) );
Pfinal2 (1) <= P2 (2);
Reduction_2_Pfinal3_f_1:  Full_Adder port map 
	 	 	( Psix3(0), Psix3(1), Psix3(2), Pfinal3(1),Pfinal4(0) );
Reduction_2_Pfinal4_f_1:  Full_Adder port map 
	 	 	( Psix4(0), Psix4(1), Psix4(2), Pfinal4(1),Pfinal5(0) );
Reduction_2_Pfinal5_f_1:  Full_Adder port map 
	 	 	( Psix5(0), Psix5(1), Psix5(2), Pfinal5(1),Pfinal6(0) );
Reduction_2_Pfinal6_f_1:  Full_Adder port map 
	 	 	( Psix6(0), Psix6(1), Psix6(2), Pfinal6(1),Pfinal7(0) );
Reduction_2_Pfinal7_f_1:  Full_Adder port map 
	 	 	( Psix7(0), Psix7(1), Psix7(2), Pfinal7(1),Pfinal8(0) );
Reduction_2_Pfinal8_f_1:  Full_Adder port map 
	 	 	( Psix8(0), Psix8(1), Psix8(2), Pfinal8(1),Pfinal9(0) );
Reduction_2_Pfinal9_f_1:  Full_Adder port map 
	 	 	( Psix9(0), Psix9(1), Psix9(2), Pfinal9(1),Pfinal10(0) );
Reduction_2_Pfinal10_f_1:  Full_Adder port map 
	 	 	( Psix10(0), Psix10(1), Psix10(2), Pfinal10(1),Pfinal11(0) );
Reduction_2_Pfinal11_f_1:  Full_Adder port map 
	 	 	( Psix11(0), Psix11(1), Psix11(2), Pfinal11(1),Pfinal12(0) );
Reduction_2_Pfinal12_f_1:  Full_Adder port map 
	 	 	( Psix12(0), Psix12(1), Psix12(2), Pfinal12(1),Pfinal13(0) );
Reduction_2_Pfinal13_f_1:  Full_Adder port map 
	 	 	( Psix13(0), Psix13(1), Psix13(2), Pfinal13(1),Pfinal14(0) );
Reduction_2_Pfinal14_f_1:  Full_Adder port map 
	 	 	( Psix14(0), Psix14(1), Psix14(2), Pfinal14(1),Pfinal15(0) );
Reduction_2_Pfinal15_f_1:  Full_Adder port map 
	 	 	( Psix15(0), Psix15(1), Psix15(2), Pfinal15(1),Pfinal16(0) );
Reduction_2_Pfinal16_f_1:  Full_Adder port map 
	 	 	( Psix16(0), Psix16(1), Psix16(2), Pfinal16(1),Pfinal17(0) );
Reduction_2_Pfinal17_f_1:  Full_Adder port map 
	 	 	( Psix17(0), Psix17(1), Psix17(2), Pfinal17(1),Pfinal18(0) );
Reduction_2_Pfinal18_f_1:  Full_Adder port map 
	 	 	( Psix18(0), Psix18(1), Psix18(2), Pfinal18(1),Pfinal19(0) );
Reduction_2_Pfinal19_f_1:  Full_Adder port map 
	 	 	( Psix19(0), Psix19(1), Psix19(2), Pfinal19(1),Pfinal20(0) );
Reduction_2_Pfinal20_f_1:  Full_Adder port map 
	 	 	( Psix20(0), Psix20(1), Psix20(2), Pfinal20(1),Pfinal21(0) );
Reduction_2_Pfinal21_f_1:  Full_Adder port map 
	 	 	( Psix21(0), Psix21(1), Psix21(2), Pfinal21(1),Pfinal22(0) );
Reduction_2_Pfinal22_f_1:  Full_Adder port map 
	 	 	( Psix22(0), Psix22(1), Psix22(2), Pfinal22(1),Pfinal23(0) );
Reduction_2_Pfinal23_f_1:  Full_Adder port map 
	 	 	( Psix23(0), Psix23(1), Psix23(2), Pfinal23(1),Pfinal24(0) );
Reduction_2_Pfinal24_f_1:  Full_Adder port map 
	 	 	( Psix24(0), Psix24(1), Psix24(2), Pfinal24(1),Pfinal25(0) );
Reduction_2_Pfinal25_f_1:  Full_Adder port map 
	 	 	( Psix25(0), Psix25(1), Psix25(2), Pfinal25(1),Pfinal26(0) );
Reduction_2_Pfinal26_f_1:  Full_Adder port map 
	 	 	( Psix26(0), Psix26(1), Psix26(2), Pfinal26(1),Pfinal27(0) );
Reduction_2_Pfinal27_f_1:  Full_Adder port map 
	 	 	( Psix27(0), Psix27(1), Psix27(2), Pfinal27(1),Pfinal28(0) );
Reduction_2_Pfinal28_f_1:  Full_Adder port map 
	 	 	( Psix28(0), Psix28(1), Psix28(2), Pfinal28(1),Pfinal29(0) );
Reduction_2_Pfinal29_f_1:  Full_Adder port map 
	 	 	( Psix29(0), Psix29(1), Psix29(2), Pfinal29(1),Pfinal30(0) );
Pfinal30 (1) <= P30;
-------------------------------------------------------------------------------------------

-------------------------------------------------Using Brent Kung------------------------------
cin_0 <= '0';
input1_final2bits(0) <= P0;
input1_final2bits(1) <= P1(0);

input2_final2bits(0) <='0';
input2_final2bits(1) <= P1(1);

input1_final2bits(2) <= Pfinal2(0); 
input2_final2bits(2) <= Pfinal2(1); 

input1_final2bits(3) <= Pfinal3(0); 
input2_final2bits(3) <= Pfinal3(1); 

input1_final2bits(4) <= Pfinal4(0); 
input2_final2bits(4) <= Pfinal4(1); 

input1_final2bits(5) <= Pfinal5(0); 
input2_final2bits(5) <= Pfinal5(1); 

input1_final2bits(6) <= Pfinal6(0); 
input2_final2bits(6) <= Pfinal6(1); 

input1_final2bits(7) <= Pfinal7(0); 
input2_final2bits(7) <= Pfinal7(1); 

input1_final2bits(8) <= Pfinal8(0); 
input2_final2bits(8) <= Pfinal8(1); 

input1_final2bits(9) <= Pfinal9(0); 
input2_final2bits(9) <= Pfinal9(1); 

input1_final2bits(10) <= Pfinal10(0); 
input2_final2bits(10) <= Pfinal10(1); 

input1_final2bits(11) <= Pfinal11(0); 
input2_final2bits(11) <= Pfinal11(1); 

input1_final2bits(12) <= Pfinal12(0); 
input2_final2bits(12) <= Pfinal12(1); 

input1_final2bits(13) <= Pfinal13(0); 
input2_final2bits(13) <= Pfinal13(1); 

input1_final2bits(14) <= Pfinal14(0); 
input2_final2bits(14) <= Pfinal14(1); 

input1_final2bits(15) <= Pfinal15(0); 
input2_final2bits(15) <= Pfinal15(1); 

input1_final2bits(16) <= Pfinal16(0); 
input2_final2bits(16) <= Pfinal16(1); 

input1_final2bits(17) <= Pfinal17(0); 
input2_final2bits(17) <= Pfinal17(1); 

input1_final2bits(18) <= Pfinal18(0); 
input2_final2bits(18) <= Pfinal18(1); 

input1_final2bits(19) <= Pfinal19(0); 
input2_final2bits(19) <= Pfinal19(1); 

input1_final2bits(20) <= Pfinal20(0); 
input2_final2bits(20) <= Pfinal20(1); 

input1_final2bits(21) <= Pfinal21(0); 
input2_final2bits(21) <= Pfinal21(1); 

input1_final2bits(22) <= Pfinal22(0); 
input2_final2bits(22) <= Pfinal22(1); 

input1_final2bits(23) <= Pfinal23(0); 
input2_final2bits(23) <= Pfinal23(1); 

input1_final2bits(24) <= Pfinal24(0); 
input2_final2bits(24) <= Pfinal24(1); 

input1_final2bits(25) <= Pfinal25(0); 
input2_final2bits(25) <= Pfinal25(1); 

input1_final2bits(26) <= Pfinal26(0); 
input2_final2bits(26) <= Pfinal26(1); 

input1_final2bits(27) <= Pfinal27(0); 
input2_final2bits(27) <= Pfinal27(1); 

input1_final2bits(28) <= Pfinal28(0); 
input2_final2bits(28) <= Pfinal28(1); 

input1_final2bits(29) <= Pfinal29(0); 
input2_final2bits(29) <= Pfinal29(1); 

input1_final2bits(30) <= Pfinal30(0); 
input2_final2bits(30) <= Pfinal30(1);

input1_final2bits(31) <='0';
input2_final2bits(31) <='0';




end behavioral;

