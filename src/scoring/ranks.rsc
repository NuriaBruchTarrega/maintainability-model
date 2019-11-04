module scoring::ranks

import IO;
import String;
import Set;
import List;
import Map;
import util::Math;


data Rank
    = \plusplus()
    | \plus()
    | \neutral()
    | \minus()
    | \minusminus()
    | \tbd()
    ;

Rank calculateAverageRank(list[Rank] ranks) {
	list[int] rankValues = [];
	for (rank <- ranks) {
		switch(rank) {
			case \plusplus(): 	rankValues += 2;
			case \plus(): 		rankValues += 1;
			case \neutral(): 	rankValues += 0;
			case \minus(): 		rankValues += -1;
			case \minusminus(): rankValues += -2;
		}
	}
	int averageRank = round(sum(rankValues) / size(rankValues));
	
	switch(averageRank) {
		case 2: 	return \plusplus();
		case 1: 	return \plus();
		case 0: 	return \neutral();
		case -1:	return \minus();
		case -2:	return \minusminus();
	}
}

str convertRankToLiteral(Rank rank) {
	switch(rank) {
		case \plusplus(): 	return "++";
		case \plus(): 		return "+";
		case \neutral(): 	return "o";
		case \minus(): 		return "-";
		case \minusminus(): return "--";
		case \tbd(): 		return "TBD";
	}
}
