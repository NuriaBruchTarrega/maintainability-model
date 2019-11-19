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


set[loc] findDuplicates(Files files) {
	map[loc, str] lines = constructLines(files);
	return calculateDuplicatedBlocks(lines);
}

map[loc, str] constructLines(map[loc locations, list[str] lines] files) {
	map[loc, str] lineMap = ();

	for (loc location <- files.locations) {
		list[str] lines = files[location];
		
		int offset = 0;
		int lineIndex = 1;
		for (str line <- lines) {
			if (isComment(line)) {
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
			key = lineLocation;
			
			lineMap[key] = line;
			
			offset += lineLocation.length + 1;
			lineIndex += 1;
		}
	}
	
	return lineMap;
}

set[loc] calculateDuplicatedBlocks(map[loc, str] lines) {
	set[loc] duplicatedLinesLocation = {};
	inverse = invert(lines);
	map[str, set[loc]] allRepeatedLines = (bucket : inverse[bucket] | bucket <- inverse, size(inverse[bucket]) > 1);
	map[str, set[tuple[loc, str]]] linesByFile = generateLinesByFile(allRepeatedLines);
	
	for (lineContent <- allRepeatedLines, !isCommonLineOfCode(lineContent)) {
		set[loc] linesInBucket = allRepeatedLines[lineContent];
		
		while(size(linesInBucket) > 1) {
			tuple[loc line, set[loc] matches] takeOne = takeOneFrom(linesInBucket);
			loc currentLine = takeOne.line;
			linesInBucket = takeOne.matches;
			
			for (loc matchLine <- linesInBucket) {				
				// Get all duplicated lines previous and posterior
				set[loc] matchedPrevious = matchConsecutive(true, currentLine, matchLine, linesByFile[getPathFile(currentLine)], allRepeatedLines);
				set[loc] matchedPosterior = matchConsecutive(false, currentLine, matchLine, linesByFile[getPathFile(currentLine)], allRepeatedLines);
				
				// Check duplicated block size is greater or equal to 6
				int blockLOC = round(size(matchedPrevious)/2) + round(size(matchedPosterior)/2) + 1;
				if (blockLOC < 6) continue;
				
				//  Add duplicated blocks locations to set of duplicated locations
				duplicatedLinesLocation = duplicatedLinesLocation + matchedPrevious;
				duplicatedLinesLocation = duplicatedLinesLocation + matchedPosterior;
				duplicatedLinesLocation = duplicatedLinesLocation + {currentLine, matchLine};
			}
		}
	}
	
	return duplicatedLinesLocation;
}

map[str, set[tuple[loc, str]]] generateLinesByFile(map[str, set[loc]] buckets) {
	map[str, set[tuple[loc, str]]] linesByFile = ();
	
	for (str bucket <- buckets) {
		set[loc] linesInBucket = buckets[bucket];
		
		for (loc location <- linesInBucket) {
			if(getPathFile(location) in linesByFile) linesByFile[getPathFile(location)] += <location, bucket>;
			else linesByFile = linesByFile + (getPathFile(location):{<location, bucket>});
		}
	}
	return linesByFile;
}

set[loc] matchConsecutive(bool matchingPrevious, loc currentLine, loc match,  set[tuple[loc, str]] currentFileLines, map[str, set[loc]] allRepeatedLines) {
	set[loc] consecutiveLOCs = {};
	loc locationCurrent = currentLine;
	loc locationMatch = match;
	
	while (true) {
		// Find consecutives of both blocks
		tuple[loc location, str content] consecutive1 = findConsecutive(matchingPrevious, locationCurrent, currentFileLines);
		// The consecutive line does not exist, done
		if (consecutive1.location == locationCurrent) break;
		
		loc consecutive2Location = findMatchConsecutive(matchingPrevious, locationMatch, consecutive1.content, allRepeatedLines[consecutive1.content]);
		// If there is no consecutive line with the expected location and content, done
		if (consecutive2Location == locationMatch) break;
	
		// Update blocks location and block LOC
		if (consecutive1.content != "") consecutiveLOCs = consecutiveLOCs + {consecutive1.location, consecutive2Location};
		locationCurrent = consecutive1.location;
		locationMatch = consecutive2Location;
	}
	
	return consecutiveLOCs;
}

tuple[loc, str] findConsecutive(bool matchingPrevious, loc currentLoc, set[tuple[loc, str]] hashedLines) {
	str path = currentLoc.path;
	str file = currentLoc.file;
	
	// If it is matching previous line, use begin line
	// Otherwise, use end line
	int lineIndex;
	if (matchingPrevious) lineIndex = currentLoc.begin.line - 1;
	else lineIndex = currentLoc.end.line + 1;
	
	// Find consecutive line
	for (tuple[loc location, str _] line <- hashedLines) {
		if (line.location.begin.line == lineIndex) return line;
	}
	
	return <currentLoc, "">;
}

loc findMatchConsecutive(bool matchingPrevious, loc locationMatch, str content, set[loc] locationOfMatchingLines) {
	str path = locationMatch.path;
	str file = locationMatch.file;
	
	int lineIndex;
	if (matchingPrevious) lineIndex = locationMatch.begin.line - 1;
	else lineIndex = locationMatch.end.line + 1;
	
	for (location <- locationOfMatchingLines) {
		if (location.path != path) continue;
		if (location.file != file) continue;
		if (location.begin.line == lineIndex) return location;
	}
	
	return locationMatch;
}


/* TESTS */

test bool test_findDuplicates() {
	loc location = |project://sig-maintainability-model/testing/Example.java|;
	Files files = (location: readFileLines(location));
	return size(findDuplicates(files)) == 1;
}
