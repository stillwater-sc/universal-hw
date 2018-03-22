LIBRARY IEEE,STD;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;

ENTITY test_vector_reader IS
	GENERIC (NBITS : integer);
	PORT (
	    op1     : out std_logic_vector(NBITS-1 downto 0);
	    op2     : out std_logic_vector(NBITS-1 downto 0);
	    ref     : in  std_logic_vector(NBITS-1 downto 0));
END test_vector_reader;

ARCHITECTURE behavior OF test_vector_reader IS
BEGIN
    file_io: PROCESS IS
	FILE in_file  : TEXT OPEN READ_MODE IS "addition_posit_5_0.vnv";
	FILE out_file : TEXT OPEN WRITE_MODE IS "vnv_results";
	VARIABLE out_line : LINE;
	VARIABLE in_line : LINE;

	VARIABLE nbits : INTEGER;
	VARIABLE es    : INTEGER;
	VARIABLE testCase : INTEGER;
	VARIABLE a,b,c  : STD_LOGIC_VECTOR(NBITS-1 downto 0);
	VARIABLE result : STD_LOGIC_VECTOR(NBITS-1 downto 0);
	BEGIN
	    -- read and report the posit configuration
	    READLINE(in_file, in_line);
	    READ(in_line, nbits);
	    READ(in_line, es);
		-- construct an output message to the console
	    WRITE(out_line, string'("posit<"));
	    WRITE(out_line, nbits);
	    WRITE(out_line, string'(","));
	    WRITE(out_line, es);
	    WRITE(out_line, string'(">"));
	    WRITELINE(OUTPUT, out_line);

	    -- read the test vector elements
	    WHILE NOT ENDFILE(in_file) LOOP
		 READLINE(in_file, in_line);
		 READ(in_line, testCase);
		 READ(in_line, a);
		 READ(in_line, b);
		 READ(in_line, c);

		-- construct an output message
		 WRITE(out_line, a);
		 WRITE(out_line, string'(" + "));
		 WRITE(out_line, b);
		 WRITE(out_line, string'(" = "));
		 WRITE(out_line, c);
		 WRITELINE(OUTPUT, out_line);

		-- schedule signal transactions
		op1 <= a;
		op2 <= b;
		WAIT;
		

		 WRITE(out_line, result);
		 WRITELINE(out_file, out_line);
	    END LOOP;
	    ASSERT FALSE REPORT "Simulation done" SEVERITY NOTE;
	    WAIT; --allows the simulation to halt!
    END PROCESS file_io;

END ARCHITECTURE behavior;
