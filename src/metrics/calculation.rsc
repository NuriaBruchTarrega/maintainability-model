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

import metrics::categories::docstringdensity;
import metrics::categories::duplication;
import metrics::categories::unitcomplexity;
import metrics::categories::unitsize;
import metrics::categories::volume;
import scoring::categories::docstringdensity;
import scoring::categories::duplication;
import scoring::categories::unitcomplexity;
import scoring::categories::unitsize;
import scoring::categories::volume;
import scoring::ranks;
import scoring::risklevels;
import utility;


tuple[int, Rank] calculateVolumeMetric(map[loc, list[str]] files) {
	int volume = calculateVolume(files);
	Rank rank = calculateVolumeRank(volume);
	return <volume, rank>;
}

tuple[tuple[int, int, int], Rank] calculateUnitComplexityMetric(list[Declaration] ast, int projectVolume) {
	list[tuple[loc, int, int]] unitComplexities = calculateUnitComplexities(ast);
	
	map[RiskLevel risks, int _] riskLevelLineOfCodeAmount = ();
	for (tuple[loc location, int linesOfCode, int cyclomaticComplexity] unit <- unitComplexities) {
		RiskLevel riskLevel = calculateUnitComplexityRisk(unit.cyclomaticComplexity);
		riskLevelLineOfCodeAmount[riskLevel] ? 0 += unit.linesOfCode;
	}
		
	map[RiskLevel risks, int percentages] riskPercentages = (risk : percent(riskLevelLineOfCodeAmount[risk], projectVolume) | risk <- riskLevelLineOfCodeAmount.risks);
	tuple[int, int, int] unitSizeRisks = <riskPercentages[\moderate()]?0, riskPercentages[\high()]?0, riskPercentages[\veryhigh()]?0>;
	
	return calculateUnitComplexityRank(unitSizeRisks);
}

tuple[tuple[int, int, int], Rank] calculateUnitSizeMetric(list[Declaration] ast) {
	list[tuple[loc, int]] unitSizes = calculateUnitSizes(ast);
	int amountOfUnits = size(unitSizes);
	
	list[RiskLevel] unitSizeRiskLevels = [calculateUnitSizeRisk(unitSize) | <_, unitSize> <- unitSizes];
	map[RiskLevel risks, int occurrences] riskDistribution = distribution(unitSizeRiskLevels);
	map[RiskLevel risks, int percentages] riskPercentages = (risk : percent(riskDistribution[risk], amountOfUnits) | risk <- riskDistribution.risks);
	
	tuple[int, int, int] unitSizeRisks = <riskPercentages[\moderate()]?0, riskPercentages[\high()]?0, riskPercentages[\veryhigh()]?0>;
	
	return calculateUnitSizeRank(unitSizeRisks);
}

tuple[int, Rank] calculateDocstringDensityMetric(list[Declaration] ast) {
	int density = calculateDocstringDensity(ast);
	Rank rank = calculateDocstringDensityRank(density);
	return <density, rank>;
}
