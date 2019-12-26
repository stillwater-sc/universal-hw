------------------------------------------------------------------
----                                                          ----
----  Content: Parameterized posit float compute unit         ----
----                                                          ----
----  Author:  E. Theodore L. Omtzigt                         ----
----           theo@stillwater-sc.com                         ----
----                                                          ----
------------------------------------------------------------------
----                                                          ----
---- Copyright (C) 2017-2018                                  ----
----               E. Theodore L. Omtzigt                     ----
----               theo@stillwater-sc.com                     ----
----                                                          ----
------------------------------------------------------------------

---- A posit is a tapered floating point representation. To compute
---- with posits, the regime and exponent fields need to be consolidated.
---- This process generates a triple (sign, exponent, significant).
---- These triples are the input values to the arithmetic units.

library ieee;
use work.pfu_functions.all;
use work.pfu_components.all;

entity pf_tb is
end entity pf_tb;

architecture behavior of pf_tb is

    component pfu
	    port(
	        clk     : in std_logic;
	        rst     : in std_logic;
	    );
    end component pfu;

    signal NOT_DONE : BOOLEAN := TRUE;

    signal clk      : std_logic;
    signal rst      : std_logic;
    signal rdy      : std_logic;

    signal NaR      : std_logic;
    signal zero     : std_logic;

	begin
	    UUT : pfu
	    generic map (
	    );
	    port map (
	        clk    => clk,
	        rst    => rst,
	        rdy    => rdy,

	        NaR    => NaR,
	        zero   => zero
	    );

	CLK: process
	begin
        if NOT_DONE = TRUE then
            clk <= '0';
            wait for 5 ns;
        else 
            wait;
        end if;
          if NOT_DONE = TRUE then
            clk <= '1';
            wait for 5 ns;
        else 
            wait;
        end if;      
	end process CLK;

	STIMULUS: process
	begin
        rst <= '1' wait for 20 ns;
        rst <= '0';

        --- drive 0's
        --- terminate the simulation
        NOT_DONE = FALSE;
	    wait;
	end process STIMULUS;

end architecture behavior;

configuration TB_PFU_8_0 of pfu is
    for behavior
        for UUT : pfu
            use entity work.pfu(behavior);
        end for;
    end for;
end configuration TB_PFU_8_0;
