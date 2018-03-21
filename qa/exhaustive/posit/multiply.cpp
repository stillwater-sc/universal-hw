// arithmetic_multiply.cpp: functional tests for multiplication
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

// generate specific test case that you can trace with the trace conditions in posit.h
// for most bugs they are traceable with _trace_conversion and _trace_mul
template<size_t nbits, size_t es, typename Ty>
void GenerateTestCase(Ty a, Ty b) {
	Ty ref;
	sw::unum::posit<nbits, es> pa, pb, pref, pmul;
	pa = a;
	pb = b;
	ref = a * b;
	pref = ref;
	pmul = pa * pb;
	std::cout << std::setprecision(nbits - 2);
	std::cout << std::setw(nbits) << a << " * " << std::setw(nbits) << b << " = " << std::setw(nbits) << ref << std::endl;
	std::cout << pa.get() << " * " << pb.get() << " = " << pmul.get() << " (reference: " << pref.get() << ")   ";
	std::cout << (pref == pmul ? "PASS" : "FAIL") << std::endl << std::endl;
	std::cout << std::setprecision(5);
}

template<size_t nbits, size_t es>
void GenerateTestCase( sw::unum::posit<nbits,es> pa, sw::unum::posit<nbits,es> pb, sw::unum::posit<nbits, es> pref) {
	double a = double(pa);
	double b = double(pb);
	double ref = a * b;
	//sw::unum::posit<nbits, es> pref = ref;
	sw::unum::posit<nbits, es> pmul = pa * pb;
	std::cout << std::setprecision(nbits - 2);
	std::cout << std::setw(nbits) << a << " * " << std::setw(nbits) << b << " = " << std::setw(nbits) << ref << std::endl;
	std::cout << pa.get() << " * " << pb.get() << " = " << pmul.get() << " (reference: " << pref.get() << ")   ";
	std::cout << (pref == pmul ? "PASS" : "FAIL") << std::endl << std::endl;
	std::cout << std::setprecision(5);
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
		//cout << a.get() << " * " << b.get() << " = " << pref.get() << endl;
		GenerateTestCase(a, b, pref);
	}
}

#define MANUAL_TESTING 0
#define STRESS_TESTING 0

int main(int argc, char** argv)
try {
	using namespace std;
	using namespace sw::unum;

	bool bReportIndividualTestCases = true;
	int nrOfFailedTestCases = 0;

	cout << "Posit multiplication validation test generation" << endl;

	std::string tag = "Multiplication failed: ";

#if MANUAL_TESTING
	// generate individual testcases to hand trace/debug

	/*
	float fa, fb;
	fa = 0.0f; fb = INFINITY;
	std::cout << fa << " " << fb << std::endl;
	GenerateTestCase<4,0, float>(fa, fb);
	GenerateTestCase<16, 1, float>(float(minpos_value<16, 1>()), float(maxpos_value<16, 1>()));
	*/

	DifficultRoundingCases();
	

	nrOfFailedTestCases += ReportTestResult(ValidateMultiplication<2, 0>("Manual Testing: ", bReportIndividualTestCases), "posit<2,0>", "multiplication");
	nrOfFailedTestCases += ReportTestResult(ValidateMultiplication<3, 0>("Manual Testing: ", bReportIndividualTestCases), "posit<3,0>", "multiplication");
	nrOfFailedTestCases += ReportTestResult(ValidateMultiplication<3, 1>("Manual Testing: ", bReportIndividualTestCases), "posit<3,1>", "multiplication");
	nrOfFailedTestCases += ReportTestResult(ValidateMultiplication<4, 0>("Manual Testing: ", bReportIndividualTestCases), "posit<4,0>", "multiplication");

#else



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

