module model

import IO;
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

import calculation::helpers;
import calculation::categories::volume;
import scoring::ranks;
import scoring::categories::duplication;
import scoring::categories::unitcomplexity;
import scoring::categories::unitsize;
import scoring::categories::volume;


// Example projects
loc smallsql = |project://smallsql0.21_src|;
loc hsqldb = |project://hsqldb-2.3.1|;

// Category calculation functions
tuple[int, str] calculatVolumeMetric(map[loc, list[str]] files) {
	int volume = calculateVolume(files);
	Rank rank = calculateVolumeRank(volume);
	return <volume, convertRankToLiteral(rank)>;
}

// Main function
void calculate(list[loc] projectLocations) {
	for (projectLocation <- projectLocations) {
		M3 projectModel = createM3Model(projectLocation);
		map[loc locations, list[str] lines] files = retrieveProjectFiles(projectModel);
		list[Declaration] ast = retrieveAst(projectModel);
		
		println("******************************");
		println("Project: <projectLocation.authority>");
		// println("Duplication Rank: <>");
		// println("Unit Complexity Rank: <>");
		// println("Unit Size: <>");
		println("Volume Rank: <calculatVolumeMetric(files)>");
		println("******************************\n");
	}
}
