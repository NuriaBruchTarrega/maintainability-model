module scoring::ranks

data Rank
    = \plusplus()
    | \plus()
    | \neutral()
    | \minus()
    | \minusminus()
    ;

str convertRankToLiteral(Rank rank) {
	switch(rank) {
		case \plusplus(): 	return "++";
		case \plus(): 		return "+";
		case \neutral(): 	return "o";
		case \minus(): 		return "-";
		case \minusminus(): return "--";
	}
}
