-- testbench for our full adder
entity adder_tb is
end entity;

architecture behavior of adder_tb is
    -- Declarations
    component full_adder
	port( a,b, carry_in : in bit;
              sum, carry_out: out bit);
    end component;

    -- Specify which entity is bound
    for full_adder_0: full_adder use entity work.full_adder;

    -- Internal signals
    signal a, b, ci, s, co : bit;

begin
    -- Component instantiation
    full_adder_0: full_adder 
	port map ( a         =>   a,
		   b         =>   b,
		   carry_in  =>  ci,
		   sum       =>   s,
		   carry_out =>  co);

    -- testbench process
    tb_proc: process
	type pattern_type is record
	    a, b, ci : bit;
	    s, co    : bit;
	end record;

	-- test patterns to apply
	type pattern_array is array (natural range <>) of pattern_type;
	constant patterns : pattern_array :=
	  (('0', '0', '0', '0', '0'),
	   ('0', '0', '1', '1', '0'),
	   ('0', '1', '0', '1', '0'),
	   ('0', '1', '1', '0', '1'),
	   ('1', '0', '0', '1', '0'),
	   ('1', '0', '1', '0', '1'),
	   ('1', '1', '0', '0', '1'),
	   ('1', '1', '1', '1', '1'));
    begin
	-- issue and check each pattern
	for i in patterns'range loop
	    a <= patterns(i).a;
	    b <= patterns(i).b;
	    ci <= patterns(i).ci;
	    wait for 1 ns;
	    assert s  = patterns(i).s  report "FAIL: sum value" severity error;
	    assert co = patterns(i).co report "FAIL: carry out" severity error;
	end loop;

	assert false report "END OF TEST" severity note;
	wait;
    end process;


end architecture behavior;
