module calculation::helpers

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;


list[Declaration] retrieveAst(loc projectLocation) {
	M3 model = createM3FromEclipseProject(projectLocation);
	list[Declaration] ast = [];
	for (m <- model.containment, m[0].scheme == "java+compilationUnit"){
		ast += createAstFromFile(m[0], true);
	}
	return ast;
}
