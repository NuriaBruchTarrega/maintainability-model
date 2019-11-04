module model

import IO;
import String;
import Set;
import List;
import Map;
import Type;
import util::Math;
import tests::stats;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import calculation::categories::volume;
import scoring::ranks;
import scoring::categories::duplication;
import scoring::categories::unitcomplexity;
import scoring::categories::unitsize;
import scoring::categories::volume;
import utility;


// Constants
int SCORE_FILL_UP_AMOUNT = 10;
int RANK_FILL_UP_AMOUNT = 5;

// Example projects
loc smallsql = |project://smallsql0.21_src|;
loc hsqldb = |project://hsqldb-2.3.1|;
list[loc] projects = [smallsql, hsqldb];

// Category calculation functions
tuple[str, str] calculateVolumeMetric(map[loc, list[str]] files) {
	int volume = calculateVolume(files);
	Rank rank = calculateVolumeRank(volume);
	return <toString(volume), convertRankToLiteral(rank)>;
}

// Main functions
void calculate(list[loc] projectLocations) {
	println("\nSIG Maintainability Reports:\n");

	for (projectLocation <- projectLocations) {
		M3 projectModel = createM3Model(projectLocation);
		map[loc locations, list[str] lines] files = retrieveProjectFiles(projectModel);
		list[Declaration] ast = retrieveAst(projectModel);
		
		duplication = <"N/A", "N/A">;
		unitComplexity = <"N/A", "N/A">;
		unitSize = <"N/A", "N/A">;
		volume = calculateVolumeMetric(files);
		
		println("
			'******************************************
			'Project: <projectLocation.authority>
			'
			'----------------------------------------
			'| Category        | <fillUp("Score", 10)> | <fillUp("Rank", 5)> |
			'|---------------------------------------
			'| Duplication     | <fillUp(duplication[0], SCORE_FILL_UP_AMOUNT)> | <fillUp(duplication[1], RANK_FILL_UP_AMOUNT)> |
			'| Unit Complexity | <fillUp(unitComplexity[0], SCORE_FILL_UP_AMOUNT)> | <fillUp(unitComplexity[1], RANK_FILL_UP_AMOUNT)> |
			'| Unit Size       | <fillUp(unitSize[0], SCORE_FILL_UP_AMOUNT)> | <fillUp(unitSize[1], RANK_FILL_UP_AMOUNT)> |
			'| Volume          | <fillUp(volume[0], SCORE_FILL_UP_AMOUNT)> | <fillUp(volume[1], RANK_FILL_UP_AMOUNT)> |
			'----------------------------------------
			'
			'******************************************
		");
	}
}

void main() {
	calculate(projects);
}
