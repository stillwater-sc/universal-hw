-- clock generator
use ieee.std_logic;

entity clock_generator is
    port(clk : out std_logic );
end entity clock;

architecture behavior of clock_generator is
begin
    clock_proc: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process clock_proc;

end architecture behavior;