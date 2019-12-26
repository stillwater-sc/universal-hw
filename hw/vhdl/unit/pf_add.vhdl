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
---- This process generates a triple (sign, scale, significant).
---- These triples are the input values to the arithmetic units.

---- When posits are loaded into the register file, they are decoded
---- into their triple format, so that there is no decode overhead
---- during execution.




library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;

--- a posit float add module
entity pf_add is
    generic(
        EXPONENT_SIZE : integer;
        MANTISSA_SIZE : integer
    );
    port(
        clk      : in    std_logic;
        rst      : in    std_logic;
    -- first operand
        op1_zero        : in    std_logic;    --- special case of 0
        op1_NaR         : in    std_logic;    --- special case of Not a Real
        op1_sign        : in    std_logic;
        op1_scale       : in    std_logic_vector(EXPONENT_SIZE downto 0);
        op1_significant : in    std_logic_vector(MANTISSA_SIZE downto 0);
    -- second operand
        op2_zero        : in    std_logic;    --- special case of 0
        op2_NaR         : in    std_logic;    --- special case of Not a Real
        op2_sign        : in    std_logic;
        op2_scale       : in    std_logic_vector(EXPONENT_SIZE downto 0);
        op2_significant : in    std_logic_vector(MANTISSA_SIZE downto 0);
    -- result
        sum_zero        : in    std_logic;    --- special case of 0
        sum_NaR         : in    std_logic;    --- special case of Not a Real
        sum_sign        : in    std_logic;
        sum_scale       : in    std_logic_vector(EXPONENT_SIZE downto 0);
        sum_significant : in    std_logic_vector(MANTISSA_SIZE+1 downto 0);    
    );
end entity pf_add;

---
--- 	// we model a hw pipeline with register assignments, functional block, and conversion
---	posit<nbits, es>& operator+=(const posit& rhs) {
---		if (_trace_add) std::cout << "---------------------- ADD -------------------" << std::endl;
---		// special case handling of the inputs
---		if (isNaR() || rhs.isNaR()) {
---			setToNaR();
---			return *this;
---		}
---		if (isZero()) {
---			*this = rhs;
---			return *this;
---		}
---		if (rhs.isZero()) return *this;
---
---		// arithmetic operation
---		value<abits + 1> sum;
---		value<fbits> a, b;
---		// transform the inputs into (sign,scale,fraction) triples
---		normalize(a);
---		rhs.normalize(b);
---		module_add<fbits,abits>(a, b, sum);		// add the two inputs
---
---		// special case handling of the result
---		if (sum.isZero()) {
---			setToZero();
---		}
---		else if (sum.isInfinite()) {
---			setToNaR();
---		}
---		else {
---			convert(sum);
---		}
---		return *this;                
---	}

architecture behavior of pf_add is

begin

    PROC: process
    begin
        if (rst = '1') then
            sum_zero <= '0';
            sum_NaR  <= '1';
            sum_sign <= '0';
            sum_expo <= (others is '0');
            sum_mant <= (others is '0');
        else
            if (op1_NaR or op2_NaR) then
                sum_zero <= '0';
                sum_NaR  <= '1';
                sum_sign <= '0';
                sum_expo <= (others => '0');
                sum_mant <= (others => '0');
            end if;
            if (op2_zero) then
                sum_zero <= op1_zero;
                sum_NaR  <= op1_NaR;
                sum_sign <= op1_sign;
                sum_expo <= op1_expo;
                sum_mant <= op1_mant + '0';
            elsif (op1_zero) then
                sum_zero <= op2_zero;
                sum_NaR  <= op2_NaR;
                sum_sign <= op2_sign;
                sum_expo <= op2_expo;
                sum_mant <= op2_mant + '0';
            end if;
            if (op1_expo > op2_expo) then

            else 

            end if;

        end if;
    end process PROC;

end architecture behavior;

architecture rtl of pf_add is

end architecture rtl;

		template<size_t fbits, size_t abits>
		void module_add(const value<fbits>& lhs, const value<fbits>& rhs, value<abits + 1>& result) {
			// with sign/magnitude adders it is customary to organize the computation 
			// along the four quadrants of sign combinations
			//  + + = +
			//  + - =   lhs > rhs ? + : -
			//  - + =   lhs > rhs ? - : +
			//  - - = 
			// to simplify the result processing assign the biggest 
			// absolute value to R1, then the sign of the result will be sign of the value in R1.

			if (lhs.isInfinite() || rhs.isInfinite()) {
				result.setToInfinite();
				return;
			}
			int lhs_scale = lhs.scale(), rhs_scale = rhs.scale(), scale_of_result = std::max(lhs_scale, rhs_scale);

			// align the fractions
			bitblock<abits> r1 = lhs.template nshift<abits>(lhs_scale - scale_of_result + 3);
			bitblock<abits> r2 = rhs.template nshift<abits>(rhs_scale - scale_of_result + 3);
			bool r1_sign = lhs.sign(), r2_sign = rhs.sign();
			bool signs_are_different = r1_sign != r2_sign;

			if (signs_are_different && sw::unum::abs(lhs) < sw::unum::abs(rhs)) {
				std::swap(r1, r2);
				std::swap(r1_sign, r2_sign);
			}

			if (signs_are_different) r2 = twos_complement(r2);

			if (_trace_add) {
				std::cout << (r1_sign ? "sign -1" : "sign  1") << " scale " << std::setw(3) << scale_of_result << " r1       " << r1 << std::endl;
				std::cout << (r2_sign ? "sign -1" : "sign  1") << " scale " << std::setw(3) << scale_of_result << " r2       " << r2 << std::endl;
			}

			bitblock<abits + 1> sum;
			const bool carry = add_unsigned(r1, r2, sum);

			if (_trace_add) std::cout << (r1_sign ? "sign -1" : "sign  1") << " carry " << std::setw(3) << (carry ? 1 : 0) << " sum     " << sum << std::endl;

			long shift = 0;
			if (carry) {
				if (r1_sign == r2_sign) {  // the carry && signs== implies that we have a number bigger than r1
					shift = -1;
				} 
				else {
					// the carry && signs!= implies r2 is complement, result < r1, must find hidden bit (in the complement)
					for (int i = abits - 1; i >= 0 && !sum[i]; i--) {
						shift++;
					}
				}
			}
			assert(shift >= -1);

			if (shift >= long(abits)) {            // we have actual 0                            
				sum.reset();
				result.set(false, 0, sum, true, false, false);
				return;
			}

			scale_of_result -= shift;
			const int hpos = abits - 1 - shift;         // position of the hidden bit 
			sum <<= abits - hpos + 1;
			if (_trace_add) std::cout << (r1_sign ? "sign -1" : "sign  1") << " scale " << std::setw(3) << scale_of_result << " sum     " << sum << std::endl;
			result.set(r1_sign, scale_of_result, sum, false, false, false);
		}