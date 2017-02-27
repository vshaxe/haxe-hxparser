// This file is autogenerated from ParseTree data structures
// Use build-walker.hxml to re-generate!

package hxParser;

import hxParser.ParseTree;

class Walker {
	function walkToken(token:Token) { }
	function walkArray<T>(elems:Array<T>, walk:T -> Void) {
		for (el in elems) walk(el);
	}
	function walkCommaSeparated<T>(elems:CommaSeparated<T>, walk:T -> Void) {
		walk(elems.arg);
		for (el in elems.args) {
			walkToken(el.comma);
			walk(el.arg);
		};
	}
	function walkCommaSeparatedTrailing<T>(elems:CommaSeparatedAllowTrailing<T>, walk:T -> Void) {
		walk(elems.arg);
		for (el in elems.args) {
			walkToken(el.comma);
			walk(el.arg);
		};
		if (elems.comma != null) walkToken(elems.comma);
	}
	function walkClassRelation_Extends(extendsKeyword:Token, path:TypePath) {
		walkToken(extendsKeyword);
		walkTypePath(path);
	}
	function walkNBlockElement_PVar_vl(elems:CommaSeparated<NVarDeclaration>) {
		walkCommaSeparated(elems, walkNVarDeclaration);
	}
	function walkNObjectFieldName_PString(string:NString) {
		walkNString(string);
	}
	function walkCatch(node:Catch) {
		walkToken(node.catchKeyword);
		walkToken(node.parenOpen);
		walkToken(node.ident);
		walkTypeHint(node.typeHint);
		walkToken(node.parenClose);
		walkExpr(node.expr);
	}
	function walkDecl_ClassDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, classDecl:ClassDecl) {
		walkNAnnotations(annotations);
		walkDecl_ClassDecl_flags(flags);
		walkClassDecl(classDecl);
	}
	function walkNObjectFieldName(node:NObjectFieldName) switch node {
		case PString(string):walkNObjectFieldName_PString(string);
		case PIdent(ident):walkNObjectFieldName_PIdent(ident);
	};
	function walkDecl_AbstractDecl_relations(elems:Array<AbstractRelation>) {
		walkArray(elems, walkAbstractRelation);
	}
	function walkNString_PString2(s:Token) {
		walkToken(s);
	}
	function walkNDotIdent_PDotIdent(name:Token) {
		walkToken(name);
	}
	function walkComplexType(node:ComplexType) switch node {
		case PFunctionType(type1, arrow, type2):walkComplexType_PFunctionType(type1, arrow, type2);
		case PStructuralExtension(braceOpen, types, fields, braceClose):walkComplexType_PStructuralExtension(braceOpen, types, fields, braceClose);
		case PParenthesisType(parenOpen, ct, parenClose):walkComplexType_PParenthesisType(parenOpen, ct, parenClose);
		case PAnonymousStructure(braceOpen, fields, braceClose):walkComplexType_PAnonymousStructure(braceOpen, fields, braceClose);
		case PTypePath(path):walkComplexType_PTypePath(path);
		case POptionalType(questionmark, type):walkComplexType_POptionalType(questionmark, type);
	};
	function walkExpr_EDollarIdent(ident:Token) {
		walkToken(ident);
	}
	function walkComplexType_PFunctionType(type1:ComplexType, arrow:Token, type2:ComplexType) {
		walkComplexType(type1);
		walkToken(arrow);
		walkComplexType(type2);
	}
	function walkNFieldExpr_PBlockFieldExpr(e:Expr) {
		walkExpr(e);
	}
	function walkNMacroExpr_PVar_v(elems:CommaSeparated<NVarDeclaration>) {
		walkCommaSeparated(elems, walkNVarDeclaration);
	}
	function walkExprElse(node:ExprElse) {
		walkToken(node.elseKeyword);
		walkExpr(node.expr);
	}
	function walkExpr_EReturn(returnKeyword:Token) {
		walkToken(returnKeyword);
	}
	function walkNTypePathParameter_PConstantTypePathParameter(constant:NLiteral) {
		walkNLiteral(constant);
	}
	function walkNEnumFieldArgs(node:NEnumFieldArgs) {
		walkToken(node.parenOpen);
		if (node.args != null) walkNEnumFieldArgs_args(node.args);
		walkToken(node.parenClose);
	}
	function walkNPath_idents(elems:Array<NDotIdent>) {
		walkArray(elems, walkNDotIdent);
	}
	function walkNMacroExpr_PClass(c:ClassDecl) {
		walkClassDecl(c);
	}
	function walkExpr_ECheckType(parenOpen:Token, e:Expr, colon:Token, type:ComplexType, parenClose:Token) {
		walkToken(parenOpen);
		walkExpr(e);
		walkToken(colon);
		walkComplexType(type);
		walkToken(parenClose);
	}
	function walkNTypePathParameter(node:NTypePathParameter) switch node {
		case PArrayExprTypePathParameter(bracketOpen, el, bracketClose):walkNTypePathParameter_PArrayExprTypePathParameter(bracketOpen, el, bracketClose);
		case PConstantTypePathParameter(constant):walkNTypePathParameter_PConstantTypePathParameter(constant);
		case PTypeTypePathParameter(type):walkNTypePathParameter_PTypeTypePathParameter(type);
	};
	function walkClassDecl(node:ClassDecl) {
		walkToken(node.kind);
		walkToken(node.name);
		if (node.params != null) walkTypeDeclParameters(node.params);
		walkClassDecl_relations(node.relations);
		walkToken(node.braceOpen);
		walkClassDecl_fields(node.fields);
		walkToken(node.braceClose);
	}
	function walkNConst_PConstLiteral(literal:NLiteral) {
		walkNLiteral(literal);
	}
	function walkImportMode(node:ImportMode) switch node {
		case IIn(inKeyword, ident):walkImportMode_IIn(inKeyword, ident);
		case INormal:{ };
		case IAll(dotstar):walkImportMode_IAll(dotstar);
		case IAs(asKeyword, ident):walkImportMode_IAs(asKeyword, ident);
	};
	function walkFile(node:File) {
		if (node.pack != null) walkPackage(node.pack);
		walkFile_decls(node.decls);
		walkToken(node.eof);
	}
	function walkFieldModifier_Static(keyword:Token) {
		walkToken(keyword);
	}
	function walkDecl_ImportDecl(importKeyword:Token, path:NPath, mode:ImportMode, semicolon:Token) {
		walkToken(importKeyword);
		walkNPath(path);
		walkImportMode(mode);
		walkToken(semicolon);
	}
	function walkNDotIdent_PDot(_dot:Token) {
		walkToken(_dot);
	}
	function walkExpr_EMetadata(metadata:NMetadata, expr:Expr) {
		walkNMetadata(metadata);
		walkExpr(expr);
	}
	function walkExpr_EThrow(throwKeyword:Token, expr:Expr) {
		walkToken(throwKeyword);
		walkExpr(expr);
	}
	function walkNMetadata_PMetadataWithArgs_el(elems:CommaSeparated<Expr>) {
		walkCommaSeparated(elems, walkExpr);
	}
	function walkNAnonymousTypeFields_PAnonymousShortFields(fields:Null<CommaSeparatedAllowTrailing<NAnonymousTypeField>>) {
		if (fields != null) walkNAnonymousTypeFields_PAnonymousShortFields_fields(fields);
	}
	function walkAbstractRelation_From(fromKeyword:Token, type:ComplexType) {
		walkToken(fromKeyword);
		walkComplexType(type);
	}
	function walkClassField_Function_modifiers(elems:Array<FieldModifier>) {
		walkArray(elems, walkFieldModifier);
	}
	function walkDecl_AbstractDecl_flags(elems:Array<NCommonFlag>) {
		walkArray(elems, walkNCommonFlag);
	}
	function walkTypeDeclParameters_params(elems:CommaSeparated<TypeDeclParameter>) {
		walkCommaSeparated(elems, walkTypeDeclParameter);
	}
	function walkExpr_EVar(varKeyword:Token, decl:NVarDeclaration) {
		walkToken(varKeyword);
		walkNVarDeclaration(decl);
	}
	function walkNCallArgs(node:NCallArgs) {
		walkToken(node.parenOpen);
		if (node.args != null) walkNCallArgs_args(node.args);
		walkToken(node.parenClose);
	}
	function walkNEnumFieldArgs_args(elems:CommaSeparated<NEnumFieldArg>) {
		walkCommaSeparated(elems, walkNEnumFieldArg);
	}
	function walkDecl_AbstractDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, abstractKeyword:Token, name:Token, params:Null<TypeDeclParameters>, underlyingType:Null<NUnderlyingType>, relations:Array<AbstractRelation>, braceOpen:Token, fields:Array<ClassField>, braceClose:Token) {
		walkNAnnotations(annotations);
		walkDecl_AbstractDecl_flags(flags);
		walkToken(abstractKeyword);
		walkToken(name);
		if (params != null) walkTypeDeclParameters(params);
		if (underlyingType != null) walkNUnderlyingType(underlyingType);
		walkDecl_AbstractDecl_relations(relations);
		walkToken(braceOpen);
		walkDecl_AbstractDecl_fields(fields);
		walkToken(braceClose);
	}
	function walkPackage(node:Package) {
		walkToken(node.packageKeyword);
		if (node.path != null) walkNPath(node.path);
		walkToken(node.semicolon);
	}
	function walkClassField_Function(annotations:NAnnotations, modifiers:Array<FieldModifier>, functionKeyword:Token, name:Token, params:Null<TypeDeclParameters>, parenOpen:Token, args:Null<CommaSeparated<NFunctionArgument>>, parenClose:Token, typeHint:Null<TypeHint>, expr:Null<NFieldExpr>) {
		walkNAnnotations(annotations);
		walkClassField_Function_modifiers(modifiers);
		walkToken(functionKeyword);
		walkToken(name);
		if (params != null) walkTypeDeclParameters(params);
		walkToken(parenOpen);
		if (args != null) walkClassField_Function_args(args);
		walkToken(parenClose);
		if (typeHint != null) walkTypeHint(typeHint);
		if (expr != null) walkNFieldExpr(expr);
	}
	function walkTypePath(node:TypePath) {
		walkNPath(node.path);
		if (node.params != null) walkNTypePathParameters(node.params);
	}
	function walkNConstraints_PMultipleConstraints(colon:Token, parenOpen:Token, types:CommaSeparated<ComplexType>, parenClose:Token) {
		walkToken(colon);
		walkToken(parenOpen);
		walkNConstraints_PMultipleConstraints_types(types);
		walkToken(parenClose);
	}
	function walkFieldModifier_Override(keyword:Token) {
		walkToken(keyword);
	}
	function walkExpr_EArrayDecl_el(elems:CommaSeparatedAllowTrailing<Expr>) {
		walkCommaSeparatedTrailing(elems, walkExpr);
	}
	function walkExpr_EIntDot(int:Token, dot:Token) {
		walkToken(int);
		walkToken(dot);
	}
	function walkNMacroExpr_PExpr(e:Expr) {
		walkExpr(e);
	}
	function walkClassField_Property_modifiers(elems:Array<FieldModifier>) {
		walkArray(elems, walkFieldModifier);
	}
	function walkNMacroExpr_PTypeHint(typeHint:TypeHint) {
		walkTypeHint(typeHint);
	}
	function walkExpr_ETernary(exprCond:Expr, questionmark:Token, exprThen:Expr, colon:Token, exprElse:Expr) {
		walkExpr(exprCond);
		walkToken(questionmark);
		walkExpr(exprThen);
		walkToken(colon);
		walkExpr(exprElse);
	}
	function walkFieldModifier_Public(keyword:Token) {
		walkToken(keyword);
	}
	function walkNAssignment(node:NAssignment) {
		walkToken(node.assign);
		walkExpr(node.e);
	}
	function walkExpr_ENew(_new:Token, path:TypePath, el:NCallArgs) {
		walkToken(_new);
		walkTypePath(path);
		walkNCallArgs(el);
	}
	function walkNCase_PDefault_el(elems:Array<NBlockElement>) {
		walkArray(elems, walkNBlockElement);
	}
	function walkNCallArgs_args(elems:CommaSeparated<Expr>) {
		walkCommaSeparated(elems, walkExpr);
	}
	function walkComplexType_PStructuralExtension_types(elems:Array<NStructuralExtension>) {
		walkArray(elems, walkNStructuralExtension);
	}
	function walkFieldModifier_Inline(keyword:Token) {
		walkToken(keyword);
	}
	function walkTypeDeclParameter(node:TypeDeclParameter) {
		walkNAnnotations(node.annotations);
		walkToken(node.name);
		walkNConstraints(node.constraints);
	}
	function walkComplexType_PAnonymousStructure(braceOpen:Token, fields:NAnonymousTypeFields, braceClose:Token) {
		walkToken(braceOpen);
		walkNAnonymousTypeFields(fields);
		walkToken(braceClose);
	}
	function walkExpr_EDo(doKeyword:Token, exprBody:Expr, whileKeyword:Token, parenOpen:Token, exprCond:Expr, parenClose:Token) {
		walkToken(doKeyword);
		walkExpr(exprBody);
		walkToken(whileKeyword);
		walkToken(parenOpen);
		walkExpr(exprCond);
		walkToken(parenClose);
	}
	function walkImportMode_IAs(asKeyword:Token, ident:Token) {
		walkToken(asKeyword);
		walkToken(ident);
	}
	function walkNFieldExpr(node:NFieldExpr) switch node {
		case PNoFieldExpr(semicolon):walkNFieldExpr_PNoFieldExpr(semicolon);
		case PBlockFieldExpr(e):walkNFieldExpr_PBlockFieldExpr(e);
		case PExprFieldExpr(e, semicolon):walkNFieldExpr_PExprFieldExpr(e, semicolon);
	};
	function walkNCase_PDefault(_default:Token, colon:Token, el:Array<NBlockElement>) {
		walkToken(_default);
		walkToken(colon);
		walkNCase_PDefault_el(el);
	}
	function walkExpr_EFor(_for:Token, parenOpen:Token, e1:Expr, parenClose:Token, e2:Expr) {
		walkToken(_for);
		walkToken(parenOpen);
		walkExpr(e1);
		walkToken(parenClose);
		walkExpr(e2);
	}
	function walkNMetadata_PMetadataWithArgs(name:Token, el:CommaSeparated<Expr>, parenClose:Token) {
		walkToken(name);
		walkNMetadata_PMetadataWithArgs_el(el);
		walkToken(parenClose);
	}
	function walkNCommonFlag(node:NCommonFlag) switch node {
		case PExtern(token):walkNCommonFlag_PExtern(token);
		case PPrivate(token):walkNCommonFlag_PPrivate(token);
	};
	function walkNBlockElement_PVar(_var:Token, vl:CommaSeparated<NVarDeclaration>, semicolon:Token) {
		walkToken(_var);
		walkNBlockElement_PVar_vl(vl);
		walkToken(semicolon);
	}
	function walkExpr_EBinop(exprLeft:Expr, op:Token, exprRight:Expr) {
		walkExpr(exprLeft);
		walkToken(op);
		walkExpr(exprRight);
	}
	function walkNTypePathParameter_PArrayExprTypePathParameter(bracketOpen:Token, el:Null<CommaSeparatedAllowTrailing<Expr>>, bracketClose:Token) {
		walkToken(bracketOpen);
		if (el != null) walkNTypePathParameter_PArrayExprTypePathParameter_el(el);
		walkToken(bracketClose);
	}
	function walkFieldModifier_Dynamic(keyword:Token) {
		walkToken(keyword);
	}
	function walkClassDecl_relations(elems:Array<ClassRelation>) {
		walkArray(elems, walkClassRelation);
	}
	function walkNPath(node:NPath) {
		walkToken(node.ident);
		walkNPath_idents(node.idents);
	}
	function walkNAnonymousTypeFields_PAnonymousClassFields_fields(elems:Array<ClassField>) {
		walkArray(elems, walkClassField);
	}
	function walkNTypePathParameter_PArrayExprTypePathParameter_el(elems:CommaSeparatedAllowTrailing<Expr>) {
		walkCommaSeparatedTrailing(elems, walkExpr);
	}
	function walkNStructuralExtension(node:NStructuralExtension) {
		walkToken(node.gt);
		walkTypePath(node.path);
		walkToken(node.comma);
	}
	function walkClassRelation(node:ClassRelation) switch node {
		case Extends(extendsKeyword, path):walkClassRelation_Extends(extendsKeyword, path);
		case Implements(implementsKeyword, path):walkClassRelation_Implements(implementsKeyword, path);
	};
	function walkNVarDeclaration(node:NVarDeclaration) {
		walkToken(node.name);
		if (node.typeHint != null) walkTypeHint(node.typeHint);
		if (node.assignment != null) walkNAssignment(node.assignment);
	}
	function walkExpr_EBlock(braceOpen:Token, elems:Array<NBlockElement>, braceClose:Token) {
		walkToken(braceOpen);
		walkExpr_EBlock_elems(elems);
		walkToken(braceClose);
	}
	function walkExpr_EParenthesis(parenOpen:Token, e:Expr, parenClose:Token) {
		walkToken(parenOpen);
		walkExpr(e);
		walkToken(parenClose);
	}
	function walkDecl_EnumDecl_flags(elems:Array<NCommonFlag>) {
		walkArray(elems, walkNCommonFlag);
	}
	function walkNObjectField(node:NObjectField) {
		walkNObjectFieldName(node.name);
		walkToken(node.colon);
		walkExpr(node.e);
	}
	function walkExpr(node:Expr) switch node {
		case EIs(parenOpen, e, _is, path, parenClose):walkExpr_EIs(parenOpen, e, _is, path, parenClose);
		case EMetadata(metadata, expr):walkExpr_EMetadata(metadata, expr);
		case EField(expr, ident):walkExpr_EField(expr, ident);
		case EMacro(macroKeyword, expr):walkExpr_EMacro(macroKeyword, expr);
		case ESwitch(_switch, e, braceOpen, cases, braceClose):walkExpr_ESwitch(_switch, e, braceOpen, cases, braceClose);
		case EReturnExpr(returnKeyword, expr):walkExpr_EReturnExpr(returnKeyword, expr);
		case EUnsafeCast(_cast, e):walkExpr_EUnsafeCast(_cast, e);
		case EIn(exprLeft, inKeyword, exprRight):walkExpr_EIn(exprLeft, inKeyword, exprRight);
		case EParenthesis(parenOpen, e, parenClose):walkExpr_EParenthesis(parenOpen, e, parenClose);
		case ESafeCast(_cast, parenOpen, e, comma, ct, parenClose):walkExpr_ESafeCast(_cast, parenOpen, e, comma, ct, parenClose);
		case EIf(ifKeyword, parenOpen, exprCond, parenClose, exprThen, exprElse):walkExpr_EIf(ifKeyword, parenOpen, exprCond, parenClose, exprThen, exprElse);
		case EBlock(braceOpen, elems, braceClose):walkExpr_EBlock(braceOpen, elems, braceClose);
		case EUnaryPrefix(op, expr):walkExpr_EUnaryPrefix(op, expr);
		case EBinop(exprLeft, op, exprRight):walkExpr_EBinop(exprLeft, op, exprRight);
		case ETry(tryKeyword, expr, catches):walkExpr_ETry(tryKeyword, expr, catches);
		case EObjectDecl(braceOpen, fl, braceClose):walkExpr_EObjectDecl(braceOpen, fl, braceClose);
		case EVar(varKeyword, decl):walkExpr_EVar(varKeyword, decl);
		case EBreak(breakKeyword):walkExpr_EBreak(breakKeyword);
		case EFor(_for, parenOpen, e1, parenClose, e2):walkExpr_EFor(_for, parenOpen, e1, parenClose, e2);
		case ENew(_new, path, el):walkExpr_ENew(_new, path, el);
		case ECall(expr, args):walkExpr_ECall(expr, args);
		case ECheckType(parenOpen, e, colon, type, parenClose):walkExpr_ECheckType(parenOpen, e, colon, type, parenClose);
		case EContinue(continueKeyword):walkExpr_EContinue(continueKeyword);
		case EUnaryPostfix(expr, op):walkExpr_EUnaryPostfix(expr, op);
		case EArrayAccess(expr, bracketOpen, exprKey, bracketClose):walkExpr_EArrayAccess(expr, bracketOpen, exprKey, bracketClose);
		case ETernary(exprCond, questionmark, exprThen, colon, exprElse):walkExpr_ETernary(exprCond, questionmark, exprThen, colon, exprElse);
		case EDo(doKeyword, exprBody, whileKeyword, parenOpen, exprCond, parenClose):walkExpr_EDo(doKeyword, exprBody, whileKeyword, parenOpen, exprCond, parenClose);
		case EMacroEscape(ident, braceOpen, expr, braceClose):walkExpr_EMacroEscape(ident, braceOpen, expr, braceClose);
		case EConst(const):walkExpr_EConst(const);
		case EDollarIdent(ident):walkExpr_EDollarIdent(ident);
		case EFunction(functionKeyword, fun):walkExpr_EFunction(functionKeyword, fun);
		case EReturn(returnKeyword):walkExpr_EReturn(returnKeyword);
		case EWhile(_while, parenOpen, e1, parenClose, e2):walkExpr_EWhile(_while, parenOpen, e1, parenClose, e2);
		case EArrayDecl(bracketOpen, el, bracketClose):walkExpr_EArrayDecl(bracketOpen, el, bracketClose);
		case EIntDot(int, dot):walkExpr_EIntDot(int, dot);
		case EThrow(throwKeyword, expr):walkExpr_EThrow(throwKeyword, expr);
		case EUntyped(_untyped, e):walkExpr_EUntyped(_untyped, e);
	};
	function walkExpr_ECall(expr:Expr, args:NCallArgs) {
		walkExpr(expr);
		walkNCallArgs(args);
	}
	function walkNLiteral_PLiteralString(s:NString) {
		walkNString(s);
	}
	function walkTypeDeclParameters(node:TypeDeclParameters) {
		walkToken(node.lt);
		walkTypeDeclParameters_params(node.params);
		walkToken(node.gt);
	}
	function walkClassRelation_Implements(implementsKeyword:Token, path:TypePath) {
		walkToken(implementsKeyword);
		walkTypePath(path);
	}
	function walkNBlockElement_PExpr(e:Expr, semicolon:Token) {
		walkExpr(e);
		walkToken(semicolon);
	}
	function walkNMetadata_PMetadata(name:Token) {
		walkToken(name);
	}
	function walkNLiteral(node:NLiteral) switch node {
		case PLiteralString(s):walkNLiteral_PLiteralString(s);
		case PLiteralFloat(token):walkNLiteral_PLiteralFloat(token);
		case PLiteralRegex(token):walkNLiteral_PLiteralRegex(token);
		case PLiteralInt(token):walkNLiteral_PLiteralInt(token);
	};
	function walkFieldModifier_Macro(keyword:Token) {
		walkToken(keyword);
	}
	function walkNCase_PCase_patterns(elems:CommaSeparated<Expr>) {
		walkCommaSeparated(elems, walkExpr);
	}
	function walkNLiteral_PLiteralRegex(token:Token) {
		walkToken(token);
	}
	function walkExpr_EWhile(_while:Token, parenOpen:Token, e1:Expr, parenClose:Token, e2:Expr) {
		walkToken(_while);
		walkToken(parenOpen);
		walkExpr(e1);
		walkToken(parenClose);
		walkExpr(e2);
	}
	function walkAbstractRelation(node:AbstractRelation) switch node {
		case To(toKeyword, type):walkAbstractRelation_To(toKeyword, type);
		case From(fromKeyword, type):walkAbstractRelation_From(fromKeyword, type);
	};
	function walkExpr_EBreak(breakKeyword:Token) {
		walkToken(breakKeyword);
	}
	function walkDecl_EnumDecl_fields(elems:Array<NEnumField>) {
		walkArray(elems, walkNEnumField);
	}
	function walkExpr_EIf(ifKeyword:Token, parenOpen:Token, exprCond:Expr, parenClose:Token, exprThen:Expr, exprElse:Null<ExprElse>) {
		walkToken(ifKeyword);
		walkToken(parenOpen);
		walkExpr(exprCond);
		walkToken(parenClose);
		walkExpr(exprThen);
		if (exprElse != null) walkExprElse(exprElse);
	}
	function walkNConst(node:NConst) switch node {
		case PConstLiteral(literal):walkNConst_PConstLiteral(literal);
		case PConstIdent(ident):walkNConst_PConstIdent(ident);
	};
	function walkNCommonFlag_PExtern(token:Token) {
		walkToken(token);
	}
	function walkDecl_UsingDecl(usingKeyword:Token, path:NPath, semicolon:Token) {
		walkToken(usingKeyword);
		walkNPath(path);
		walkToken(semicolon);
	}
	function walkAbstractRelation_To(toKeyword:Token, type:ComplexType) {
		walkToken(toKeyword);
		walkComplexType(type);
	}
	function walkDecl_AbstractDecl_fields(elems:Array<ClassField>) {
		walkArray(elems, walkClassField);
	}
	function walkExpr_EObjectDecl(braceOpen:Token, fl:CommaSeparatedAllowTrailing<NObjectField>, braceClose:Token) {
		walkToken(braceOpen);
		walkExpr_EObjectDecl_fl(fl);
		walkToken(braceClose);
	}
	function walkNTypePathParameters(node:NTypePathParameters) {
		walkToken(node.lt);
		walkNTypePathParameters_parameters(node.parameters);
		walkToken(node.gt);
	}
	function walkComplexType_PStructuralExtension(braceOpen:Token, types:Array<NStructuralExtension>, fields:NAnonymousTypeFields, braceClose:Token) {
		walkToken(braceOpen);
		walkComplexType_PStructuralExtension_types(types);
		walkNAnonymousTypeFields(fields);
		walkToken(braceClose);
	}
	function walkExpr_EIs(parenOpen:Token, e:Expr, _is:Token, path:TypePath, parenClose:Token) {
		walkToken(parenOpen);
		walkExpr(e);
		walkToken(_is);
		walkTypePath(path);
		walkToken(parenClose);
	}
	function walkClassDecl_fields(elems:Array<ClassField>) {
		walkArray(elems, walkClassField);
	}
	function walkNFunctionArgument(node:NFunctionArgument) {
		walkNAnnotations(node.annotations);
		if (node.questionmark != null) walkToken(node.questionmark);
		walkToken(node.name);
		if (node.typeHint != null) walkTypeHint(node.typeHint);
		if (node.assignment != null) walkNAssignment(node.assignment);
	}
	function walkExpr_EField(expr:Expr, ident:NDotIdent) {
		walkExpr(expr);
		walkNDotIdent(ident);
	}
	function walkExpr_EIn(exprLeft:Expr, inKeyword:Token, exprRight:Expr) {
		walkExpr(exprLeft);
		walkToken(inKeyword);
		walkExpr(exprRight);
	}
	function walkExpr_EUntyped(_untyped:Token, e:Expr) {
		walkToken(_untyped);
		walkExpr(e);
	}
	function walkNConst_PConstIdent(ident:Token) {
		walkToken(ident);
	}
	function walkNConstraints(node:NConstraints) switch node {
		case PMultipleConstraints(colon, parenOpen, types, parenClose):walkNConstraints_PMultipleConstraints(colon, parenOpen, types, parenClose);
		case PSingleConstraint(colon, type):walkNConstraints_PSingleConstraint(colon, type);
		case PNoConstraints:{ };
	};
	function walkNCase(node:NCase) switch node {
		case PCase(_case, patterns, guard, colon, el):walkNCase_PCase(_case, patterns, guard, colon, el);
		case PDefault(_default, colon, el):walkNCase_PDefault(_default, colon, el);
	};
	function walkExpr_EBlock_elems(elems:Array<NBlockElement>) {
		walkArray(elems, walkNBlockElement);
	}
	function walkNAnnotations_metadata(elems:Array<NMetadata>) {
		walkArray(elems, walkNMetadata);
	}
	function walkNConstraints_PSingleConstraint(colon:Token, type:ComplexType) {
		walkToken(colon);
		walkComplexType(type);
	}
	function walkNFieldExpr_PExprFieldExpr(e:Expr, semicolon:Token) {
		walkExpr(e);
		walkToken(semicolon);
	}
	function walkExpr_EUnsafeCast(_cast:Token, e:Expr) {
		walkToken(_cast);
		walkExpr(e);
	}
	function walkExpr_EFunction(functionKeyword:Token, fun:NFunction) {
		walkToken(functionKeyword);
		walkNFunction(fun);
	}
	function walkDecl_ClassDecl_flags(elems:Array<NCommonFlag>) {
		walkArray(elems, walkNCommonFlag);
	}
	function walkNString(node:NString) switch node {
		case PString(s):walkNString_PString(s);
		case PString2(s):walkNString_PString2(s);
	};
	function walkExpr_EArrayDecl(bracketOpen:Token, el:Null<CommaSeparatedAllowTrailing<Expr>>, bracketClose:Token) {
		walkToken(bracketOpen);
		if (el != null) walkExpr_EArrayDecl_el(el);
		walkToken(bracketClose);
	}
	function walkNAnnotations(node:NAnnotations) {
		if (node.doc != null) walkToken(node.doc);
		walkNAnnotations_metadata(node.metadata);
	}
	function walkNLiteral_PLiteralFloat(token:Token) {
		walkToken(token);
	}
	function walkExpr_ETry(tryKeyword:Token, expr:Expr, catches:Array<Catch>) {
		walkToken(tryKeyword);
		walkExpr(expr);
		walkExpr_ETry_catches(catches);
	}
	function walkExpr_EObjectDecl_fl(elems:CommaSeparatedAllowTrailing<NObjectField>) {
		walkCommaSeparatedTrailing(elems, walkNObjectField);
	}
	function walkNDotIdent(node:NDotIdent) switch node {
		case PDotIdent(name):walkNDotIdent_PDotIdent(name);
		case PDot(_dot):walkNDotIdent_PDot(_dot);
	};
	function walkClassField_Property(annotations:NAnnotations, modifiers:Array<FieldModifier>, varKeyword:Token, name:Token, parenOpen:Token, read:Token, comma:Token, write:Token, parenClose:Token, typeHint:Null<TypeHint>, assignment:Null<NAssignment>, semicolon:Token) {
		walkNAnnotations(annotations);
		walkClassField_Property_modifiers(modifiers);
		walkToken(varKeyword);
		walkToken(name);
		walkToken(parenOpen);
		walkToken(read);
		walkToken(comma);
		walkToken(write);
		walkToken(parenClose);
		if (typeHint != null) walkTypeHint(typeHint);
		if (assignment != null) walkNAssignment(assignment);
		walkToken(semicolon);
	}
	function walkComplexType_PParenthesisType(parenOpen:Token, ct:ComplexType, parenClose:Token) {
		walkToken(parenOpen);
		walkComplexType(ct);
		walkToken(parenClose);
	}
	function walkNFieldExpr_PNoFieldExpr(semicolon:Token) {
		walkToken(semicolon);
	}
	function walkExpr_ETry_catches(elems:Array<Catch>) {
		walkArray(elems, walkCatch);
	}
	function walkFieldModifier_Private(keyword:Token) {
		walkToken(keyword);
	}
	function walkClassField_Function_args(elems:CommaSeparated<NFunctionArgument>) {
		walkCommaSeparated(elems, walkNFunctionArgument);
	}
	function walkNTypePathParameter_PTypeTypePathParameter(type:ComplexType) {
		walkComplexType(type);
	}
	function walkExpr_EConst(const:NConst) {
		walkNConst(const);
	}
	function walkDecl_TypedefDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, typedefKeyword:Token, name:Token, params:Null<TypeDeclParameters>, assign:Token, type:ComplexType, semicolon:Null<Token>) {
		walkNAnnotations(annotations);
		walkDecl_TypedefDecl_flags(flags);
		walkToken(typedefKeyword);
		walkToken(name);
		if (params != null) walkTypeDeclParameters(params);
		walkToken(assign);
		walkComplexType(type);
		if (semicolon != null) walkToken(semicolon);
	}
	function walkClassField_Variable(annotations:NAnnotations, modifiers:Array<FieldModifier>, varKeyword:Token, name:Token, typeHint:Null<TypeHint>, assignment:Null<NAssignment>, semicolon:Token) {
		walkNAnnotations(annotations);
		walkClassField_Variable_modifiers(modifiers);
		walkToken(varKeyword);
		walkToken(name);
		if (typeHint != null) walkTypeHint(typeHint);
		if (assignment != null) walkNAssignment(assignment);
		walkToken(semicolon);
	}
	function walkExpr_EUnaryPostfix(expr:Expr, op:Token) {
		walkExpr(expr);
		walkToken(op);
	}
	function walkNTypePathParameters_parameters(elems:CommaSeparated<NTypePathParameter>) {
		walkCommaSeparated(elems, walkNTypePathParameter);
	}
	function walkDecl_TypedefDecl_flags(elems:Array<NCommonFlag>) {
		walkArray(elems, walkNCommonFlag);
	}
	function walkExpr_EArrayAccess(expr:Expr, bracketOpen:Token, exprKey:Expr, bracketClose:Token) {
		walkExpr(expr);
		walkToken(bracketOpen);
		walkExpr(exprKey);
		walkToken(bracketClose);
	}
	function walkImportMode_IIn(inKeyword:Token, ident:Token) {
		walkToken(inKeyword);
		walkToken(ident);
	}
	function walkFieldModifier(node:FieldModifier) switch node {
		case Dynamic(keyword):walkFieldModifier_Dynamic(keyword);
		case Inline(keyword):walkFieldModifier_Inline(keyword);
		case Macro(keyword):walkFieldModifier_Macro(keyword);
		case Override(keyword):walkFieldModifier_Override(keyword);
		case Private(keyword):walkFieldModifier_Private(keyword);
		case Public(keyword):walkFieldModifier_Public(keyword);
		case Static(keyword):walkFieldModifier_Static(keyword);
	};
	function walkNFunction_args(elems:CommaSeparated<NFunctionArgument>) {
		walkCommaSeparated(elems, walkNFunctionArgument);
	}
	function walkExpr_EContinue(continueKeyword:Token) {
		walkToken(continueKeyword);
	}
	function walkNConstraints_PMultipleConstraints_types(elems:CommaSeparated<ComplexType>) {
		walkCommaSeparated(elems, walkComplexType);
	}
	function walkExpr_EMacroEscape(ident:Token, braceOpen:Token, expr:Expr, braceClose:Token) {
		walkToken(ident);
		walkToken(braceOpen);
		walkExpr(expr);
		walkToken(braceClose);
	}
	function walkNLiteral_PLiteralInt(token:Token) {
		walkToken(token);
	}
	function walkTypeHint(node:TypeHint) {
		walkToken(node.colon);
		walkComplexType(node.type);
	}
	function walkComplexType_POptionalType(questionmark:Token, type:ComplexType) {
		walkToken(questionmark);
		walkComplexType(type);
	}
	function walkNBlockElement_PInlineFunction(_inline:Token, _function:Token, f:NFunction, semicolon:Token) {
		walkToken(_inline);
		walkToken(_function);
		walkNFunction(f);
		walkToken(semicolon);
	}
	function walkNCase_PCase_el(elems:Array<NBlockElement>) {
		walkArray(elems, walkNBlockElement);
	}
	function walkClassField_Variable_modifiers(elems:Array<FieldModifier>) {
		walkArray(elems, walkFieldModifier);
	}
	function walkNAnonymousTypeFields_PAnonymousClassFields(fields:Array<ClassField>) {
		walkNAnonymousTypeFields_PAnonymousClassFields_fields(fields);
	}
	function walkExpr_ESafeCast(_cast:Token, parenOpen:Token, e:Expr, comma:Token, ct:ComplexType, parenClose:Token) {
		walkToken(_cast);
		walkToken(parenOpen);
		walkExpr(e);
		walkToken(comma);
		walkComplexType(ct);
		walkToken(parenClose);
	}
	function walkNAnonymousTypeField(node:NAnonymousTypeField) {
		if (node.questionmark != null) walkToken(node.questionmark);
		walkToken(node.name);
		walkTypeHint(node.typeHint);
	}
	function walkNUnderlyingType(node:NUnderlyingType) {
		walkToken(node.parenOpen);
		walkComplexType(node.type);
		walkToken(node.parenClose);
	}
	function walkFile_decls(elems:Array<Decl>) {
		walkArray(elems, walkDecl);
	}
	function walkDecl(node:Decl) switch node {
		case ClassDecl(annotations, flags, classDecl):walkDecl_ClassDecl(annotations, flags, classDecl);
		case TypedefDecl(annotations, flags, typedefKeyword, name, params, assign, type, semicolon):walkDecl_TypedefDecl(annotations, flags, typedefKeyword, name, params, assign, type, semicolon);
		case EnumDecl(annotations, flags, enumKeyword, name, params, braceOpen, fields, braceClose):walkDecl_EnumDecl(annotations, flags, enumKeyword, name, params, braceOpen, fields, braceClose);
		case UsingDecl(usingKeyword, path, semicolon):walkDecl_UsingDecl(usingKeyword, path, semicolon);
		case AbstractDecl(annotations, flags, abstractKeyword, name, params, underlyingType, relations, braceOpen, fields, braceClose):walkDecl_AbstractDecl(annotations, flags, abstractKeyword, name, params, underlyingType, relations, braceOpen, fields, braceClose);
		case ImportDecl(importKeyword, path, mode, semicolon):walkDecl_ImportDecl(importKeyword, path, mode, semicolon);
	};
	function walkNGuard(node:NGuard) {
		walkToken(node._if);
		walkToken(node.parenOpen);
		walkExpr(node.e);
		walkToken(node.parenClose);
	}
	function walkNMacroExpr(node:NMacroExpr) switch node {
		case PVar(_var, v):walkNMacroExpr_PVar(_var, v);
		case PTypeHint(typeHint):walkNMacroExpr_PTypeHint(typeHint);
		case PClass(c):walkNMacroExpr_PClass(c);
		case PExpr(e):walkNMacroExpr_PExpr(e);
	};
	function walkNEnumField(node:NEnumField) {
		walkNAnnotations(node.annotations);
		walkToken(node.name);
		if (node.params != null) walkTypeDeclParameters(node.params);
		if (node.args != null) walkNEnumFieldArgs(node.args);
		if (node.typeHint != null) walkTypeHint(node.typeHint);
		walkToken(node.semicolon);
	}
	function walkNBlockElement(node:NBlockElement) switch node {
		case PVar(_var, vl, semicolon):walkNBlockElement_PVar(_var, vl, semicolon);
		case PExpr(e, semicolon):walkNBlockElement_PExpr(e, semicolon);
		case PInlineFunction(_inline, _function, f, semicolon):walkNBlockElement_PInlineFunction(_inline, _function, f, semicolon);
	};
	function walkDecl_EnumDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, enumKeyword:Token, name:Token, params:Null<TypeDeclParameters>, braceOpen:Token, fields:Array<NEnumField>, braceClose:Token) {
		walkNAnnotations(annotations);
		walkDecl_EnumDecl_flags(flags);
		walkToken(enumKeyword);
		walkToken(name);
		if (params != null) walkTypeDeclParameters(params);
		walkToken(braceOpen);
		walkDecl_EnumDecl_fields(fields);
		walkToken(braceClose);
	}
	function walkExpr_EMacro(macroKeyword:Token, expr:NMacroExpr) {
		walkToken(macroKeyword);
		walkNMacroExpr(expr);
	}
	function walkNEnumFieldArg(node:NEnumFieldArg) {
		if (node.questionmark != null) walkToken(node.questionmark);
		walkToken(node.name);
		walkTypeHint(node.typeHint);
	}
	function walkNMetadata(node:NMetadata) switch node {
		case PMetadata(name):walkNMetadata_PMetadata(name);
		case PMetadataWithArgs(name, el, parenClose):walkNMetadata_PMetadataWithArgs(name, el, parenClose);
	};
	function walkNCase_PCase(_case:Token, patterns:CommaSeparated<Expr>, guard:Null<NGuard>, colon:Token, el:Array<NBlockElement>) {
		walkToken(_case);
		walkNCase_PCase_patterns(patterns);
		if (guard != null) walkNGuard(guard);
		walkToken(colon);
		walkNCase_PCase_el(el);
	}
	function walkExpr_EReturnExpr(returnKeyword:Token, expr:Expr) {
		walkToken(returnKeyword);
		walkExpr(expr);
	}
	function walkNObjectFieldName_PIdent(ident:Token) {
		walkToken(ident);
	}
	function walkNMacroExpr_PVar(_var:Token, v:CommaSeparated<NVarDeclaration>) {
		walkToken(_var);
		walkNMacroExpr_PVar_v(v);
	}
	function walkNAnonymousTypeFields(node:NAnonymousTypeFields) switch node {
		case PAnonymousClassFields(fields):walkNAnonymousTypeFields_PAnonymousClassFields(fields);
		case PAnonymousShortFields(fields):walkNAnonymousTypeFields_PAnonymousShortFields(fields);
	};
	function walkNAnonymousTypeFields_PAnonymousShortFields_fields(elems:CommaSeparatedAllowTrailing<NAnonymousTypeField>) {
		walkCommaSeparatedTrailing(elems, walkNAnonymousTypeField);
	}
	function walkExpr_ESwitch(_switch:Token, e:Expr, braceOpen:Token, cases:Array<NCase>, braceClose:Token) {
		walkToken(_switch);
		walkExpr(e);
		walkToken(braceOpen);
		walkExpr_ESwitch_cases(cases);
		walkToken(braceClose);
	}
	function walkNCommonFlag_PPrivate(token:Token) {
		walkToken(token);
	}
	function walkNString_PString(s:Token) {
		walkToken(s);
	}
	function walkNFunction(node:NFunction) {
		if (node.ident != null) walkToken(node.ident);
		if (node.params != null) walkTypeDeclParameters(node.params);
		walkToken(node.parenOpen);
		if (node.args != null) walkNFunction_args(node.args);
		walkToken(node.parenClose);
		if (node.typeHint != null) walkTypeHint(node.typeHint);
		walkExpr(node.e);
	}
	function walkImportMode_IAll(dotstar:Token) {
		walkToken(dotstar);
	}
	function walkClassField(node:ClassField) switch node {
		case Property(annotations, modifiers, varKeyword, name, parenOpen, read, comma, write, parenClose, typeHint, assignment, semicolon):walkClassField_Property(annotations, modifiers, varKeyword, name, parenOpen, read, comma, write, parenClose, typeHint, assignment, semicolon);
		case Variable(annotations, modifiers, varKeyword, name, typeHint, assignment, semicolon):walkClassField_Variable(annotations, modifiers, varKeyword, name, typeHint, assignment, semicolon);
		case Function(annotations, modifiers, functionKeyword, name, params, parenOpen, args, parenClose, typeHint, expr):walkClassField_Function(annotations, modifiers, functionKeyword, name, params, parenOpen, args, parenClose, typeHint, expr);
	};
	function walkExpr_ESwitch_cases(elems:Array<NCase>) {
		walkArray(elems, walkNCase);
	}
	function walkExpr_EUnaryPrefix(op:Token, expr:Expr) {
		walkToken(op);
		walkExpr(expr);
	}
	function walkComplexType_PTypePath(path:TypePath) {
		walkTypePath(path);
	}
}