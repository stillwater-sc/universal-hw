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

library work;

package pfu_components is

--- Component declarations
component pf_add is
    generic(
        EXPONENT_SIZE : integer;
        MANTISSA_SIZE : integer
    );
    port(
        clk      : in    std_logic;
        rst      : in    std_logic;
    -- first operand
        op1_zero : in    std_logic;    --- special case of 0
        op1_NaR  : in    std_logic;    --- special case of Not a Real
        op1_sign : in    std_logic;
        op1_expo : in    std_logic_vector(EXPONENT_SIZE downto 0);
        op1_mant : in    std_logic_vector(MANTISSA_SIZE downto 0);
    -- second operand
        op2_zero : in    std_logic;    --- special case of 0
        op2_NaR  : in    std_logic;    --- special case of Not a Real
        op2_sign : in    std_logic;
        op2_expo : in    std_logic_vector(EXPONENT_SIZE downto 0);
        op2_mant : in    std_logic_vector(MANTISSA_SIZE downto 0);
    -- result
        sum_zero : in    std_logic;    --- special case of 0
        sum_NaR  : in    std_logic;    --- special case of Not a Real
        sum_sign : in    std_logic;
        sum_expo : in    std_logic_vector(EXPONENT_SIZE downto 0);
        sum_mant : in    std_logic_vector(MANTISSA_SIZE+1 downto 0);    
    );
end component pf_add;


end package pfu_components;