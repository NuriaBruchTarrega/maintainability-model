module metrics::categories::volume

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


int calculateVolume(map[loc locations, list[str] lines] files) {
	int volume = 0;
	for (lines <- files.lines) {
		for (line <- lines, !isBlank(line), !isComment(line)) {
			volume += 1;
		}
	}
	return volume;
}


/* TESTS */

test bool test_calculateVolume() {
	loc location = |project://sig-maintainability-model/testing/Example.java|;
	Files files = (location: readFileLines(location));
	return calculateVolume(files) == 28;
}
