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
	function walkNExpr_PArrayDecl_el(elems:CommaSeparatedAllowTrailing<NExpr>) {
		walkCommaSeparatedTrailing(elems, walkNExpr);
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
	function walkNTypeHint(node:NTypeHint) {
		walkToken(node.colon);
		walkComplexType(node.type);
	}
	function walkNString_PString2(s:Token) {
		walkToken(s);
	}
	function walkNExpr_PVar(_var:Token, d:NVarDeclaration) {
		walkToken(_var);
		walkNVarDeclaration(d);
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
	function walkNExpr_PDo(_do:Token, e1:NExpr, _while:Token, parenOpen:Token, e2:NExpr, parenClose:Token) {
		walkToken(_do);
		walkNExpr(e1);
		walkToken(_while);
		walkToken(parenOpen);
		walkNExpr(e2);
		walkToken(parenClose);
	}
	function walkComplexType_PFunctionType(type1:ComplexType, arrow:Token, type2:ComplexType) {
		walkComplexType(type1);
		walkToken(arrow);
		walkComplexType(type2);
	}
	function walkNFieldExpr_PBlockFieldExpr(e:NExpr) {
		walkNExpr(e);
	}
	function walkNMacroExpr_PVar_v(elems:CommaSeparated<NVarDeclaration>) {
		walkCommaSeparated(elems, walkNVarDeclaration);
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
	function walkNExpr_PBlock(braceOpen:Token, elems:Array<NBlockElement>, braceClose:Token) {
		walkToken(braceOpen);
		walkNExpr_PBlock_elems(elems);
		walkToken(braceClose);
	}
	function walkNExpr_PUnsafeCast(_cast:Token, e:NExpr) {
		walkToken(_cast);
		walkNExpr(e);
	}
	function walkNTypePathParameter(node:NTypePathParameter) switch node {
		case PArrayExprTypePathParameter(bracketOpen, el, bracketClose):walkNTypePathParameter_PArrayExprTypePathParameter(bracketOpen, el, bracketClose);
		case PConstantTypePathParameter(constant):walkNTypePathParameter_PConstantTypePathParameter(constant);
		case PTypeTypePathParameter(type):walkNTypePathParameter_PTypeTypePathParameter(type);
	};
	function walkNConst_PConstLiteral(literal:NLiteral) {
		walkNLiteral(literal);
	}
	function walkClassDecl(node:ClassDecl) {
		walkToken(node.kind);
		walkToken(node.name);
		if (node.params != null) walkNTypeDeclParameters(node.params);
		walkClassDecl_relations(node.relations);
		walkToken(node.braceOpen);
		walkClassDecl_fields(node.fields);
		walkToken(node.braceClose);
	}
	function walkNExpr_PMetadata(metadata:NMetadata, e:NExpr) {
		walkNMetadata(metadata);
		walkNExpr(e);
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
	function walkNMetadata_PMetadataWithArgs_el(elems:CommaSeparated<NExpr>) {
		walkCommaSeparated(elems, walkNExpr);
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
	function walkNExpr_PSwitch_cases(elems:Array<NCase>) {
		walkArray(elems, walkNCase);
	}
	function walkNExpr_PSafeCast(_cast:Token, parenOpen:Token, e:NExpr, comma:Token, ct:ComplexType, parenClose:Token) {
		walkToken(_cast);
		walkToken(parenOpen);
		walkNExpr(e);
		walkToken(comma);
		walkComplexType(ct);
		walkToken(parenClose);
	}
	function walkDecl_AbstractDecl_flags(elems:Array<NCommonFlag>) {
		walkArray(elems, walkNCommonFlag);
	}
	function walkNExpr(node:NExpr) switch node {
		case PVar(_var, d):walkNExpr_PVar(_var, d);
		case PConst(const):walkNExpr_PConst(const);
		case PDo(_do, e1, _while, parenOpen, e2, parenClose):walkNExpr_PDo(_do, e1, _while, parenOpen, e2, parenClose);
		case PMacro(_macro, e):walkNExpr_PMacro(_macro, e);
		case PWhile(_while, parenOpen, e1, parenClose, e2):walkNExpr_PWhile(_while, parenOpen, e1, parenClose, e2);
		case PIntDot(int, dot):walkNExpr_PIntDot(int, dot);
		case PBlock(braceOpen, elems, braceClose):walkNExpr_PBlock(braceOpen, elems, braceClose);
		case PFunction(_function, f):walkNExpr_PFunction(_function, f);
		case PSwitch(_switch, e, braceOpen, cases, braceClose):walkNExpr_PSwitch(_switch, e, braceOpen, cases, braceClose);
		case PReturn(_return):walkNExpr_PReturn(_return);
		case PArrayDecl(bracketOpen, el, bracketClose):walkNExpr_PArrayDecl(bracketOpen, el, bracketClose);
		case PDollarIdent(ident):walkNExpr_PDollarIdent(ident);
		case PIf(_if, parenOpen, e1, parenClose, e2, elseExpr):walkNExpr_PIf(_if, parenOpen, e1, parenClose, e2, elseExpr);
		case PReturnExpr(_return, e):walkNExpr_PReturnExpr(_return, e);
		case PArray(e1, bracketOpen, e2, bracketClose):walkNExpr_PArray(e1, bracketOpen, e2, bracketClose);
		case PContinue(_continue):walkNExpr_PContinue(_continue);
		case PParenthesis(parenOpen, e, parenClose):walkNExpr_PParenthesis(parenOpen, e, parenClose);
		case PTry(_try, e, catches):walkNExpr_PTry(_try, e, catches);
		case PBreak(_break):walkNExpr_PBreak(_break);
		case PCall(e, el):walkNExpr_PCall(e, el);
		case PUnaryPostfix(e, op):walkNExpr_PUnaryPostfix(e, op);
		case PBinop(e1, op, e2):walkNExpr_PBinop(e1, op, e2);
		case PSafeCast(_cast, parenOpen, e, comma, ct, parenClose):walkNExpr_PSafeCast(_cast, parenOpen, e, comma, ct, parenClose);
		case PUnaryPrefix(op, e):walkNExpr_PUnaryPrefix(op, e);
		case PMacroEscape(ident, braceOpen, e, braceClose):walkNExpr_PMacroEscape(ident, braceOpen, e, braceClose);
		case PIn(e1, _in, e2):walkNExpr_PIn(e1, _in, e2);
		case PMetadata(metadata, e):walkNExpr_PMetadata(metadata, e);
		case PUnsafeCast(_cast, e):walkNExpr_PUnsafeCast(_cast, e);
		case PCheckType(parenOpen, e, colon, type, parenClose):walkNExpr_PCheckType(parenOpen, e, colon, type, parenClose);
		case PUntyped(_untyped, e):walkNExpr_PUntyped(_untyped, e);
		case PField(e, ident):walkNExpr_PField(e, ident);
		case PIs(parenOpen, e, _is, path, parenClose):walkNExpr_PIs(parenOpen, e, _is, path, parenClose);
		case PTernary(e1, questionmark, e2, colon, e3):walkNExpr_PTernary(e1, questionmark, e2, colon, e3);
		case PObjectDecl(braceOpen, fl, braceClose):walkNExpr_PObjectDecl(braceOpen, fl, braceClose);
		case PNew(_new, path, el):walkNExpr_PNew(_new, path, el);
		case PThrow(_throw, e):walkNExpr_PThrow(_throw, e);
		case PFor(_for, parenOpen, e1, parenClose, e2):walkNExpr_PFor(_for, parenOpen, e1, parenClose, e2);
	};
	function walkNCallArgs(node:NCallArgs) {
		walkToken(node.parenOpen);
		if (node.args != null) walkNCallArgs_args(node.args);
		walkToken(node.parenClose);
	}
	function walkNEnumFieldArgs_args(elems:CommaSeparated<NEnumFieldArg>) {
		walkCommaSeparated(elems, walkNEnumFieldArg);
	}
	function walkDecl_AbstractDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, abstractKeyword:Token, name:Token, params:Null<NTypeDeclParameters>, underlyingType:Null<NUnderlyingType>, relations:Array<AbstractRelation>, braceOpen:Token, fields:Array<ClassField>, braceClose:Token) {
		walkNAnnotations(annotations);
		walkDecl_AbstractDecl_flags(flags);
		walkToken(abstractKeyword);
		walkToken(name);
		if (params != null) walkNTypeDeclParameters(params);
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
	function walkClassField_Function(annotations:NAnnotations, modifiers:Array<FieldModifier>, functionKeyword:Token, name:Token, params:Null<NTypeDeclParameters>, parenOpen:Token, args:Null<CommaSeparated<NFunctionArgument>>, parenClose:Token, typeHint:Null<NTypeHint>, expr:Null<NFieldExpr>) {
		walkNAnnotations(annotations);
		walkClassField_Function_modifiers(modifiers);
		walkToken(functionKeyword);
		walkToken(name);
		if (params != null) walkNTypeDeclParameters(params);
		walkToken(parenOpen);
		if (args != null) walkClassField_Function_args(args);
		walkToken(parenClose);
		if (typeHint != null) walkNTypeHint(typeHint);
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
	function walkNExpr_PObjectDecl_fl(elems:CommaSeparatedAllowTrailing<NObjectField>) {
		walkCommaSeparatedTrailing(elems, walkNObjectField);
	}
	function walkFieldModifier_Override(keyword:Token) {
		walkToken(keyword);
	}
	function walkNExpr_PConst(const:NConst) {
		walkNConst(const);
	}
	function walkNExpr_PParenthesis(parenOpen:Token, e:NExpr, parenClose:Token) {
		walkToken(parenOpen);
		walkNExpr(e);
		walkToken(parenClose);
	}
	function walkNMacroExpr_PExpr(e:NExpr) {
		walkNExpr(e);
	}
	function walkNExpr_PBreak(_break:Token) {
		walkToken(_break);
	}
	function walkClassField_Property_modifiers(elems:Array<FieldModifier>) {
		walkArray(elems, walkFieldModifier);
	}
	function walkNTypeDeclParameters_params(elems:CommaSeparated<NTypeDeclParameter>) {
		walkCommaSeparated(elems, walkNTypeDeclParameter);
	}
	function walkNMacroExpr_PTypeHint(type:NTypeHint) {
		walkNTypeHint(type);
	}
	function walkNExpr_PArrayDecl(bracketOpen:Token, el:Null<CommaSeparatedAllowTrailing<NExpr>>, bracketClose:Token) {
		walkToken(bracketOpen);
		if (el != null) walkNExpr_PArrayDecl_el(el);
		walkToken(bracketClose);
	}
	function walkFieldModifier_Public(keyword:Token) {
		walkToken(keyword);
	}
	function walkNAssignment(node:NAssignment) {
		walkToken(node.assign);
		walkNExpr(node.e);
	}
	function walkNCase_PDefault_el(elems:Array<NBlockElement>) {
		walkArray(elems, walkNBlockElement);
	}
	function walkNCallArgs_args(elems:CommaSeparated<NExpr>) {
		walkCommaSeparated(elems, walkNExpr);
	}
	function walkNExpr_PObjectDecl(braceOpen:Token, fl:CommaSeparatedAllowTrailing<NObjectField>, braceClose:Token) {
		walkToken(braceOpen);
		walkNExpr_PObjectDecl_fl(fl);
		walkToken(braceClose);
	}
	function walkNCatch(node:NCatch) {
		walkToken(node._catch);
		walkToken(node.parenOpen);
		walkToken(node.ident);
		walkNTypeHint(node.type);
		walkToken(node.parenClose);
		walkNExpr(node.e);
	}
	function walkNTypeDeclParameter(node:NTypeDeclParameter) {
		walkNAnnotations(node.annotations);
		walkToken(node.name);
		walkNConstraints(node.constraints);
	}
	function walkComplexType_PStructuralExtension_types(elems:Array<NStructuralExtension>) {
		walkArray(elems, walkNStructuralExtension);
	}
	function walkFieldModifier_Inline(keyword:Token) {
		walkToken(keyword);
	}
	function walkComplexType_PAnonymousStructure(braceOpen:Token, fields:NAnonymousTypeFields, braceClose:Token) {
		walkToken(braceOpen);
		walkNAnonymousTypeFields(fields);
		walkToken(braceClose);
	}
	function walkNExpr_PIntDot(int:Token, dot:Token) {
		walkToken(int);
		walkToken(dot);
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
	function walkNMetadata_PMetadataWithArgs(name:Token, el:CommaSeparated<NExpr>, parenClose:Token) {
		walkToken(name);
		walkNMetadata_PMetadataWithArgs_el(el);
		walkToken(parenClose);
	}
	function walkNCommonFlag(node:NCommonFlag) switch node {
		case PExtern(token):walkNCommonFlag_PExtern(token);
		case PPrivate(token):walkNCommonFlag_PPrivate(token);
	};
	function walkNExpr_PArray(e1:NExpr, bracketOpen:Token, e2:NExpr, bracketClose:Token) {
		walkNExpr(e1);
		walkToken(bracketOpen);
		walkNExpr(e2);
		walkToken(bracketClose);
	}
	function walkNBlockElement_PVar(_var:Token, vl:CommaSeparated<NVarDeclaration>, semicolon:Token) {
		walkToken(_var);
		walkNBlockElement_PVar_vl(vl);
		walkToken(semicolon);
	}
	function walkNTypePathParameter_PArrayExprTypePathParameter(bracketOpen:Token, el:Null<CommaSeparatedAllowTrailing<NExpr>>, bracketClose:Token) {
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
	function walkNTypePathParameter_PArrayExprTypePathParameter_el(elems:CommaSeparatedAllowTrailing<NExpr>) {
		walkCommaSeparatedTrailing(elems, walkNExpr);
	}
	function walkNExpr_PContinue(_continue:Token) {
		walkToken(_continue);
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
		if (node.type != null) walkNTypeHint(node.type);
		if (node.assignment != null) walkNAssignment(node.assignment);
	}
	function walkDecl_EnumDecl_flags(elems:Array<NCommonFlag>) {
		walkArray(elems, walkNCommonFlag);
	}
	function walkNObjectField(node:NObjectField) {
		walkNObjectFieldName(node.name);
		walkToken(node.colon);
		walkNExpr(node.e);
	}
	function walkNLiteral_PLiteralString(s:NString) {
		walkNString(s);
	}
	function walkClassRelation_Implements(implementsKeyword:Token, path:TypePath) {
		walkToken(implementsKeyword);
		walkTypePath(path);
	}
	function walkNExpr_PBinop(e1:NExpr, op:Token, e2:NExpr) {
		walkNExpr(e1);
		walkToken(op);
		walkNExpr(e2);
	}
	function walkNBlockElement_PExpr(e:NExpr, semicolon:Token) {
		walkNExpr(e);
		walkToken(semicolon);
	}
	function walkNAnnotations_meta(elems:Array<NMetadata>) {
		walkArray(elems, walkNMetadata);
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
	function walkNExpr_PFunction(_function:Token, f:NFunction) {
		walkToken(_function);
		walkNFunction(f);
	}
	function walkNCase_PCase_patterns(elems:CommaSeparated<NExpr>) {
		walkCommaSeparated(elems, walkNExpr);
	}
	function walkNLiteral_PLiteralRegex(token:Token) {
		walkToken(token);
	}
	function walkNExpr_PNew(_new:Token, path:TypePath, el:NCallArgs) {
		walkToken(_new);
		walkTypePath(path);
		walkNCallArgs(el);
	}
	function walkNExpr_PThrow(_throw:Token, e:NExpr) {
		walkToken(_throw);
		walkNExpr(e);
	}
	function walkAbstractRelation(node:AbstractRelation) switch node {
		case To(toKeyword, type):walkAbstractRelation_To(toKeyword, type);
		case From(fromKeyword, type):walkAbstractRelation_From(fromKeyword, type);
	};
	function walkDecl_EnumDecl_fields(elems:Array<NEnumField>) {
		walkArray(elems, walkNEnumField);
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
	function walkClassDecl_fields(elems:Array<ClassField>) {
		walkArray(elems, walkClassField);
	}
	function walkNExpr_PTry(_try:Token, e:NExpr, catches:Array<NCatch>) {
		walkToken(_try);
		walkNExpr(e);
		walkNExpr_PTry_catches(catches);
	}
	function walkNExpr_PCall(e:NExpr, el:NCallArgs) {
		walkNExpr(e);
		walkNCallArgs(el);
	}
	function walkNFunctionArgument(node:NFunctionArgument) {
		walkNAnnotations(node.annotations);
		if (node.questionmark != null) walkToken(node.questionmark);
		walkToken(node.name);
		if (node.typeHint != null) walkNTypeHint(node.typeHint);
		if (node.assignment != null) walkNAssignment(node.assignment);
	}
	function walkNExpr_PTernary(e1:NExpr, questionmark:Token, e2:NExpr, colon:Token, e3:NExpr) {
		walkNExpr(e1);
		walkToken(questionmark);
		walkNExpr(e2);
		walkToken(colon);
		walkNExpr(e3);
	}
	function walkNTypeDeclParameters(node:NTypeDeclParameters) {
		walkToken(node.lt);
		walkNTypeDeclParameters_params(node.params);
		walkToken(node.gt);
	}
	function walkNConst_PConstIdent(ident:Token) {
		walkToken(ident);
	}
	function walkNExpr_PUnaryPrefix(op:Token, e:NExpr) {
		walkToken(op);
		walkNExpr(e);
	}
	function walkNExpr_PUntyped(_untyped:Token, e:NExpr) {
		walkToken(_untyped);
		walkNExpr(e);
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
	function walkNConstraints_PSingleConstraint(colon:Token, type:ComplexType) {
		walkToken(colon);
		walkComplexType(type);
	}
	function walkNFieldExpr_PExprFieldExpr(e:NExpr, semicolon:Token) {
		walkNExpr(e);
		walkToken(semicolon);
	}
	function walkDecl_ClassDecl_flags(elems:Array<NCommonFlag>) {
		walkArray(elems, walkNCommonFlag);
	}
	function walkNString(node:NString) switch node {
		case PString(s):walkNString_PString(s);
		case PString2(s):walkNString_PString2(s);
	};
	function walkNAnnotations(node:NAnnotations) {
		if (node.doc != null) walkToken(node.doc);
		walkNAnnotations_meta(node.meta);
	}
	function walkNLiteral_PLiteralFloat(token:Token) {
		walkToken(token);
	}
	function walkNExpr_PIf(_if:Token, parenOpen:Token, e1:NExpr, parenClose:Token, e2:NExpr, elseExpr:Null<NExprElse>) {
		walkToken(_if);
		walkToken(parenOpen);
		walkNExpr(e1);
		walkToken(parenClose);
		walkNExpr(e2);
		if (elseExpr != null) walkNExprElse(elseExpr);
	}
	function walkNDotIdent(node:NDotIdent) switch node {
		case PDotIdent(name):walkNDotIdent_PDotIdent(name);
		case PDot(_dot):walkNDotIdent_PDot(_dot);
	};
	function walkNExpr_PCheckType(parenOpen:Token, e:NExpr, colon:Token, type:ComplexType, parenClose:Token) {
		walkToken(parenOpen);
		walkNExpr(e);
		walkToken(colon);
		walkComplexType(type);
		walkToken(parenClose);
	}
	function walkNExpr_PUnaryPostfix(e:NExpr, op:Token) {
		walkNExpr(e);
		walkToken(op);
	}
	function walkClassField_Property(annotations:NAnnotations, modifiers:Array<FieldModifier>, varKeyword:Token, name:Token, parenOpen:Token, read:Token, comma:Token, write:Token, parenClose:Token, typeHint:Null<NTypeHint>, assignment:Null<NAssignment>) {
		walkNAnnotations(annotations);
		walkClassField_Property_modifiers(modifiers);
		walkToken(varKeyword);
		walkToken(name);
		walkToken(parenOpen);
		walkToken(read);
		walkToken(comma);
		walkToken(write);
		walkToken(parenClose);
		if (typeHint != null) walkNTypeHint(typeHint);
		if (assignment != null) walkNAssignment(assignment);
	}
	function walkComplexType_PParenthesisType(parenOpen:Token, ct:ComplexType, parenClose:Token) {
		walkToken(parenOpen);
		walkComplexType(ct);
		walkToken(parenClose);
	}
	function walkNFieldExpr_PNoFieldExpr(semicolon:Token) {
		walkToken(semicolon);
	}
	function walkNTypePathParameter_PTypeTypePathParameter(type:ComplexType) {
		walkComplexType(type);
	}
	function walkFieldModifier_Private(keyword:Token) {
		walkToken(keyword);
	}
	function walkClassField_Function_args(elems:CommaSeparated<NFunctionArgument>) {
		walkCommaSeparated(elems, walkNFunctionArgument);
	}
	function walkDecl_TypedefDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, typedefKeyword:Token, name:Token, params:Null<NTypeDeclParameters>, assign:Token, type:ComplexType, semicolon:Null<Token>) {
		walkNAnnotations(annotations);
		walkDecl_TypedefDecl_flags(flags);
		walkToken(typedefKeyword);
		walkToken(name);
		if (params != null) walkNTypeDeclParameters(params);
		walkToken(assign);
		walkComplexType(type);
		if (semicolon != null) walkToken(semicolon);
	}
	function walkClassField_Variable(annotations:NAnnotations, modifiers:Array<FieldModifier>, varKeyword:Token, name:Token, typeHint:Null<NTypeHint>, assignment:Null<NAssignment>, semicolon:Token) {
		walkNAnnotations(annotations);
		walkClassField_Variable_modifiers(modifiers);
		walkToken(varKeyword);
		walkToken(name);
		if (typeHint != null) walkNTypeHint(typeHint);
		if (assignment != null) walkNAssignment(assignment);
		walkToken(semicolon);
	}
	function walkNTypePathParameters_parameters(elems:CommaSeparated<NTypePathParameter>) {
		walkCommaSeparated(elems, walkNTypePathParameter);
	}
	function walkNExpr_PMacro(_macro:Token, e:NMacroExpr) {
		walkToken(_macro);
		walkNMacroExpr(e);
	}
	function walkDecl_TypedefDecl_flags(elems:Array<NCommonFlag>) {
		walkArray(elems, walkNCommonFlag);
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
	function walkNExpr_PBlock_elems(elems:Array<NBlockElement>) {
		walkArray(elems, walkNBlockElement);
	}
	function walkNFunction_args(elems:CommaSeparated<NFunctionArgument>) {
		walkCommaSeparated(elems, walkNFunctionArgument);
	}
	function walkNConstraints_PMultipleConstraints_types(elems:CommaSeparated<ComplexType>) {
		walkCommaSeparated(elems, walkComplexType);
	}
	function walkNLiteral_PLiteralInt(token:Token) {
		walkToken(token);
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
	function walkNExpr_PIn(e1:NExpr, _in:Token, e2:NExpr) {
		walkNExpr(e1);
		walkToken(_in);
		walkNExpr(e2);
	}
	function walkClassField_Variable_modifiers(elems:Array<FieldModifier>) {
		walkArray(elems, walkFieldModifier);
	}
	function walkNAnonymousTypeFields_PAnonymousClassFields(fields:Array<ClassField>) {
		walkNAnonymousTypeFields_PAnonymousClassFields_fields(fields);
	}
	function walkNAnonymousTypeField(node:NAnonymousTypeField) {
		if (node.questionmark != null) walkToken(node.questionmark);
		walkToken(node.name);
		walkNTypeHint(node.typeHint);
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
		walkNExpr(node.e);
		walkToken(node.parenClose);
	}
	function walkNMacroExpr(node:NMacroExpr) switch node {
		case PVar(_var, v):walkNMacroExpr_PVar(_var, v);
		case PTypeHint(type):walkNMacroExpr_PTypeHint(type);
		case PClass(c):walkNMacroExpr_PClass(c);
		case PExpr(e):walkNMacroExpr_PExpr(e);
	};
	function walkNEnumField(node:NEnumField) {
		walkNAnnotations(node.annotations);
		walkToken(node.name);
		if (node.params != null) walkNTypeDeclParameters(node.params);
		if (node.args != null) walkNEnumFieldArgs(node.args);
		if (node.type != null) walkNTypeHint(node.type);
		walkToken(node.semicolon);
	}
	function walkNBlockElement(node:NBlockElement) switch node {
		case PVar(_var, vl, semicolon):walkNBlockElement_PVar(_var, vl, semicolon);
		case PExpr(e, semicolon):walkNBlockElement_PExpr(e, semicolon);
		case PInlineFunction(_inline, _function, f, semicolon):walkNBlockElement_PInlineFunction(_inline, _function, f, semicolon);
	};
	function walkNExpr_PSwitch(_switch:Token, e:NExpr, braceOpen:Token, cases:Array<NCase>, braceClose:Token) {
		walkToken(_switch);
		walkNExpr(e);
		walkToken(braceOpen);
		walkNExpr_PSwitch_cases(cases);
		walkToken(braceClose);
	}
	function walkNExpr_PField(e:NExpr, ident:NDotIdent) {
		walkNExpr(e);
		walkNDotIdent(ident);
	}
	function walkNExpr_PFor(_for:Token, parenOpen:Token, e1:NExpr, parenClose:Token, e2:NExpr) {
		walkToken(_for);
		walkToken(parenOpen);
		walkNExpr(e1);
		walkToken(parenClose);
		walkNExpr(e2);
	}
	function walkDecl_EnumDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, enumKeyword:Token, name:Token, params:Null<NTypeDeclParameters>, braceOpen:Token, fields:Array<NEnumField>, braceClose:Token) {
		walkNAnnotations(annotations);
		walkDecl_EnumDecl_flags(flags);
		walkToken(enumKeyword);
		walkToken(name);
		if (params != null) walkNTypeDeclParameters(params);
		walkToken(braceOpen);
		walkDecl_EnumDecl_fields(fields);
		walkToken(braceClose);
	}
	function walkNEnumFieldArg(node:NEnumFieldArg) {
		if (node.questionmark != null) walkToken(node.questionmark);
		walkToken(node.name);
		walkNTypeHint(node.typeHint);
	}
	function walkNMetadata(node:NMetadata) switch node {
		case PMetadata(name):walkNMetadata_PMetadata(name);
		case PMetadataWithArgs(name, el, parenClose):walkNMetadata_PMetadataWithArgs(name, el, parenClose);
	};
	function walkNExpr_PIs(parenOpen:Token, e:NExpr, _is:Token, path:TypePath, parenClose:Token) {
		walkToken(parenOpen);
		walkNExpr(e);
		walkToken(_is);
		walkTypePath(path);
		walkToken(parenClose);
	}
	function walkNExpr_PWhile(_while:Token, parenOpen:Token, e1:NExpr, parenClose:Token, e2:NExpr) {
		walkToken(_while);
		walkToken(parenOpen);
		walkNExpr(e1);
		walkToken(parenClose);
		walkNExpr(e2);
	}
	function walkNCase_PCase(_case:Token, patterns:CommaSeparated<NExpr>, guard:Null<NGuard>, colon:Token, el:Array<NBlockElement>) {
		walkToken(_case);
		walkNCase_PCase_patterns(patterns);
		if (guard != null) walkNGuard(guard);
		walkToken(colon);
		walkNCase_PCase_el(el);
	}
	function walkNObjectFieldName_PIdent(ident:Token) {
		walkToken(ident);
	}
	function walkNExpr_PReturnExpr(_return:Token, e:NExpr) {
		walkToken(_return);
		walkNExpr(e);
	}
	function walkNExpr_PTry_catches(elems:Array<NCatch>) {
		walkArray(elems, walkNCatch);
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
	function walkNCommonFlag_PPrivate(token:Token) {
		walkToken(token);
	}
	function walkNString_PString(s:Token) {
		walkToken(s);
	}
	function walkNFunction(node:NFunction) {
		if (node.ident != null) walkToken(node.ident);
		if (node.params != null) walkNTypeDeclParameters(node.params);
		walkToken(node.parenOpen);
		if (node.args != null) walkNFunction_args(node.args);
		walkToken(node.parenClose);
		if (node.type != null) walkNTypeHint(node.type);
		walkNExpr(node.e);
	}
	function walkImportMode_IAll(dotstar:Token) {
		walkToken(dotstar);
	}
	function walkClassField(node:ClassField) switch node {
		case Property(annotations, modifiers, varKeyword, name, parenOpen, read, comma, write, parenClose, typeHint, assignment):walkClassField_Property(annotations, modifiers, varKeyword, name, parenOpen, read, comma, write, parenClose, typeHint, assignment);
		case Variable(annotations, modifiers, varKeyword, name, typeHint, assignment, semicolon):walkClassField_Variable(annotations, modifiers, varKeyword, name, typeHint, assignment, semicolon);
		case Function(annotations, modifiers, functionKeyword, name, params, parenOpen, args, parenClose, typeHint, expr):walkClassField_Function(annotations, modifiers, functionKeyword, name, params, parenOpen, args, parenClose, typeHint, expr);
	};
	function walkNExpr_PMacroEscape(ident:Token, braceOpen:Token, e:NExpr, braceClose:Token) {
		walkToken(ident);
		walkToken(braceOpen);
		walkNExpr(e);
		walkToken(braceClose);
	}
	function walkComplexType_PTypePath(path:TypePath) {
		walkTypePath(path);
	}
	function walkNExpr_PReturn(_return:Token) {
		walkToken(_return);
	}
	function walkNExpr_PDollarIdent(ident:Token) {
		walkToken(ident);
	}
	function walkNExprElse(node:NExprElse) {
		walkToken(node._else);
		walkNExpr(node.e);
	}
}