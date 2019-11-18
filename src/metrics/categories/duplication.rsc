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
import metrics::utility;
import utility;


void findDuplicates(Files files) {
	map[tuple[loc, str], str] lineHashes = calculateLineHashes(files);
}

map[tuple[loc, str], str] calculateLineHashes(map[loc locations, list[str] _] files) {
	map[tuple[loc, str], str] linesHashes = ();

	for (loc location <- files.locations) {
		list[str] lines = files[location];
		
		int offset = 0;
		int lineIndex = 1;
		for (str line <- lines) {
			if (isBlank(line) || isComment(line)) {
				offset += size(line) + 2;
				lineIndex += 1;
				continue;
			}
		
			lineLocation = location(0, 0, <0, 0>, <0, 0>);
			lineLocation.offset = offset;
			lineLocation.length = size(line) + 1;
			lineLocation.end.line = lineIndex;
			lineLocation.begin.line = lineIndex;
			lineLocation.end.column = lineLocation.length;
			lineLocation.begin.column = 0;
			
			line = trim(line);
			key = <lineLocation, line>;
			md5Hash = hashMD5(line);
			
			linesHashes[key] = md5Hash;
			
			offset += lineLocation.length + 1;
			lineIndex += 1;
		}
	}
	
	return linesHashes;
}

int calculateDuplicationPercentage() {
	return 0;
}
