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


M3 createM3Model(loc projectLocation) {
	return createM3FromEclipseProject(projectLocation);
}

map[loc, list[str]] retrieveProjectFiles(M3 model) {
	map[loc, list[str]] files = ();
	for (m <- model.containment, m[0].scheme == "java+compilationUnit") {
		files[m[0]] = readFileLines(m[0]);
	}
	return files;
}

list[Declaration] retrieveAst(M3 model) {
	list[Declaration] ast = [];
	for (m <- model.containment, m[0].scheme == "java+compilationUnit") {
		ast += createAstFromFile(m[0], true);
	}
	return ast;
}

str fillUp(str string, int amount) {
	for (_ <- [0..(amount - size(string))]) string += " ";
	return string;
}

str fillUp(int score, int amount) {
	return fillUp(toString(score), amount);
}

str fillUp(tuple[int moderate, int high, int veryhigh] risks, int amount) {
	return fillUp("<risks.moderate>% - <risks.high>% - <risks.veryhigh>%", amount);
}

str fillUp(Rank rank, int amount) {
	return fillUp(convertRankToLiteral(rank), amount);
}

str joinString(list[str] listOfStrings) {
	str joined = "";
	for (item <- listOfStrings) joined += item;
	return joined;
}

int countOccurrences(str string, str match) {
	return size(findAll(string, match));
}

//@javaClass{org.rascalmpl.library.Prelude}
//public java str md5Hash(str input)
//throws PathNotFound, IO;
