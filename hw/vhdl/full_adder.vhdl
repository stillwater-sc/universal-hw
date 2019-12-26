-- full adder

entity full_adder is
    port( a, b : in bit; 
          carry_in : in bit;
          sum, carry_out : out bit);
end entity;

architecture rtl of full_adder is
begin
    sum       <= a XOR b XOR carry_in;
    carry_out <= (a AND b) or (a AND carry_in) or (b AND carry_in);
end architecture rtl;