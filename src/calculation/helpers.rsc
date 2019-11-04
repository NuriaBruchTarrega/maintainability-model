module calculation::helpers

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;


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
