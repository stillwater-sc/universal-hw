LIBRARY IEEE,STD;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;

ENTITY add_tb IS
END add_tb;

ARCHITECTURE behavior OF add_tb IS

	COMPONENT test_vector_reader
  	  generic (NBITS : integer);
  	  port(a, b: out std_logic_vector(NBITS-1 downto 0);
   	       c   : in  std_logic_vector(NBITS-1 downto 0));
	END COMPONENT;

	COMPONENT DUT
 	   generic (NBITS : integer);
 	   port(
 	        a, b: in  std_logic_vector(NBITS-1 downto 0);
 	        c   : out std_logic_vector(NBITS-1 downto 0));
	END COMPONENT;

	CONSTANT POSIT_NBITS : integer := 5;
	CONSTANT POSIT_ES    : integer := 0;

	SIGNAL op1, op2, result: std_logic_vector(POSIT_NBITS-1 downto 0);

BEGIN
    U1: entity work.test_vector_reader 
        generic map(NBITS => POSIT_NBITS)
        port map(op1, op2, result);

    U2: entity work.DUT 
        generic map(NBITS => POSIT_NBITS)
        port map(op1, op2, result);

END ARCHITECTURE behavior;
