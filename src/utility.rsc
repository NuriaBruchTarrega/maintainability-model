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
	
	Return str: The joined string
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
	
	Return int: The number of occurrences
}
int countOccurrences(str string, str match) {
	return size(findAll(string, match));
}

@doc{
	Renders the SIG logo as ASCII art.
}
str renderSIGLogo() {
	return("
		'
		'    ,*******              ***********   
		'   **********        ##    ***********   
		'   ******          ####    *        *    
		'   ******         #####                  
		'   ********       #####                  
		'     ********     #####          .....   
		'        *****     #####          *****   
		'                  #####          *****   
		'                  #####          *****   
		'   ******,,**     #####    ***********   
		'   **********     #####    ***********   
		'      ******      (((((    ******        
        '
	");
}

@doc{
	Renders the category legend tables.
}
str renderCategoryLegendTables() {
	return("
		'**********************************************************************************
		' Volume:
		'
		' Rank Levels:
		' --------------------
		' | Rank | KLOC      |
		' --------------------
		' | ++   | 0-66      |
		' | +    | 66-246    |
		' | o    | 246-665   |
		' | --   | 655-1,310 |
		' | -    | \>1,310    |
		' --------------------
		'
		'
		' Unit Complexity:
		'
		' Risk Levels:
		' ------------------------------------------
		' | CC    | Risk Evaluation                |
		' ------------------------------------------
		' | 1-10  | without much risk, simple risk |
		' | 11-20 | more complex, moderate risk    |
		' | 21-50 | complex, high risk             |
		' | \>50   | untestable, very high risk     |
		' ------------------------------------------
		'
		' Rank Levels (Maximum relative LOC):
		' --------------------------------------
		' | Rank | Moderate | High | Very High |
		' --------------------------------------
		' | ++   | 25%      | 0%   | 0%        |
		' | +    | 30%      | 5%   | 0%        |
		' | o    | 40%      | 10%  | 0%        |
		' | --   | 50%      | 15%  | 5%        |
		' | -    | –        | –    | –         |
		' --------------------------------------
		'
		'
		' Duplication:
		'
		' Rank Levels:
		' ---------------------------------
		' | Rank | Duplication Percentage |
		' ---------------------------------
		' | ++   | 0-3%                   |
		' | +    | 3-5%                   |
		' | o    | 5-10%                  |
		' | --   | 10-20%                 |
		' | -    | 20-100%                |
		' ---------------------------------
		'
		'
		' Unit Size:
		'
		' Risk Levels:
		' ------------------------------------------
		' | LOC   | Risk Evaluation                |
		' ------------------------------------------
		' | \>0    | without much risk, simple risk |
		' | \>10   | more complex, moderate risk    |
		' | \>50   | complex, high risk             |
		' | \>100  | untestable, very high risk     |
		' ------------------------------------------
		'
		' Rank Levels (Maximum relative LOC):
		' --------------------------------------
		' | Rank | Moderate | High | Very High |
		' --------------------------------------
		' | ++   | 25%      | 0%   | 0%        |
		' | +    | 30%      | 5%   | 0%        |
		' | o    | 40%      | 10%  | 0%        |
		' | --   | 50%      | 15%  | 5%        |
		' | -    | –        | –    | –         |
		' --------------------------------------
		'
		' Maintainability Aspects (Simple Average):
		' ----------------------------------------------------------------------
		' | Aspects       | Volume | Unit Complexity | Duplication | Unit Size |
		' ----------------------------------------------------------------------
		' | Analysability |   X    |                 |      X      |     X     |
		' | Changeability |        |        X        |      X      |           |
		' | Testability   |        |        X        |             |     X     |
		' ----------------------------------------------------------------------
		'**********************************************************************************
	");
}


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
