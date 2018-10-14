// add.cpp: functional tests for addition
//
// Copyright (C) 2017-2018 Stillwater Supercomputing, Inc.
//
// This file is part of the universal numbers project, which is released under an MIT Open Source license.

#include "common.hpp"

// when you define POSIT_VERBOSE_OUTPUT executing an ADD the code will print intermediate results
//#define POSIT_VERBOSE_OUTPUT
#define POSIT_TRACE_ADD

// minimum set of include files to reflect source code dependencies
#include <posit>
#include "../../test_helpers.hpp"
#include "../../posit_test_helpers.hpp"

// generate specific test case that you can trace with the trace conditions in posit.hpp
// for most bugs they are traceable with _trace_conversion and _trace_add

template<size_t nbits, size_t es>
void GenerateAdderValidationLine(const sw::unum::posit<nbits, es>& a, const sw::unum::posit<nbits, es>& b) {
	constexpr size_t rbits = nbits - es + 2;  // size of the unrounded addition result
	sw::unum::posit<nbits, es> sum = a + b;
	sw::unum::value<rbits> result = sw::unum::quire_add(a, b);
	sw::unum::bitblock<rbits> raw = result.fraction();
	sw::unum::bitblock<rbits> significant;
	if (!result.iszero() && !result.isinf()) {
		significant.set(rbits - 1, true); // the hidden bit articulated
		for (int i = rbits - 1; i > 0; --i) {
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
	std::cout << "( \"" << a.get() << "\", \"" << b.get() << "\", " << ss.str() << ", \"" << sum.get() << "\" )," << std::endl;
}

// generate a test set for sanity testing the hardware design
template<size_t nbits, size_t es> 
void GenerateAdderTestbenchTable(int start, int end) {
	// constexpr int NR_OF_POSITS = (int)1 << nbits;
	sw::unum::posit<nbits, es> a, b, sum;
	for (int i = start; i < end; ++i) {
		a.set_raw_bits(i);
		for (int j = start; j < end; ++j) {
			b.set_raw_bits(j);
			GenerateAdderValidationLine(a, b);
		}
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

	cout << "Posit addition validation test generation" << endl;

	std::string tag = "Addition Validation : ";

#if MANUAL_TESTING
	// generate individual testcases to hand trace/debug
	posit<8, 0> a, b;

	a.set_raw_bits(0x01);
	b.set_raw_bits(0x70);
	for (int i = 0; i < 8; ++i) {
		GenerateAdderValidationLine(a, b++);
	}
	a.set_raw_bits(0x03);
	b.set_raw_bits(0x70);
	for (int i = 0; i < 8; ++i) {
		GenerateAdderValidationLine(a, b++);
	}
	a.set_raw_bits(0x21);
	b.set_raw_bits(0x70);
	for (int i = 0; i < 8; ++i) {
		GenerateAdderValidationLine(a, b++);
	}

	cout << "normalization and behavior of uncertainty bit (LSB in the normalized number)\n";
	value<5> v;
	v.set(sign(a), scale(a), extract_fraction<8,0,5>(a), false, false, false);
	for (int i = -5; i < 3; ++i) {
		cout << "normalize by " << setw(2) << i << " : " << v.template nshift<9>(i) << endl;
	}


	// manual exhaustive test
	cout << "ranges of test cases\n";
	// posit<8,0> has 256 values: 0 is at 0, 1 is at 64, NaR is at 128, -1 is at 192
	GenerateAdderTestbenchTable<8, 0>(0, 4);
	//GenerateAdderTestbenchTable<8, 0>(126, 130);

	//GenerateAdderTestbenchTable<8, 0>(0, 16);
	//GenerateAdderTestbenchTable<8, 0>(56, 71);
	//GenerateAdderTestbenchTable<8, 0>(120, 135);
	//GenerateAdderTestbenchTable<8, 0>(184, 200);
	//GenerateAdderTestbenchTable<8, 0>(240, 256);


#else

	GenerateAdderTestbenchTable<8, 0>(0, 256);

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
