module scoring::categories::unitcomplexity

import IO;
import String;
import Set;
import List;
import Map;
import util::Math;

// These bounds are taken from page 35 of the SIG model report
tuple[int moderate, int high, int veryHigh] PLUSPLUS_BOUNDS 	= <25, 0, 0>;
tuple[int moderate, int high, int veryHigh] PLUS_BOUNDS 		= <30, 5, 0>;
tuple[int moderate, int high, int veryHigh] NEUTRAL_BOUNDS 		= <40, 10, 0>;
tuple[int moderate, int high, int veryHigh] MINUS_BOUNDS 		= <50, 15, 5>;

@doc{
	Parameters:
	- int volume: Lines of code (LOC)
}
tuple[tuple [int, int, int], Rank] calculateUnitComplexityRank (tuple[int moderate, int high, int veryHigh] complexity) {
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