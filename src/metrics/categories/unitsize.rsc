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


list[tuple[loc, int]] calculateUnitSizes(list[Declaration] ast) {
	list[tuple[loc, int]] unitSizes = [];
	visit(ast) {
		// TODO: Verify if abstract methods count as one line
		case method: \method(_, _, _, _, Statement impl): {
			int linesOfCode = size(retrieveMethodLines(method.src));
			unitSizes += <method.src, linesOfCode>;
		}
	}
	return unitSizes;
}
