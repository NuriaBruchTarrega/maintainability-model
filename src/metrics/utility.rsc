module metrics::utility

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


set[str] commonLinesOfCode = {"}", "return;", "try{", "try {","return true;", "return false;", "break;", "}else{", "} else {", "default:", "", "throw", "import", "return null;"};

bool isBlank(str line) {
	trimmed = trim(line);
	return size(trimmed) == 0;
}

// TODO: Extend this with proper multiline comment detection
bool isComment(str line) {
	trimmed = trim(line);
	return startsWith(trimmed, "//") || startsWith(trimmed, "/*") || startsWith(trimmed, "*");
}

bool isCommonLineOfCode(str line) {
	for (commonLineOfCode <- commonLinesOfCode) {
		if (contains(commonLineOfCode, line)) return true;
	}
	return false;
}

list[str] retrieveMethodLines(loc methodLocation) {
	return [line | line <- readFileLines(methodLocation), !isBlank(line), !isComment(line)];
}

str getPathFile(loc location) {
	return location.path + location.file;
}


/* TESTS */

test bool test_isBlank() {
	if (isBlank("") != true) return false;
	if (isBlank(" ") != false) return false;
	if (isBlank("             ") != false) return false;
	if (isBlank("\t") != false) return false;
	if (isBlank("\n") != false) return false;
	return true;
}

test bool test_isComment() {
	if (isComment("// TEST") != true) return false;
	if (isComment(" TEST") != false) return false;
	if (isComment("TEST") != false) return false;
	if (isComment("/* TEST") != true) return false;
	if (isComment("/** TEST") != true) return false;
	if (isComment("* TEST") != true) return false;
	return true;
}
