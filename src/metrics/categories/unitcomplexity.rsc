module metrics::categories::unitcomplexity

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

import metrics::categories::unitsize;
import metrics::utility;
import utility;


@doc{
	Calculates the Unit Complexities of a list of ASTs.

	Parameters:
	- list[Declaration] ast: A list of ASTs
	
	Return list[tuple[loc, int, int]]: A list of tuples of unit locations, their LOC, and CC.
}
list[tuple[loc, int, int]] calculateUnitComplexities(list[Declaration] ast) {	
	list[tuple[loc, int, int]] unitComplexities = [];
	visit(ast) {
		case method: \method(_, _, _, _, Statement impl): {
			int linesOfCode = size(retrieveMethodLines(method.src));
			int cyclomaticComplexity = calculateCyclomaticComplexityOfSingleUnit(impl);
			unitComplexities += <method.src, linesOfCode, cyclomaticComplexity>;
		}
	}
	return unitComplexities;
}

@doc{
	Calculates the cyclomatic complexity (CC) of a unit (i.e. method).

	Parameters:
	- Statement unit: A unit (i.e. method) of the source code
	
	Return int: The calculated cyclomatic complexity (CC)
	
	Author: Davy Landman
	
	See: https://stackoverflow.com/a/40069656
}
int calculateCyclomaticComplexityOfSingleUnit(Statement unit) {
    int cc = 1;
    visit (unit) {
        case \if(_,_): cc += 1;
        case \if(_,_,_): cc += 1;
        case \case(_): cc += 1;
        case \do(_,_): cc += 1;
        case \while(_,_): cc += 1;
        case \for(_,_,_): cc += 1;
        case \for(_,_,_,_): cc += 1;
        case \foreach(_,_,_): cc += 1;
        case \catch(_,_): cc += 1;
        case \conditional(_,_,_): cc += 1;
        case \infix(_,"&&",_): cc += 1;
        case \infix(_,"||",_): cc += 1;
    }
    return cc;
}


/* TESTS */

test bool test_calculateUnitComplexities() {
	ast = createAstFromFile(|project://sig-maintainability-model/testing/Example.java|, true);
	list[tuple[loc, int, int]] unitComplexities = calculateUnitComplexities([ast]);
	if (unitComplexities[0][2] != 1) return false;
	if (unitComplexities[1][2] != 1) return false;
	if (unitComplexities[2][2] != 2) return false;
	if (unitComplexities[3][2] != 1) return false;
	return true;
}
