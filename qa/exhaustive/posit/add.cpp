// arithmetic_add.cpp: functional tests for addition
//
// Copyright (C) 2017-2018 Stillwater Supercomputing, Inc.
//
// This file is part of the universal numbers project, which is released under an MIT Open Source license.

#include "common.hpp"

// when you define POSIT_VERBOSE_OUTPUT executing an ADD the code will print intermediate results
//#define POSIT_VERBOSE_OUTPUT
//#define POSIT_TRACE_ADD

// minimum set of include files to reflect source code dependencies
//#define POSIT_VERBOSE_OUTPUT
#define POSIT_TRACE_ADD
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

template<size_t nbits, size_t es>
void GenerateTestLine(const sw::unum::posit<nbits, es>& a, const sw::unum::posit<nbits, es>& b) {
	constexpr size_t rbits = nbits - es + 2;  // size of the unrounded addition result
	sw::unum::posit<nbits, es> sum = a + b;
	sw::unum::value<rbits> result = sw::unum::quire_add(a, b);
	sw::unum::bitblock<rbits> raw = result.fraction();
	sw::unum::bitblock<rbits> significant;
	significant.set(rbits - 1, true); // the hidden bit articulated
	for (int i = rbits - 1; i > 0; --i) {
		significant.set(i - 1, raw[i]);
	}
	std::stringstream ss;
	ss << "( '1', "										// valid
		<< (result.isnan() ? "'1', " : "'0', ")			// isNaR
		<< (result.iszero() ? "'1', " : "'0', ")		// isZero
		<< (result.isneg() ? "'1', " : "'0', ")			// sign
		<< "\"" << sw::unum::to_binary_<5>(result.scale()) << "\", "		// scale is +1 due to using significant
		<< "\"" << significant << "\")";
	std::cout << "( \"" << a.get() << "\", \"" << b.get() << "\", " << ss.str() << ", \"" << sum.get() << "\" )," << std::endl;
}

template<size_t nbits, size_t es> 
void GenerateAdderTestbenchTable(int start, int end) {
	// constexpr int NR_OF_POSITS = (int)1 << nbits;
	sw::unum::posit<nbits, es> a, b, sum;
	for (int i = start; i < end; ++i) {
		a.set_raw_bits(i);
		for (int j = start; j < end; ++j) {
			b.set_raw_bits(j);
			GenerateTestLine(a, b);
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

	std::string tag = "Addition Validation : ";

#if MANUAL_TESTING
	// generate individual testcases to hand trace/debug
	//GenerateTestCase<6, 3, double>(INFINITY, INFINITY);
	//GenerateTestCase<8, 4, float>(0.5f, -0.5f);
	//GenerateTestCase<3, 0, float>(0.5f, 1.0f);

	// manual exhaustive test
//	GenerateValidationTestSet<5, 0>("addition");
//	GenerateValidationTestSet<5, 1>("addition");
//	GenerateValidationTestSet<5, 2>("addition");

	// posit<8,0> has 256 values: 1 is at 128
	GenerateAdderTestbenchTable<8, 0>(0, 16);
	GenerateAdderTestbenchTable<8, 0>(56, 71);
	//GenerateAdderTestbenchTable<8, 0>(120, 135);
	//GenerateAdderTestbenchTable<8, 0>(128 + 56, 128 + 71);

#else

	cout << "Posit addition validation test generation" << endl;



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
