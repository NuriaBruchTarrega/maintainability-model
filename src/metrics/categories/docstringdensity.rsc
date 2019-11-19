module metrics::categories::docstringdensity

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

import aliases;
import metrics::utility;
import utility;


str JAVADOC_STARTING_SEQUENCE = "/**";

int calculateDocstringDensity(list[Declaration] ast) {
	int docUnitAmount = 0;
	int totalUnitAmount = 0;
	
	visit(ast) {
		case method: \method(_, _, _, _, _): {
			list[str] unitBody = readFileLines(method.src);
			str firstLineOfUnitBody = head(unitBody);
			if (startsWith(firstLineOfUnitBody, JAVADOC_STARTING_SEQUENCE)) docUnitAmount += 1;
			totalUnitAmount += 1;
		}
	}
	
	return percent(docUnitAmount, totalUnitAmount);
}


/* TESTS */

test bool test_calculateDocstringDensity() {
	ast = createAstFromFile(|project://sig-maintainability-model/testing/Example.java|, true);
	return calculateDocstringDensity([ast]) == 25;
}
