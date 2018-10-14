// multiply.cpp: functional tests for multiplication
//
// Copyright (C) 2017-2018 Stillwater Supercomputing, Inc.
//
// This file is part of the universal numbers project, which is released under an MIT Open Source license.

#include "common.hpp"

// when you define POSIT_VERBOSE_OUTPUT executing an MUL the code will print intermediate results
//#define POSIT_VERBOSE_OUTPUT
#define POSIT_TRACE_MUL

// minimum set of include files to reflect source code dependencies
#include <posit>
#include "../../test_helpers.hpp"
#include "../../posit_test_helpers.hpp"

// generate specific test case that you can trace with the trace conditions in posit.hpp
// for most bugs they are traceable with _trace_conversion and _trace_mul

template<size_t nbits, size_t es>
void GenerateMultiplierValidationLine(const sw::unum::posit<nbits, es>& a, const sw::unum::posit<nbits, es>& b) {
	constexpr size_t mbits = sw::unum::posit<nbits, es>::mbits;  // size of the unrounded multiplication result
	sw::unum::posit<nbits, es> product = a * b;
	sw::unum::value<mbits> result = sw::unum::quire_mul(a, b);
	sw::unum::bitblock<mbits> raw = result.fraction();
	sw::unum::bitblock<mbits> significant;
	if (!result.iszero() && !result.isinf()) {
		significant.set(mbits - 1, true); // the hidden bit articulated
		for (int i = mbits - 1; i > 0; --i) {
			significant.set(i - 1, raw[i]);
		}
	}
	std::stringstream ss;
	ss << "( '1', "										// valid
		<< (result.isinf() ? "'1', " : "'0', ")			// isNaR
		<< (result.iszero() ? "'1', " : "'0', ")		// isZero
		<< (result.isneg() ? "'1', " : "'0', ")			// sign
		<< "\"" << sw::unum::to_binary_<5>(result.scale()) << "\", "		// scale is +1 due to using significant
		<< "\"" << significant << "\")";
	std::cout << "( \"" << a.get() << "\", \"" << b.get() << "\", " << ss.str() << ", \"" << product.get() << "\" )," << std::endl;
}

// generate a test set for sanity testing the hardware design
template<size_t nbits, size_t es>
void GenerateMultiplierTestbenchTable(int start, int end) {
	// constexpr int NR_OF_POSITS = (int)1 << nbits;
	sw::unum::posit<nbits, es> a, b, sum;
	for (int i = start; i < end; ++i) {
		a.set_raw_bits(i);
		for (int j = start; j < end; ++j) {
			b.set_raw_bits(j);
			GenerateMultiplierValidationLine(a, b);
		}
	}
}

/*
Operand1 Operand2  bad     golden
======== ======== ======== ========
00000002 93ff6977 fffffffa fffffff9
00000002 b61e2f1f fffffffe fffffffd
308566ef 7fffffff 7ffffffe 7fffffff
308566ef 80000001 80000002 80000001
503f248b 7ffffffe 7ffffffe 7fffffff
503f248b 80000002 80000002 80000001
7ffffffe 503f248b 7ffffffe 7fffffff
7fffffff 308566ef 7ffffffe 7fffffff
80000001 308566ef 80000002 80000001
80000002 503f248b 80000002 80000001
93ff6977 00000002 fffffffa fffffff9
b61e2f1f 00000002 fffffffe fffffffd
b61e2f1f fffffffe 00000002 00000003
fffffffe b61e2f1f 00000002 00000003
*/
void DifficultRoundingCases() {
	sw::unum::posit<32, 2> a, b, bad, pref;
	std::vector<uint32_t> cases = {
		0x00000002, 0x93ff6977, 0xfffffffa, 0xfffffff9,
		0x00000002, 0xb61e2f1f, 0xfffffffe, 0xfffffffd,
		0x308566ef, 0x7fffffff, 0x7ffffffe, 0x7fffffff,
		0x308566ef, 0x80000001, 0x80000002, 0x80000001,
		0x503f248b, 0x7ffffffe, 0x7ffffffe, 0x7fffffff,
		0x503f248b, 0x80000002, 0x80000002, 0x80000001,
		0x7ffffffe, 0x503f248b, 0x7ffffffe, 0x7fffffff,
		0x7fffffff, 0x308566ef, 0x7ffffffe, 0x7fffffff,
		0x80000001, 0x308566ef, 0x80000002, 0x80000001,
		0x80000002, 0x503f248b, 0x80000002, 0x80000001,
		0x93ff6977, 0x00000002, 0xfffffffa, 0xfffffff9,
		0xb61e2f1f, 0x00000002, 0xfffffffe, 0xfffffffd,
		0xb61e2f1f, 0xfffffffe, 0x00000002, 0x00000003,
		0xfffffffe, 0xb61e2f1f, 0x00000002, 0x00000003,
	};
	unsigned nrOfTests = (unsigned)cases.size() / 4;
	
	for (unsigned i = 0; i < cases.size(); i+= 4) {
		a.set_raw_bits(cases[i]);
		b.set_raw_bits(cases[i + 1]);
		pref.set_raw_bits(cases[i + 3]);
		std::cout << a.get() << " * " << b.get() << " = " << pref.get() << '\n';
		//GenerateTestCase(a, b, pref);
	}
}

#define MANUAL_TESTING 1
#define STRESS_TESTING 0

int main(int argc, char** argv)
try {
	using namespace std;
	using namespace sw::unum;

	bool bReportIndividualTestCases = true;
	int nrOfFailedTestCases = 0;

	cout << "Posit multiplication validation test generation" << endl;

	std::string tag = "Multiplication Validation: ";

#if MANUAL_TESTING
	// generate individual testcases to hand trace/debug
	
	posit<8, 0> a, b;

	a.set_raw_bits(0x00);
	b.set_raw_bits(0x80);
	GenerateMultiplierValidationLine(a, b);

	a.set_raw_bits(0x41);
	b.set_raw_bits(0xC0);
	for (int i = 0; i < 8; ++i) {
		GenerateMultiplierValidationLine(a, b++);
	}

	GenerateMultiplierTestbenchTable<8, 0>(0, 8);

#else

	GenerateMultiplierTestbenchTable<8, 0>(0, 256);

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

