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
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package pf_functions is

    --- lza
    function lza(signal s : std_logic_vector) return std_logic_vector;


end package pf_functions;

package body pf_functions is

    -- lza
    function lza(signal s : std_logic_vector) return std_logic_vector is
        variable index : std_logic_vector(7 downto 0);
    begin
        index := "00000000";
        return index;
    end function lza;

end package pf_functions;