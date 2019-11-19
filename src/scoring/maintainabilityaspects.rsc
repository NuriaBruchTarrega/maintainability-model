module scoring::maintainabilityaspects

import IO;
import String;
import Set;
import List;
import Map;
import util::Math;

import scoring::ranks;


data MaintainabilityAspect
    = \analysability()
    | \changeability()
    | \stability()
    | \testability()
    ;

str constructMaintainabilityAspectPrintOut(Rank volumeRank, Rank unitComplexityRank, Rank duplicationRank, Rank unitSizeRank) {
	map[MaintainabilityAspect aspects, Rank ranks] maintainabilityAspects = calculateAnalysabilityAspectRanks(volumeRank, unitComplexityRank, duplicationRank, unitSizeRank);
	maintainabilityAspectPrintOut = "";
	for (maintainabilityAspect <- maintainabilityAspects.aspects) {
		rank = maintainabilityAspects[maintainabilityAspect];
		maintainabilityAspectPrintOut += "<convertMaintainabilityAspectToLiteral(maintainabilityAspect)>: <convertRankToLiteral(rank)>\n";
	}
	return maintainabilityAspectPrintOut;
}

// The table of how the maintainability aspects are calculated is taken from page 34 of the SIG model report
map[MaintainabilityAspect, Rank] calculateAnalysabilityAspectRanks(Rank volumeRank, Rank unitComplexityRank, Rank duplicationRank, Rank unitSizeRank) {
	return (
		\analysability(): calculateAverageRank([volumeRank, duplicationRank, unitSizeRank]),
		\changeability(): calculateAverageRank([unitComplexityRank, duplicationRank]),
		\testability(): calculateAverageRank([unitComplexityRank, unitSizeRank])
	);
}

str convertMaintainabilityAspectToLiteral(MaintainabilityAspect maintainabilityAspect) {
	switch(maintainabilityAspect) {
		case \analysability():	return "Analysability";
		case \changeability():	return "Changeability";
		case \stability():		return "Stability";
		case \testability():	return "Testability";
		default:				return "N/A";
	}
}
