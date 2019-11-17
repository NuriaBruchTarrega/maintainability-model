module metrics::categories::duplication

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


void findDuplicates(Files files) {
	map[loc, str] lineHashes = calculateLineHashes(files);
}

map[loc, str] calculateLineHashes(Files files) {
	
}
