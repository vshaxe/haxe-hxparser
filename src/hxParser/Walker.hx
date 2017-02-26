// This file is autogenerated from ParseTree data structures
// Use build-walker.hxml to re-generate!

package hxParser;

import hxParser.ParseTree;

class Walker {
	function walkToken(token:Token) { }
	function walkArray<T>(elems:Array<T>, walk:T -> Void) {
		for (el in elems) walk(el);
	}
	function walkCommaSeparated<T>(elems:NCommaSeparated<T>, walk:T -> Void) {
		walk(elems.arg);
		for (el in elems.args) {
			walkToken(el.comma);
			walk(el.arg);
		};
	}
	function walkCommaSeparatedTrailing<T>(elems:NCommaSeparatedAllowTrailing<T>, walk:T -> Void) {
		walk(elems.arg);
		for (el in elems.args) {
			walkToken(el.comma);
			walk(el.arg);
		};
		if (elems.comma != null) walkToken(elems.comma);
	}
	function walk_NFile(__value:NFile) {
		if (__value.pack != null) walk_NPackage(__value.pack);
		walkArray(__value.decls, function(el) walk_NDecl(el));
		walkToken(__value.eof);
	}
	function walk_NPackage(__value:NPackage) {
		walkToken(__value._package);
		if (__value.path != null) walk_NPath(__value.path);
		walkToken(__value.semicolon);
	}
	function walk_NImportMode(__value:NImportMode) switch __value {
		case PAsMode(_as, ident):{
			walkToken(_as);
			walkToken(ident);
		};
		case PNormalMode:{ };
		case PInMode(_in, ident):{
			walkToken(_in);
			walkToken(ident);
		};
		case PAllMode(dotstar):{
			walkToken(dotstar);
		};
	};
	function walk_NLiteral(__value:NLiteral) switch __value {
		case PLiteralString(s):{
			walk_NString(s);
		};
		case PLiteralFloat(token):{
			walkToken(token);
		};
		case PLiteralRegex(token):{
			walkToken(token);
		};
		case PLiteralInt(token):{
			walkToken(token);
		};
	};
	function walk_NAssignment(__value:NAssignment) {
		walkToken(__value.assign);
		walk_NExpr(__value.e);
	}
	function walk_NObjectFieldName(__value:NObjectFieldName) switch __value {
		case PString(string):{
			walk_NString(string);
		};
		case PIdent(ident):{
			walkToken(ident);
		};
	};
	function walk_NAbstractRelation(__value:NAbstractRelation) switch __value {
		case PFrom(_from, type):{
			walkToken(_from);
			walk_NComplexType(type);
		};
		case PTo(_to, type):{
			walkToken(_to);
			walk_NComplexType(type);
		};
	};
	function walk_NTypeHint(__value:NTypeHint) {
		walkToken(__value.colon);
		walk_NComplexType(__value.type);
	}
	function walk_NClassDecl(__value:NClassDecl) {
		walkToken(__value.kind);
		walkToken(__value.name);
		if (__value.params != null) walk_NTypeDeclParameters(__value.params);
		walkArray(__value.relations, function(el) walk_NClassRelation(el));
		walkToken(__value.bropen);
		walkArray(__value.fields, function(el) walk_NClassField(el));
		walkToken(__value.brclose);
	}
	function walk_NCatch(__value:NCatch) {
		walkToken(__value._catch);
		walkToken(__value.popen);
		walkToken(__value.ident);
		walk_NTypeHint(__value.type);
		walkToken(__value.pclose);
		walk_NExpr(__value.e);
	}
	function walk_NTypeDeclParameter(__value:NTypeDeclParameter) {
		walk_NAnnotations(__value.annotations);
		walkToken(__value.name);
		walk_NConstraints(__value.constraints);
	}
	function walk_NConst(__value:NConst) switch __value {
		case PConstLiteral(literal):{
			walk_NLiteral(literal);
		};
		case PConstIdent(ident):{
			walkToken(ident);
		};
	};
	function walk_NTypePathParameters(__value:NTypePathParameters) {
		walkToken(__value.lt);
		walkCommaSeparated(__value.parameters, function(el) walk_NTypePathParameter(el));
		walkToken(__value.gt);
	}
	function walk_NModifier(__value:NModifier) switch __value {
		case PModifierStatic(token):{
			walkToken(token);
		};
		case PModifierOverride(token):{
			walkToken(token);
		};
		case PModifierMacro(token):{
			walkToken(token);
		};
		case PModifierDynamic(token):{
			walkToken(token);
		};
		case PModifierInline(token):{
			walkToken(token);
		};
		case PModifierPrivate(token):{
			walkToken(token);
		};
		case PModifierPublic(token):{
			walkToken(token);
		};
	};
	function walk_NFieldExpr(__value:NFieldExpr) switch __value {
		case PNoFieldExpr(semicolon):{
			walkToken(semicolon);
		};
		case PBlockFieldExpr(e):{
			walk_NExpr(e);
		};
		case PExprFieldExpr(e, semicolon):{
			walk_NExpr(e);
			walkToken(semicolon);
		};
	};
	function walk_NCommonFlag(__value:NCommonFlag) switch __value {
		case PExtern(token):{
			walkToken(token);
		};
		case PPrivate(token):{
			walkToken(token);
		};
	};
	function walk_NEnumFieldArgs(__value:NEnumFieldArgs) {
		walkToken(__value.popen);
		if (__value.args != null) walkCommaSeparated(__value.args, function(el) walk_NEnumFieldArg(el));
		walkToken(__value.pclose);
	}
	function walk_NFunctionArgument(__value:NFunctionArgument) {
		walk_NAnnotations(__value.annotations);
		if (__value.questionmark != null) walkToken(__value.questionmark);
		walkToken(__value.name);
		if (__value.typeHint != null) walk_NTypeHint(__value.typeHint);
		if (__value.assignment != null) walk_NAssignment(__value.assignment);
	}
	function walk_NAnonymousTypeField(__value:NAnonymousTypeField) {
		if (__value.questionmark != null) walkToken(__value.questionmark);
		walkToken(__value.name);
		walk_NTypeHint(__value.typeHint);
	}
	function walk_NUnderlyingType(__value:NUnderlyingType) {
		walkToken(__value.popen);
		walk_NComplexType(__value.type);
		walkToken(__value.pclose);
	}
	function walk_NTypePathParameter(__value:NTypePathParameter) switch __value {
		case PArrayExprTypePathParameter(bkopen, el, bkclose):{
			walkToken(bkopen);
			if (el != null) walkCommaSeparatedTrailing(el, function(el) walk_NExpr(el));
			walkToken(bkclose);
		};
		case PConstantTypePathParameter(constant):{
			walk_NLiteral(constant);
		};
		case PTypeTypePathParameter(type):{
			walk_NComplexType(type);
		};
	};
	function walk_NTypeDeclParameters(__value:NTypeDeclParameters) {
		walkToken(__value.lt);
		walkCommaSeparated(__value.params, function(el) walk_NTypeDeclParameter(el));
		walkToken(__value.gt);
	}
	function walk_NGuard(__value:NGuard) {
		walkToken(__value._if);
		walkToken(__value.popen);
		walk_NExpr(__value.e);
		walkToken(__value.pclose);
	}
	function walk_NMacroExpr(__value:NMacroExpr) switch __value {
		case PVar(_var, v):{
			walkToken(_var);
			walkCommaSeparated(v, function(el) walk_NVarDeclaration(el));
		};
		case PTypeHint(type):{
			walk_NTypeHint(type);
		};
		case PClass(c):{
			walk_NClassDecl(c);
		};
		case PExpr(e):{
			walk_NExpr(e);
		};
	};
	function walk_NEnumField(__value:NEnumField) {
		walk_NAnnotations(__value.annotations);
		walkToken(__value.name);
		if (__value.params != null) walk_NTypeDeclParameters(__value.params);
		if (__value.args != null) walk_NEnumFieldArgs(__value.args);
		if (__value.type != null) walk_NTypeHint(__value.type);
		walkToken(__value.semicolon);
	}
	function walk_NPath(__value:NPath) {
		walkToken(__value.ident);
		walkArray(__value.idents, function(el) walk_NDotIdent(el));
	}
	function walk_NDecl(__value:NDecl) switch __value {
		case PClassDecl(annotations, flags, c):{
			walk_NAnnotations(annotations);
			walkArray(flags, function(el) walk_NCommonFlag(el));
			walk_NClassDecl(c);
		};
		case PTypedefDecl(annotations, flags, _typedef, name, params, assign, type, semicolon):{
			walk_NAnnotations(annotations);
			walkArray(flags, function(el) walk_NCommonFlag(el));
			walkToken(_typedef);
			walkToken(name);
			if (params != null) walk_NTypeDeclParameters(params);
			walkToken(assign);
			walk_NComplexType(type);
			if (semicolon != null) walkToken(semicolon);
		};
		case PUsingDecl(_using, path, semicolon):{
			walkToken(_using);
			walk_NPath(path);
			walkToken(semicolon);
		};
		case PImportDecl(_import, importPath, semicolon):{
			walkToken(_import);
			walk_NImport(importPath);
			walkToken(semicolon);
		};
		case PAbstractDecl(annotations, flags, _abstract, name, params, underlyingType, relations, bropen, fields, brclose):{
			walk_NAnnotations(annotations);
			walkArray(flags, function(el) walk_NCommonFlag(el));
			walkToken(_abstract);
			walkToken(name);
			if (params != null) walk_NTypeDeclParameters(params);
			if (underlyingType != null) walk_NUnderlyingType(underlyingType);
			walkArray(relations, function(el) walk_NAbstractRelation(el));
			walkToken(bropen);
			walkArray(fields, function(el) walk_NClassField(el));
			walkToken(brclose);
		};
		case PEnumDecl(annotations, flags, _enum, name, params, bropen, fields, brclose):{
			walk_NAnnotations(annotations);
			walkArray(flags, function(el) walk_NCommonFlag(el));
			walkToken(_enum);
			walkToken(name);
			if (params != null) walk_NTypeDeclParameters(params);
			walkToken(bropen);
			walkArray(fields, function(el) walk_NEnumField(el));
			walkToken(brclose);
		};
	};
	function walk_NConstraints(__value:NConstraints) switch __value {
		case PMultipleConstraints(colon, popen, types, pclose):{
			walkToken(colon);
			walkToken(popen);
			walkCommaSeparated(types, function(el) walk_NComplexType(el));
			walkToken(pclose);
		};
		case PSingleConstraint(colon, type):{
			walkToken(colon);
			walk_NComplexType(type);
		};
		case PNoConstraints:{ };
	};
	function walk_NBlockElement(__value:NBlockElement) switch __value {
		case PVar(_var, vl, semicolon):{
			walkToken(_var);
			walkCommaSeparated(vl, function(el) walk_NVarDeclaration(el));
			walkToken(semicolon);
		};
		case PExpr(e, semicolon):{
			walk_NExpr(e);
			walkToken(semicolon);
		};
		case PInlineFunction(_inline, _function, f, semicolon):{
			walkToken(_inline);
			walkToken(_function);
			walk_NFunction(f);
			walkToken(semicolon);
		};
	};
	function walk_NClassField(__value:NClassField) switch __value {
		case PPropertyField(annotations, modifiers, _var, name, popen, get, comma, set, pclose, typeHint, assignment):{
			walk_NAnnotations(annotations);
			walkArray(modifiers, function(el) walk_NModifier(el));
			walkToken(_var);
			walkToken(name);
			walkToken(popen);
			walkToken(get);
			walkToken(comma);
			walkToken(set);
			walkToken(pclose);
			if (typeHint != null) walk_NTypeHint(typeHint);
			if (assignment != null) walk_NAssignment(assignment);
		};
		case PVariableField(annotations, modifiers, _var, name, typeHint, assignment, semicolon):{
			walk_NAnnotations(annotations);
			walkArray(modifiers, function(el) walk_NModifier(el));
			walkToken(_var);
			walkToken(name);
			if (typeHint != null) walk_NTypeHint(typeHint);
			if (assignment != null) walk_NAssignment(assignment);
			walkToken(semicolon);
		};
		case PFunctionField(annotations, modifiers, _function, name, params, popen, args, pclose, typeHint, e):{
			walk_NAnnotations(annotations);
			walkArray(modifiers, function(el) walk_NModifier(el));
			walkToken(_function);
			walkToken(name);
			if (params != null) walk_NTypeDeclParameters(params);
			walkToken(popen);
			if (args != null) walkCommaSeparated(args, function(el) walk_NFunctionArgument(el));
			walkToken(pclose);
			if (typeHint != null) walk_NTypeHint(typeHint);
			if (e != null) walk_NFieldExpr(e);
		};
	};
	function walk_NClassRelation(__value:NClassRelation) switch __value {
		case PExtends(_extends, path):{
			walkToken(_extends);
			walk_NTypePath(path);
		};
		case PImplements(_implements, path):{
			walkToken(_implements);
			walk_NTypePath(path);
		};
	};
	function walk_NCase(__value:NCase) switch __value {
		case PCase(_case, patterns, guard, colon, el):{
			walkToken(_case);
			walkCommaSeparated(patterns, function(el) walk_NExpr(el));
			if (guard != null) walk_NGuard(guard);
			walkToken(colon);
			walkArray(el, function(el) walk_NBlockElement(el));
		};
		case PDefault(_default, colon, el):{
			walkToken(_default);
			walkToken(colon);
			walkArray(el, function(el) walk_NBlockElement(el));
		};
	};
	function walk_NStructuralExtension(__value:NStructuralExtension) {
		walkToken(__value.gt);
		walk_NTypePath(__value.path);
		walkToken(__value.comma);
	}
	function walk_NEnumFieldArg(__value:NEnumFieldArg) {
		if (__value.questionmark != null) walkToken(__value.questionmark);
		walkToken(__value.name);
		walk_NTypeHint(__value.typeHint);
	}
	function walk_NMetadata(__value:NMetadata) switch __value {
		case PMetadata(name):{
			walkToken(name);
		};
		case PMetadataWithArgs(name, el, pclose):{
			walkToken(name);
			walkCommaSeparated(el, function(el) walk_NExpr(el));
			walkToken(pclose);
		};
	};
	function walk_NVarDeclaration(__value:NVarDeclaration) {
		walkToken(__value.name);
		if (__value.type != null) walk_NTypeHint(__value.type);
		if (__value.assignment != null) walk_NAssignment(__value.assignment);
	}
	function walk_NTypePath(__value:NTypePath) {
		walk_NPath(__value.path);
		if (__value.params != null) walk_NTypePathParameters(__value.params);
	}
	function walk_NString(__value:NString) switch __value {
		case PString(s):{
			walkToken(s);
		};
		case PString2(s):{
			walkToken(s);
		};
	};
	function walk_NAnnotations(__value:NAnnotations) {
		if (__value.doc != null) walkToken(__value.doc);
		walkArray(__value.meta, function(el) walk_NMetadata(el));
	}
	function walk_NExpr(__value:NExpr) switch __value {
		case PVar(_var, d):{
			walkToken(_var);
			walk_NVarDeclaration(d);
		};
		case PConst(const):{
			walk_NConst(const);
		};
		case PDo(_do, e1, _while, popen, e2, pclose):{
			walkToken(_do);
			walk_NExpr(e1);
			walkToken(_while);
			walkToken(popen);
			walk_NExpr(e2);
			walkToken(pclose);
		};
		case PMacro(_macro, e):{
			walkToken(_macro);
			walk_NMacroExpr(e);
		};
		case PWhile(_while, popen, e1, pclose, e2):{
			walkToken(_while);
			walkToken(popen);
			walk_NExpr(e1);
			walkToken(pclose);
			walk_NExpr(e2);
		};
		case PIntDot(int, dot):{
			walkToken(int);
			walkToken(dot);
		};
		case PBlock(bropen, elems, brclose):{
			walkToken(bropen);
			walkArray(elems, function(el) walk_NBlockElement(el));
			walkToken(brclose);
		};
		case PFunction(_function, f):{
			walkToken(_function);
			walk_NFunction(f);
		};
		case PSwitch(_switch, e, bropen, cases, brclose):{
			walkToken(_switch);
			walk_NExpr(e);
			walkToken(bropen);
			walkArray(cases, function(el) walk_NCase(el));
			walkToken(brclose);
		};
		case PReturn(_return):{
			walkToken(_return);
		};
		case PArrayDecl(bkopen, el, bkclose):{
			walkToken(bkopen);
			if (el != null) walkCommaSeparatedTrailing(el, function(el) walk_NExpr(el));
			walkToken(bkclose);
		};
		case PIf(_if, popen, e1, pclose, e2, elseExpr):{
			walkToken(_if);
			walkToken(popen);
			walk_NExpr(e1);
			walkToken(pclose);
			walk_NExpr(e2);
			if (elseExpr != null) walk_NExprElse(elseExpr);
		};
		case PReturnExpr(_return, e):{
			walkToken(_return);
			walk_NExpr(e);
		};
		case PArray(e1, bkopen, e2, bkclose):{
			walk_NExpr(e1);
			walkToken(bkopen);
			walk_NExpr(e2);
			walkToken(bkclose);
		};
		case PContinue(_continue):{
			walkToken(_continue);
		};
		case PParenthesis(popen, e, pclose):{
			walkToken(popen);
			walk_NExpr(e);
			walkToken(pclose);
		};
		case PTry(_try, e, catches):{
			walkToken(_try);
			walk_NExpr(e);
			walkArray(catches, function(el) walk_NCatch(el));
		};
		case PBreak(_break):{
			walkToken(_break);
		};
		case PCall(e, el):{
			walk_NExpr(e);
			walk_NCallArgs(el);
		};
		case PUnaryPostfix(e, op):{
			walk_NExpr(e);
			walkToken(op);
		};
		case PBinop(e1, op, e2):{
			walk_NExpr(e1);
			walkToken(op);
			walk_NExpr(e2);
		};
		case PSafeCast(_cast, popen, e, comma, ct, pclose):{
			walkToken(_cast);
			walkToken(popen);
			walk_NExpr(e);
			walkToken(comma);
			walk_NComplexType(ct);
			walkToken(pclose);
		};
		case PUnaryPrefix(op, e):{
			walkToken(op);
			walk_NExpr(e);
		};
		case PMacroEscape(ident, bropen, e, brclose):{
			walkToken(ident);
			walkToken(bropen);
			walk_NExpr(e);
			walkToken(brclose);
		};
		case PIn(e1, _in, e2):{
			walk_NExpr(e1);
			walkToken(_in);
			walk_NExpr(e2);
		};
		case PMetadata(metadata, e):{
			walk_NMetadata(metadata);
			walk_NExpr(e);
		};
		case PUnsafeCast(_cast, e):{
			walkToken(_cast);
			walk_NExpr(e);
		};
		case PCheckType(popen, e, colon, type, pclose):{
			walkToken(popen);
			walk_NExpr(e);
			walkToken(colon);
			walk_NComplexType(type);
			walkToken(pclose);
		};
		case PUntyped(_untyped, e):{
			walkToken(_untyped);
			walk_NExpr(e);
		};
		case PField(e, ident):{
			walk_NExpr(e);
			walk_NDotIdent(ident);
		};
		case PIs(popen, e, _is, path, pclose):{
			walkToken(popen);
			walk_NExpr(e);
			walkToken(_is);
			walk_NTypePath(path);
			walkToken(pclose);
		};
		case PTernary(e1, questionmark, e2, colon, e3):{
			walk_NExpr(e1);
			walkToken(questionmark);
			walk_NExpr(e2);
			walkToken(colon);
			walk_NExpr(e3);
		};
		case PObjectDecl(bropen, fl, brclose):{
			walkToken(bropen);
			walkCommaSeparatedTrailing(fl, function(el) walk_NObjectField(el));
			walkToken(brclose);
		};
		case PNew(_new, path, el):{
			walkToken(_new);
			walk_NTypePath(path);
			walk_NCallArgs(el);
		};
		case PThrow(_throw, e):{
			walkToken(_throw);
			walk_NExpr(e);
		};
		case PFor(_for, popen, e1, pclose, e2):{
			walkToken(_for);
			walkToken(popen);
			walk_NExpr(e1);
			walkToken(pclose);
			walk_NExpr(e2);
		};
	};
	function walk_NAnonymousTypeFields(__value:NAnonymousTypeFields) switch __value {
		case PAnonymousClassFields(fields):{
			walkArray(fields, function(el) walk_NClassField(el));
		};
		case PAnonymousShortFields(fields):{
			if (fields != null) walkCommaSeparatedTrailing(fields, function(el) walk_NAnonymousTypeField(el));
		};
	};
	function walk_NCallArgs(__value:NCallArgs) {
		walkToken(__value.popen);
		if (__value.args != null) walkCommaSeparated(__value.args, function(el) walk_NExpr(el));
		walkToken(__value.pclose);
	}
	function walk_NDotIdent(__value:NDotIdent) switch __value {
		case PDotIdent(name):{
			walkToken(name);
		};
		case PDot(_dot):{
			walkToken(_dot);
		};
	};
	function walk_NObjectField(__value:NObjectField) {
		walk_NObjectFieldName(__value.name);
		walkToken(__value.colon);
		walk_NExpr(__value.e);
	}
	function walk_NFunction(__value:NFunction) {
		if (__value.ident != null) walkToken(__value.ident);
		if (__value.params != null) walk_NTypeDeclParameters(__value.params);
		walkToken(__value.popen);
		if (__value.args != null) walkCommaSeparated(__value.args, function(el) walk_NFunctionArgument(el));
		walkToken(__value.pclose);
		if (__value.type != null) walk_NTypeHint(__value.type);
		walk_NExpr(__value.e);
	}
	function walk_NImport(__value:NImport) {
		walk_NPath(__value.path);
		walk_NImportMode(__value.mode);
	}
	function walk_NComplexType(__value:NComplexType) switch __value {
		case PFunctionType(type1, arrow, type2):{
			walk_NComplexType(type1);
			walkToken(arrow);
			walk_NComplexType(type2);
		};
		case PStructuralExtension(bropen, types, fields, brclose):{
			walkToken(bropen);
			walkArray(types, function(el) walk_NStructuralExtension(el));
			walk_NAnonymousTypeFields(fields);
			walkToken(brclose);
		};
		case PParenthesisType(popen, ct, pclose):{
			walkToken(popen);
			walk_NComplexType(ct);
			walkToken(pclose);
		};
		case PAnoymousStructure(bropen, fields, brclose):{
			walkToken(bropen);
			walk_NAnonymousTypeFields(fields);
			walkToken(brclose);
		};
		case PTypePath(path):{
			walk_NTypePath(path);
		};
		case POptionalType(questionmark, type):{
			walkToken(questionmark);
			walk_NComplexType(type);
		};
	};
	function walk_NExprElse(__value:NExprElse) {
		walkToken(__value._else);
		walk_NExpr(__value.e);
	}
}