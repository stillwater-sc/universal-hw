// to_sff.cpp: functional tests for conversion between a posit and (sign, scale, fraction0
//
// Copyright (C) 2017-2018 Stillwater Supercomputing, Inc.
//
// This file is part of the universal numbers project, which is released under an MIT Open Source license.

#include "common.hpp"

// when you define POSIT_VERBOSE_OUTPUT executing an ADD the code will print intermediate results
//#define POSIT_VERBOSE_OUTPUT
//#define POSIT_TRACE_ADD

// minimum set of include files to reflect source code dependencies
#include <posit>
#include "../../test_helpers.hpp"
#include "../../posit_test_helpers.hpp"

// generate specific test case that you can trace with the trace conditions in posit.h
// for most bugs they are traceable with _trace_conversion and _trace_add
template<size_t nbits, size_t es, typename Ty>
void GenerateTestCase(Ty a, Ty b) {
	Ty ref;
	sw::unum::posit<nbits, es> pa, pb, pref, psum;
	pa = a;
	pb = b;
	ref = a + b;
	pref = ref;
	psum = pa + pb;
	std::cout << std::setprecision(nbits - 2);
	std::cout << std::setw(nbits) << a << " + " << std::setw(nbits) << b << " = " << std::setw(nbits) << ref << std::endl;
	std::cout << pa.get() << " + " << pb.get() << " = " << psum.get() << " (reference: " << pref.get() << ")   " ;
	std::cout << (pref == psum ? "PASS" : "FAIL") << std::endl << std::endl;
	std::cout << std::setprecision(5);
}

/*

type posit_convertion_type is record
	a_raw : std_logic_vector(NBITS - 1 downto 0);
	a_ssf : ssf_type;
end record;
type pattern_array is array (natural range <>) of posit_convertion_type;

We need to generate this text:
constant test_patterns : pattern_array := (
	("00000000", ('0', '1', '0', "00000", "00000")),
	("00000001", ('0', '0', '0', "00000", "00000")),
	("10000000", ('1', '0', '0', "00000", "00000"))
);
*/
template<size_t nbits, size_t es, size_t sbits, size_t fbits> 
void GenerateTestPatternTable(std::ostream& ostr) {
	constexpr size_t NR_OF_POSITS = (size_t(1) << nbits);
	sw::unum::bitblock<sbits> _scale;
	sw::unum::posit<nbits, es> a;
	bool s;
	sw::unum::regime<nbits, es> r;
	sw::unum::exponent<nbits, es> e;
	sw::unum::fraction<fbits> f;
	for (int i = 0; i < NR_OF_POSITS; ++i) {
		a.set_raw_bits(i);
		_scale = sw::unum::convert_to_bitblock<5,int>(sw::unum::scale(a));
		decode(a.get(), s, r, e, f);
		ostr << "( \"" << a.get() << "\", ("
			<< (a.iszero() ? "'1', " : "'0', ")
			<< (a.isnar() ? "'1', " : "'0', ")
			<< (s ? "'1', " : "'0', ")
			<< "\"" << sw::unum::to_binary(_scale) << "\", "
			<< "\"" << sw::unum::to_binary(f.get()) << "\") ),\n";
	}
}

#define MANUAL_TESTING 1
#define STRESS_TESTING 0

int main(int argc, char** argv)
try {
	using namespace std;
	using namespace sw::qa;

	bool bReportIndividualTestCases = false;
	int nrOfFailedTestCases = 0;

	std::string tag = "SSF triplet Validation : ";

#if MANUAL_TESTING


	GenerateTestPatternTable<8,0,5,5>(cout);

#else

	cout << "Posit to ssf conversion test generation" << endl;



#if STRESS_TESTING



#endif  // STRESS_TESTING

#endif  // MANUAL_TESTING

	return (nrOfFailedTestCases > 0 ? EXIT_FAILURE : EXIT_SUCCESS);
}
catch (char const* msg) {
	std::cerr << msg << std::endl;
	return EXIT_FAILURE;
}
catch (...) {
	std::cerr << "Caught unknown exception" << std::endl;
	return EXIT_FAILURE;
}
