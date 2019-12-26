library IEEE, STD;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;

entity test_vector is
    generic (NBITS : integer := 5);
    port (
        op1   : out std_logic_vector(NBITS-1 downto 0);
        op2   : out std_logic_vector(NBITS-1 downto 0);
        ref   : in  std_logic_vector(NBITS-1 downto 0));
end entity test_vector;

architecture behavior of test_vector is
CONSTANT POSIT_NBITS : integer := 5;

signal a : std_logic_vector(POSIT_NBITS-1 downto 0);
signal b : std_logic_vector(POSIT_NBITS-1 downto 0);

begin
    tests : process is
    file out_file : TEXT OPEN WRITE_MODE IS "manual_test_results";
    variable out_line : LINE;
    begin
        a <= b"00000";
        b <= b"00001";

	op1 <= a;
	op2 <= b;

	-- construct an output message
	WRITE(out_line, a);
	WRITE(out_line, string'(" + "));
	WRITE(out_line, b);
	WRITE(out_line, string'(" = "));
	WRITE(out_line, ref);
	WRITELINE(OUTPUT, out_line);   -- output on the console
	WRITELINE(out_file, out_line); -- and to a file

        assert false report "Simulation done" severity note;
        wait;  
    end process tests;

end architecture behavior;