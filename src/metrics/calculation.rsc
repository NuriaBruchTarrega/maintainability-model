module metrics::calculation

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

import metrics::categories::duplication;
import metrics::categories::unitcomplexity;
import metrics::categories::unitsize;
import metrics::categories::volume;
import scoring::categories::duplication;
import scoring::categories::unitcomplexity;
import scoring::categories::unitsize;
import scoring::categories::volume;
import scoring::ranks;


tuple[int, Rank] calculateVolumeMetric(map[loc, list[str]] files) {
	int volume = calculateVolume(files);
	Rank rank = calculateVolumeRank(volume);
	return <volume, rank>;
}

void calculateUnitComplexityMetric(map[loc locations, list[str] lines] files) {
	list[tuple[str, int, int]] unitComplexities = calculateUnitComplexities(files);
	//tuple[int, int, int] complexities = calculateTotalUnitComplexity(unitComplexities);
	//Rank rank = calculateUnitComplexityRank(complexities);
	//return <complexities, rank>;
}
