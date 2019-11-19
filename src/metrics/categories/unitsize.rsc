module metrics::categories::unitsize

import IO;
import String;
import Set;
import List;
import Map;
import util::Math;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import utility;
import metrics::utility;


@doc{
	Calculates the Unit Sizes of a list of ASTs.

	Parameters:
	- list[Declaration] ast: A list of ASTs
	
	Return list[tuple[loc, int]]: A list of tuples of unit locations and their LOC.
}
list[tuple[loc, int]] calculateUnitSizes(list[Declaration] ast) {
	list[tuple[loc, int]] unitSizes = [];
	visit(ast) {
		case method: \method(_, _, _, _, Statement impl): {
			int linesOfCode = size(retrieveMethodLines(method.src));
			unitSizes += <method.src, linesOfCode>;
		}
	}
	return unitSizes;
}


/* TESTS */

test bool test_calculateUnitSizes() {
	ast = createAstFromFile(|project://sig-maintainability-model/testing/Example.java|, true);
	list[tuple[loc, int]] unitSizes = calculateUnitSizes([ast]);
	if (unitSizes[0][1] != 3) return false;
	if (unitSizes[1][1] != 3) return false;
	if (unitSizes[2][1] != 10) return false;
	if (unitSizes[3][1] != 9) return false;
	return true;
}
