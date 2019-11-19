module scoring::categories::duplication

import IO;
import String;
import Set;
import List;
import Map;
import util::Math;

import scoring::ranks;


// These bounds are taken from page 36 of the SIG model report
tuple[int lower, int upper] PLUSPLUS_BOUNDS 	= <0, 3>;
tuple[int lower, int upper] PLUS_BOUNDS 		= <3, 5>;
tuple[int lower, int upper] NEUTRAL_BOUNDS 		= <5, 10>;
tuple[int lower, int upper] MINUS_BOUNDS 		= <10, 20>;

@doc{
	Calulates the rank level of this metric.

	Parameters:
	- int percentageDuplication: Percentage of duplication in a project
}
Rank calculateDuplicationRank(int percentageDuplication) {
	if (percentageDuplication < PLUSPLUS_BOUNDS.lower) {
		return Rank::\tbd();
	} else if (percentageDuplication >= PLUSPLUS_BOUNDS.lower && percentageDuplication < PLUSPLUS_BOUNDS.upper) {
		return \plusplus();
	} else if (percentageDuplication >= PLUS_BOUNDS.lower && percentageDuplication < PLUS_BOUNDS.upper) {
		return \plus();
	} else if (percentageDuplication >= NEUTRAL_BOUNDS.lower && percentageDuplication < NEUTRAL_BOUNDS.upper) {
		return \neutral();
	} else if (percentageDuplication >= MINUS_BOUNDS.lower && percentageDuplication < MINUS_BOUNDS.upper) {
		return \minus();
	} else {
		return \minusminus();
	}
}


/* TESTS */

test bool test_calculateDuplicationRank() {
	if (calculateDuplicationRank(0) != \plusplus()) return false;
	if (calculateDuplicationRank(-1) != Rank::\tbd()) return false;
	if (calculateDuplicationRank(500) != \minusminus()) return false;
	return true;
}
