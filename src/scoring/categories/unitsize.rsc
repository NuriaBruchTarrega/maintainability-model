module scoring::categories::unitsize

import IO;
import String;
import Set;
import List;
import Map;
import util::Math;

import scoring::ranks;
import scoring::risklevels;


// These bounds are taken from https://docs.sonarqube.org/display/SONARQUBE45/SIG+Maintainability+Model+Plugin
tuple[int moderate, int high, int veryHigh] PLUSPLUS_BOUNDS 	= <25, 0, 0>;
tuple[int moderate, int high, int veryHigh] PLUS_BOUNDS 		= <30, 5, 0>;
tuple[int moderate, int high, int veryHigh] NEUTRAL_BOUNDS 		= <40, 10, 0>;
tuple[int moderate, int high, int veryHigh] MINUS_BOUNDS 		= <50, 15, 5>;

@doc{
	Calulates the rank level of this metric.
	
	Parameters:
	- tuple[int moderate, int high, int veryHigh] unitSizeRisks: Percentage of LOC with moderate, high and very high risk levels.
}
tuple[tuple[int, int, int], Rank] calculateUnitSizeRank (tuple[int moderate, int high, int veryHigh] unitSizeRisks) {
	if (unitSizeRisks.moderate >= MINUS_BOUNDS.moderate || unitSizeRisks.high >= MINUS_BOUNDS.high || unitSizeRisks.veryHigh >= MINUS_BOUNDS.veryHigh) {
		return <unitSizeRisks, \minusminus()>;
	} else if (unitSizeRisks.moderate >= NEUTRAL_BOUNDS.moderate || unitSizeRisks.high >= NEUTRAL_BOUNDS.high || unitSizeRisks.veryHigh >= NEUTRAL_BOUNDS.veryHigh) {
		return <unitSizeRisks, \minus()>;
	} else if (unitSizeRisks.moderate >= PLUS_BOUNDS.moderate || unitSizeRisks.high >= PLUS_BOUNDS.high || unitSizeRisks.veryHigh >= PLUS_BOUNDS.veryHigh) {
		return <unitSizeRisks, \neutral()>;
	} else if (unitSizeRisks.moderate >= PLUSPLUS_BOUNDS.moderate || unitSizeRisks.high >= PLUSPLUS_BOUNDS.high || unitSizeRisks.veryHigh >= PLUSPLUS_BOUNDS.veryHigh) {
		return <unitSizeRisks, \plus()>;
	} else {
		return <unitSizeRisks, \plusplus()>;
	}
}

// These bounds are taken from https://docs.sonarqube.org/display/SONARQUBE45/SIG+Maintainability+Model+Plugin
tuple[int lower, int upper] SIMPLE_BOUNDS 	= <0, 10>;
tuple[int lower, int upper] MODERATE_BOUNDS = <10, 50>;
tuple[int lower, int upper] HIGH_BOUNDS 	= <50, 100>;

@doc{
	Calulates the risk level of this metric.

	Parameters:
	- int unitSize: Lines of code (LOC) of the unit
}
RiskLevel calculateUnitSizeRisk(int unitSize) {
	if (unitSize > SIMPLE_BOUNDS.lower && unitSize <= SIMPLE_BOUNDS.upper) {
		return \simple();
	} else if (unitSize > MODERATE_BOUNDS.lower && unitSize <= MODERATE_BOUNDS.upper) {
		return \moderate();
	} else if (unitSize > HIGH_BOUNDS.lower && unitSize <= HIGH_BOUNDS.upper) {
		return \high();
	} else {
		return \veryhigh();
	}
}


/* TESTS */

test bool test_calculateUnitComplexityRisk() {
	if (calculateUnitComplexityRisk(-1) != RiskLevel::\tbd()) return false;
	if (calculateUnitComplexityRisk(21) != \high()) return false;
	if (calculateUnitComplexityRisk(500) != \veryhigh()) return false;
	return true;
}
