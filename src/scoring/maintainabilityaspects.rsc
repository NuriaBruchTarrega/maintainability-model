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

@doc{
	Constructs a multi-line print out regarding the maintainability aspects.

	Parameters:
	- Rank volumeRank: The calculated rank of the volume metric
	- Rank unitComplexityRank: The calculated rank of the unit complexity metric
	- Rank duplicationRank: The calculated rank of the duplication metric
	- Rank unitSizeRank: The calculated rank of the unit size metric
	
	Return: A string-based summary of the maintainability aspects
}
str constructMaintainabilityAspectPrintOut(Rank volumeRank, Rank unitComplexityRank, Rank duplicationRank, Rank unitSizeRank) {
	map[MaintainabilityAspect aspects, Rank ranks] maintainabilityAspects = calculateAnalysabilityAspectRanks(volumeRank, unitComplexityRank, duplicationRank, unitSizeRank);
	maintainabilityAspectPrintOut = "\n";
	for (maintainabilityAspect <- maintainabilityAspects.aspects) {
		rank = maintainabilityAspects[maintainabilityAspect];
		maintainabilityAspectPrintOut += "<convertMaintainabilityAspectToLiteral(maintainabilityAspect)>: <convertRankToLiteral(rank)>\n";
	}
	return maintainabilityAspectPrintOut;
}

@doc{
	Constructs a map of how the maintainability aspects scored.
	The table of how the maintainability aspects are calculated is taken from page 34 of the SIG model report.

	Parameters:
	- Rank volumeRank: The calculated rank of the volume metric
	- Rank unitComplexityRank: The calculated rank of the unit complexity metric
	- Rank duplicationRank: The calculated rank of the duplication metric
	- Rank unitSizeRank: The calculated rank of the unit size metric
	
	Return: A map of maintainability rank to rank level
}
map[MaintainabilityAspect, Rank] calculateAnalysabilityAspectRanks(Rank volumeRank, Rank unitComplexityRank, Rank duplicationRank, Rank unitSizeRank) {
	return (
		\analysability(): calculateAverageRank([volumeRank, duplicationRank, unitSizeRank]),
		\changeability(): calculateAverageRank([unitComplexityRank, duplicationRank]),
		\testability(): calculateAverageRank([unitComplexityRank, unitSizeRank])
	);
}

@doc{
	Converts a maintainability aspect type into a string representation.

	Parameters:
	- MaintainabilityAspect maintainabilityAspect: A constructed maintainability aspect type
	
	Return: The string literal of the passed maintainability aspect
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
