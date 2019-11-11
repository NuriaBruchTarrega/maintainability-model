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

import metrics::utility;


list[tuple[loc, str, int]] calculateUnitSizes(map[loc locations, list[str] _] files) {
	list[tuple[loc, str, int]] units = [];
	for (location <- files.locations) {
		int lineIndex = 0;
		list[str] lines = files[location];
		for (line <- lines) {
			if (isMethodDeclarationLine(line)) {
				units += constructUnitTriple(location, lines, lineIndex);
			}
			lineIndex += 1;
		}
	}
}

tuple[loc, str, int] constructUnitTriple(loc location, list[str] lines, int lineIndex) {
	// TODO: Implement this!
}

bool isMethodDeclarationLine(str line) {
	if (isComment(line)) return false;

	int firstOpenParenthesisIndex = findFirst(line, "(");
	if (firstOpenParenthesisIndex == -1) return false;
	str lineBeforeFirstOpenParenthesis = substring(line, 0, firstOpenParenthesisIndex);
	list[str] partsBeforeFirstOpenParenthesis = [trim(part) | part <- split(" ", lineBeforeFirstOpenParenthesis), size(trim(part)) > 0];
	if (size(partsBeforeFirstOpenParenthesis) < 2) return false;
	
	for (str part <- partsBeforeFirstOpenParenthesis) {
		if (part == "//") return false;
		if (part == "else") return false;
		if (part == "case") return false;
		if (part == "new") return false;
		if (part == "return") return false;
		if (part == "throw") return false;
		if (contains(part, ".")) return false;
		if (contains(part, "{")) return false;
		if (contains(part, "}")) return false;
		if (contains(part, "=")) return false;
		if (contains(part, "+")) return false;
	}
	
	return true;
}
