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


set[str] commonLinesOfCode = {"}", "return", "try{", "try {", "break;", "}else{", "} else {", "default:", "throw", "continue;"};

@doc{
	A predicate that tests if a line is blank.

	Parameters:
	- str line: The line
}
bool isBlank(str line) {
	trimmed = trim(line);
	return size(trimmed) == 0;
}

@doc{
	A predicate that tests if a line is a Java comment.

	Parameters:
	- str line: The line
	
	TODO:
	- Extend this with proper multiline comment detection
}
bool isComment(str line) {
	trimmed = trim(line);
	return startsWith(trimmed, "//") || startsWith(trimmed, "/*") || startsWith(trimmed, "*");
}

bool isCommonLineOfCode(str line) {
	if (isEmpty(line)) return true;
	
	for (commonLineOfCode <- commonLinesOfCode) {
		if (contains(line, commonLineOfCode)) return true;
	}
	return false;
}

@doc{
	Retrieves the lines of a Java method that are not blank or comments.

	Parameters:
	- loc methodLocation: A location to a "java+method"
}
list[str] retrieveMethodLines(loc methodLocation) {
	return [line | line <- readFileLines(methodLocation), !isBlank(line), !isComment(line)];
}

@doc{
	Retrieves the raw path out of a file location as a string.

	Parameters:
	- loc location: A local file location
}
str getPathFile(loc location) {
	return location.path + location.file;
}


/* TESTS */

test bool test_isBlank() {
	if (isBlank("") != true) return false;
	if (isBlank(" ") != true) return false;
	if (isBlank("TEST") != false) return false;
	if (isBlank("\t") != true) return false;
	if (isBlank("\n") != true) return false;
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

test bool test_getPathFile() {
	location = |project://sig-maintainability-model/testing/Example.java|;
	return getPathFile(location) == "/testing/Example.javaExample.java";
}
