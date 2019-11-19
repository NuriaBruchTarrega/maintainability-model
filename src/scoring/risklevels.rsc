module scoring::risklevels

import IO;
import String;
import Set;
import List;
import Map;
import util::Math;


data RiskLevel
    = \simple()
    | \moderate()
    | \high()
    | \veryhigh()
    | \tbd()
    ;
