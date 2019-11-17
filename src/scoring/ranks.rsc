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

@doc{
	Parameters:
	- Rank rank: A constructed rank type
}
Rank calculateAverageRank(list[Rank] ranks) {
	list[int] rankValues = [];
	for (rank <- ranks) {
		switch(rank) {
			case \plusplus(): 	rankValues += 5;
			case \plus(): 		rankValues += 4;
			case \neutral(): 	rankValues += 3;
			case \minus(): 		rankValues += 2;
			case \minusminus(): rankValues += 1;
		}
	}
	int averageRank = round(sum(rankValues) / size(rankValues));
	
	switch(averageRank) {
		case 5: 	return \plusplus();
		case 4: 	return \plus();
		case 3: 	return \neutral();
		case 2:		return \minus();
		case 1:		return \minusminus();
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
