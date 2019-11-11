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
