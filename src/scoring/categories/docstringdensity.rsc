module scoring::categories::docstringdensity

import IO;
import String;
import Set;
import List;
import Map;
import util::Math;

import scoring::ranks;


// These bounds were obtained through a executed study of 10 large-scale Java projects
tuple[int lower, int upper] PLUSPLUS_BOUNDS 	= <42, 100>;
tuple[int lower, int upper] PLUS_BOUNDS 		= <31, 42>;
tuple[int lower, int upper] NEUTRAL_BOUNDS 		= <16, 31>;
tuple[int lower, int upper] MINUS_BOUNDS 		= <8, 16>;

@doc{
	Calulates the rank level of this metric.

	Parameters:
	- int densityPercentage: The percentage of units with a doc-string
}
Rank calculateDocstringDensityRank(int densityPercentage) {
	if (densityPercentage >= PLUSPLUS_BOUNDS.lower && densityPercentage < PLUSPLUS_BOUNDS.upper) {
		return \plusplus();
	} else if (densityPercentage >= PLUS_BOUNDS.lower && densityPercentage < PLUS_BOUNDS.upper) {
		return \plus();
	} else if (densityPercentage >= NEUTRAL_BOUNDS.lower && densityPercentage < NEUTRAL_BOUNDS.upper) {
		return \neutral();
	} else if (densityPercentage >= MINUS_BOUNDS.lower && densityPercentage < MINUS_BOUNDS.upper) {
		return \minus();
	} else {
		return \minusminus();
	}
}


/* TESTS */

test bool test_calculateDocstringDensityRank() {
	if (test_calculateDocstringDensityRank(0) != \minusminus()) return false;
	if (test_calculateDocstringDensityRank(-1) != \minusminus()) return false;
	if (test_calculateDocstringDensityRank(500) != \plusplus()) return false;
	return true;
}
