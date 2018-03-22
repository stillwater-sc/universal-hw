library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DUT is
	generic (NBITS : integer);
	port (
	    a     : in  std_logic_vector(NBITS-1 downto 0);
	    b     : in  std_logic_vector(NBITS-1 downto 0);
	    c     : out std_logic_vector(NBITS-1 downto 0));
end DUT;

architecture behavior of DUT is
begin
    proc : process is
    begin
	c <= std_logic_vector(unsigned(a) + unsigned(b));
	wait; 
    end process proc;
end architecture behavior;
