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

// The table of how the maintainability aspects are calculated is taken from page 34 of the SIG model report
set[tuple[MaintainabilityAspect, Rank]] calculateAnalysabilityAspectRanks(Rank volumeRank, Rank unitComplexityRank, Rank duplicationRank, Rank unitSizeRank) {
	analysabilityRank = <\analysability(), calculateAverageRank([volumeRank, duplicationRank, unitSizeRank])>;
	changeabilityRank = <\changeability(), calculateAverageRank([unitComplexityRank, duplicationRank])>;
	testabilityRank = <\testability(), calculateAverageRank([unitComplexityRank, unitSizeRank])>;
	return {analysabilityRank, changeabilityRank, testabilityRank};
}
