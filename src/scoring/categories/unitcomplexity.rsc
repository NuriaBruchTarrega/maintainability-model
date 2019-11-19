module scoring::categories::unitcomplexity

import IO;
import String;
import Set;
import List;
import Map;
import util::Math;

import scoring::ranks;
import scoring::risklevels;


// These bounds are taken from page 35 of the SIG model report
tuple[int moderate, int high, int veryHigh] PLUSPLUS_BOUNDS 	= <25, 0, 0>;
tuple[int moderate, int high, int veryHigh] PLUS_BOUNDS 		= <30, 5, 0>;
tuple[int moderate, int high, int veryHigh] NEUTRAL_BOUNDS 		= <40, 10, 0>;
tuple[int moderate, int high, int veryHigh] MINUS_BOUNDS 		= <50, 15, 5>;

@doc{
	Parameters:
	- tuple[int moderate, int high, int veryHigh] complexity: Percentage of LOC with moderate, high and very high risk levels.
}
tuple[tuple[int, int, int], Rank] calculateUnitComplexityRank(tuple[int moderate, int high, int veryHigh] complexity) {
	if (complexity.moderate > MINUS_BOUNDS.moderate || complexity.high > MINUS_BOUNDS.high || complexity.veryHigh > MINUS_BOUNDS.veryHigh) {
		return <complexity, \minusminus()>;
	} else if (complexity.moderate > NEUTRAL_BOUNDS.moderate || complexity.high > NEUTRAL_BOUNDS.high || complexity.veryHigh > NEUTRAL_BOUNDS.veryHigh) {
		return <complexity, \minus()>;
	} else if (complexity.moderate > PLUS_BOUNDS.moderate || complexity.high > PLUS_BOUNDS.high || complexity.veryHigh > PLUS_BOUNDS.veryHigh) {
		return <complexity, \neutral()>;
	} else if (complexity.moderate > PLUSPLUS_BOUNDS.moderate || complexity.high > PLUSPLUS_BOUNDS.high || complexity.veryHigh > PLUSPLUS_BOUNDS.veryHigh) {
		return <complexity, \plus()>;
	} else {
		return <complexity, \plusplus()>;
	}
}

// These bounds are taken from page 35 of the SIG model report
tuple[int lower, int upper] SIMPLE_BOUNDS 	= <1, 10>;
tuple[int lower, int upper] MODERATE_BOUNDS = <11, 20>;
tuple[int lower, int upper] HIGH_BOUNDS 	= <21, 50>;

@doc{ 
	Parameters:
	- int cyclomaticComplexity: Cyclomatic complexity (CC) of the unit
}
RiskLevel calculateUnitComplexityRisk(int cyclomaticComplexity) {
	if (cyclomaticComplexity < SIMPLE_BOUNDS.lower) {
		return RiskLevel::\tbd();
	} else if (cyclomaticComplexity >= SIMPLE_BOUNDS.lower && cyclomaticComplexity <= SIMPLE_BOUNDS.upper) {
		return \simple();
	} else if (cyclomaticComplexity >= MODERATE_BOUNDS.lower && cyclomaticComplexity <= MODERATE_BOUNDS.upper) {
		return \moderate();
	} else if (cyclomaticComplexity >= HIGH_BOUNDS.lower && cyclomaticComplexity <= HIGH_BOUNDS.upper) {
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
