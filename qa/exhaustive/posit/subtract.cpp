// subtract.cpp: exhaustive functional tests for subtraction
//
// Copyright (C) 2017-2020 Stillwater Supercomputing, Inc.
//
// This file is part of the universal numbers project, which is released under an MIT Open Source license.
#include "common.hpp"

// when you define POSIT_VERBOSE_OUTPUT executing an SUB the code will print intermediate results
//#define POSIT_VERBOSE_OUTPUT
#define POSIT_TRACE_SUB

// minimum set of include files to reflect source code dependencies
#include <universal/number/posit/posit>
#include "../../test_helpers.hpp"
#include "../../posit_test_helpers.hpp"

// generate specific test case that you can trace with the trace conditions in posit.h
// for most bugs they are traceable with _trace_conversion and _trace_sub
template<size_t nbits, size_t es, typename Ty>
void GenerateTestCase(Ty a, Ty b) {
	Ty ref;
	sw::universal::posit<nbits, es> pa, pb, pref, pdif;
	pa = a;
	pb = b;
	ref = a - b;
	pref = ref;
	pdif = pa - pb;
	std::cout << std::setprecision(nbits - 2);
	std::cout << std::setw(nbits) << a << " - " << std::setw(nbits) << b << " = " << std::setw(nbits) << ref << std::endl;
	std::cout << pa.get() << " - " << pb.get() << " = " << pdif.get() << " (reference: " << pref.get() << ")  ";
	std::cout << (pref == pdif ? "PASS" : "FAIL") << std::endl << std::endl;
	std::cout << std::setprecision(5);
}

#define MANUAL_TESTING 0
#define STRESS_TESTING 0

int main(int argc, char** argv)
try {
	using namespace std;
	using namespace sw::universal;

	bool bReportIndividualTestCases = false;
	int nrOfFailedTestCases = 0;

	std::string tag = "Subtraction failed: ";

#if MANUAL_TESTING

	//ValidateBitsetSubtraction<4>(true);

	// generate individual testcases to hand trace/debug
	GenerateTestCase<4, 0, double>(0.25, 0.75);
	GenerateTestCase<4, 0, double>(0.25, -0.75);
	GenerateTestCase<8, 0, double>(1.0, 0.25);
	GenerateTestCase<8, 0, double>(1.0, 0.125);
	GenerateTestCase<8, 0, double>(1.0, 1.0);

	// manual exhaustive testing
	std::string positCfg = "posit<4,0>";
	nrOfFailedTestCases += ReportTestResult(ValidateSubtraction<4, 0>("Manual Testing", true), positCfg, "subtraction");

	// FAIL 011001011010110100000110111110010111010011001010 - 000010111000000110100000001010011011111111110110 != 011001011010110011111111111101100011010001110110 instead it yielded 011001011010110011111111111101100011010001110111
	unsigned long long a = 0b011001011010110100000110111110010111010011001010ull;
	unsigned long long b = 0b000010111000000110100000001010011011111111110110ull;
	posit<48, 2> pa(a);
	posit<48, 2> pb(b);
	posit<48, 2> pdiff = pa - pb;
	cout << pdiff.get() << endl;
	std::bitset<48> ba = pa.get();
	cout << a << endl;
	cout << ba << endl;
	//nrOfFailedTestCases += ReportTestResult(ValidateThroughRandoms<48, 2>(tag, true, OPCODE_SUB, 1000), "posit<48,2>", "subtraction");


#else


#if STRESS_TESTING


#endif

#endif

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
