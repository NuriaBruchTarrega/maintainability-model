module scoring::volume

import scoring::ranks::Rank;


tuple[int lower, int upper] PLUSPLUS_BOUNDS 	= <0, 66000>;
tuple[int lower, int upper] PLUS_BOUNDS 		= <66000, 246000>;
tuple[int lower, int upper] NEUTRAL_BOUNDS 		= <246000, 665000>;
tuple[int lower, int upper] MINUS_BOUNDS 		= <665000, 1310000>;

@doc{
	Parameters:
	- int vol: Lines of code (LOC)
}
Rank calculateVolumeRank(int vol) {
	if (vol >= PLUSPLUS_BOUNDS.lower && vol < PLUSPLUS_BOUNDS.upper) {
		return \plusplus();
	} else if (vol >= PLUS_BOUNDS.lower && vol < PLUS_BOUNDS.upper) {
		return \plus();
	} else if (vol >= NEUTRAL_BOUNDS.lower && vol < NEUTRAL_BOUNDS.upper) {
		return \neutral();
	} else if (vol >= MINUS_BOUNDS.lower && vol < MINUS_BOUNDS.upper) {
		return \minus();
	} else {
		return \minusminus();
	}
}
