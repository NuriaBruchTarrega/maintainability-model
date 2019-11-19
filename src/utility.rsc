module utility

import IO;
import String;
import Set;
import List;
import Map;
import Tuple;
import util::Math;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import scoring::ranks;


@doc{
	Creates an M3 model of an Eclipse project.

	Parameters:
	- loc projectLocation: A location to an Eclipse project
}
M3 createM3Model(loc projectLocation) {
	return createM3FromEclipseProject(projectLocation);
}

@doc{
	Retrieves the actual files as location from an M3 model.

	Parameters:
	- M3 model: An M3 model
}
map[loc, list[str]] retrieveProjectFiles(M3 model) {
	map[loc, list[str]] files = ();
	for (m <- model.containment, m[0].scheme == "java+compilationUnit") {
		files[m[0]] = readFileLines(m[0]);
	}
	return files;
}

@doc{
	Retrieves the ASTs from an M3 model.

	Parameters:
	- M3 model: An M3 model
}
list[Declaration] retrieveAst(M3 model) {
	list[Declaration] ast = [];
	for (m <- model.containment, m[0].scheme == "java+compilationUnit") {
		ast += createAstFromFile(m[0], true);
	}
	return ast;
}

@doc{
	Fills up a passed string with spaces until the specified length.

	Parameters:
	- str string: The original string
	- int amount: The amount of spaces that the total length should be
}
str fillUp(str string, int amount) {
	iterations = amount - size(string);
	if (iterations <= 0) return string;
	for (_ <- [0..iterations]) string += " ";
	return string;
}

@doc{
	The overloaded version of `str fillUp(str string, int amount)` with different parameters.
}
str fillUp(int score, int amount) {
	return fillUp(toString(score), amount);
}

@doc{
	The overloaded version of `str fillUp(str string, int amount)` with different parameters.
}
str fillUp(tuple[int moderate, int high, int veryhigh] risks, int amount) {
	return fillUp("<risks.moderate>% - <risks.high>% - <risks.veryhigh>%", amount);
}

@doc{
	The overloaded version of `str fillUp(str string, int amount)` with different parameters.
}
str fillUp(Rank rank, int amount) {
	return fillUp(convertRankToLiteral(rank), amount);
}

@doc{
	Joins a list of strings together into a single one without a delimiter.

	Parameters:
	- list[str] listOfStrings: A list of strings to be joined
}
str joinString(list[str] listOfStrings) {
	str joined = "";
	for (item <- listOfStrings) joined += item;
	return joined;
}

@doc{
	Counts the occurrences of one string in another.

	Parameters:
	- str string: The original string
	- str match: The string that is matched how often it occurs in the original one
}
int countOccurrences(str string, str match) {
	return size(findAll(string, match));
}

@javaClass{lib.java.Utility}
public java str hashMD5(str input);


/* TESTS */

test bool test_fillUp() {
	if (fillUp(" ", 0) != " ") return false;
	if (fillUp("", 0) != "") return false;
	if (fillUp("", 1) != " ") return false;
	if (fillUp("hallo", 5) != "hallo") return false;
	return true;
}

test bool test_joinString() {
	if (joinString([" ", "\n", ""]) != " \n") return false;
	if (joinString(["1", "2", "3"]) != "123") return false;
	if (joinString(["ツ", " ツ ", "ツ"]) != "ツ ツ ツ") return false;
	if (joinString(["TEST"]) != "TEST") return false;
	return true;
}

test bool test_countOccurrences() {
	if (countOccurrences("abracadabra", "a") != 5) return false;
	if (countOccurrences("lel", "l") != 2) return false;
	if (countOccurrences("ツ ツ ツ", "ツ") != 3) return false;
	if (countOccurrences("TEST", "TEST") != 1) return false;
	return true;
}

test bool test_hashMD5() {
	if (hashMD5("") != "d41d8cd98f00b204e9800998ecf8427e") return false;
	if (hashMD5(" ") != "7215ee9c7d9dc229d2921a40e899ec5f") return false;
	if (hashMD5("ツ") != "c3b5e4de19d4111ae1d682b86e921671") return false;
	if (hashMD5("TEST") != "033bd94b1168d7e4f0d644c3c95e35bf") return false;
	return true;
}
