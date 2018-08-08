// skeleton.cpp example showing the basic program structure to use custom posit configurations
//
// Copyright (C) 2017-2018 Stillwater Supercomputing, Inc.
//
// This file is part of the universal numbers project, which is released under an MIT Open Source license.
#include "stdafx.h"

#include <posit>

int main(int argc, char** argv)
try {
	using namespace std;
	using namespace sw::unum;

	bool bSuccess = true;

	{
		constexpr size_t nbits = 8;
		constexpr size_t es = 1;

		posit<nbits, es> p;

		// assign PI to posit<8,1>
		p = m_pi;
		cout << "posit<8,1> value of PI    = " << p << " " << color_print(p) << " " << pretty_print(p) << endl;

		// convert posit back to float
		float f = float(p);
		cout << "float value               = " << f << endl;

		// calculate PI/2
		p = p / posit<nbits, es>(2.0);  // explicit conversions of literals
		cout << "posit<8,1> value of PI/2  = " << p << " " << color_print(p) << " " << pretty_print(p) << endl;
	}

	return (bSuccess ? EXIT_SUCCESS : EXIT_FAILURE);
}
catch (char const* msg) {
	std::cerr << msg << std::endl;
	return EXIT_FAILURE;
}
catch (...) {
	std::cerr << "Caught unknown exception" << std::endl;
	return EXIT_FAILURE;
}
