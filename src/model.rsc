module model

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

import metrics::calculation;
import metrics::categories::unitsize;
import scoring::categories::duplication;
import scoring::categories::unitcomplexity;
import scoring::categories::unitsize;
import scoring::categories::volume;
import scoring::ranks;
import utility;


// Constants
int SCORE_FILL_UP_AMOUNT = 10;
int RANK_FILL_UP_AMOUNT = 5;

// Example projects
loc smallsql = |project://smallsql0.21_src|;
loc hsqldb = |project://hsqldb-2.3.1|;
list[loc] projects = [smallsql, hsqldb];

// Main functions
void calculate(list[loc] projectLocations) {
	println("\nSIG Maintainability Reports:\n");

	for (projectLocation <- projectLocations) {
		M3 projectModel = createM3Model(projectLocation);
		map[loc locations, list[str] lines] files = retrieveProjectFiles(projectModel);
		list[Declaration] ast = retrieveAst(projectModel);
		
		volume = calculateVolumeMetric(files);		
		unitComplexity = <"TBD", \tbd()>;
		duplication = <"TBD", \tbd()>;
		unitSize = calculateUnitSizeMetric(files);
		
		println("
			'******************************************
			'Project: <projectLocation.authority>
			'
			'----------------------------------------
			'| Category        | <fillUp("Score", SCORE_FILL_UP_AMOUNT)> | <fillUp("Rank", RANK_FILL_UP_AMOUNT)> |
			'|---------------------------------------
			'| Volume          | <fillUp(volume[0], SCORE_FILL_UP_AMOUNT)> | <fillUp(volume[1], RANK_FILL_UP_AMOUNT)> |
			'| Unit Complexity | <fillUp(unitComplexity[0], SCORE_FILL_UP_AMOUNT)> | <fillUp(unitComplexity[1], RANK_FILL_UP_AMOUNT)> |
			'| Duplication     | <fillUp(duplication[0], SCORE_FILL_UP_AMOUNT)> | <fillUp(duplication[1], RANK_FILL_UP_AMOUNT)> |
			'| Unit Size       | <fillUp(unitSize[0], SCORE_FILL_UP_AMOUNT)> | <fillUp(unitSize[1], RANK_FILL_UP_AMOUNT)> |
			'----------------------------------------
			'
			'Average Rank: <convertRankToLiteral(calculateAverageRank([volume[1], unitComplexity[1], duplication[1], unitSize[1]]))>
			'******************************************
		");
	}
}

void main() {
	calculate([smallsql]);
}
