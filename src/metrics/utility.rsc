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


bool isBlank(str line) {
	trimmed = trim(line);
	return size(trimmed) == 0;
}

// TODO: Extend this with proper multiline comment detection
bool isComment(str line) {
	trimmed = trim(line);
	return startsWith(trimmed, "//") || startsWith(trimmed, "/*") || startsWith(trimmed, "*");
}
