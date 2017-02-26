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
	function walkNPackage(node:NPackage) {
		walkToken(node._package);
		if (node.path != null) walkNPath(node.path);
		walkToken(node.semicolon);
	}
	function walkNBlockElement_PVar_vl(elems:NCommaSeparated<NVarDeclaration>) {
		walkCommaSeparated(elems, function(el) walkNVarDeclaration(el));
	}
	function walkNObjectFieldName_PString(string:NString) {
		walkNString(string);
	}
	function walkNDecl_PClassDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, c:NClassDecl) {
		walkNAnnotations(annotations);
		walkNDecl_PClassDecl_flags(flags);
		walkNClassDecl(c);
	}
	function walkNExpr_PArrayDecl_el(elems:NCommaSeparatedAllowTrailing<NExpr>) {
		walkCommaSeparatedTrailing(elems, function(el) walkNExpr(el));
	}
	function walkNObjectFieldName(node:NObjectFieldName) switch node {
		case PString(string):walkNObjectFieldName_PString(string);
		case PIdent(ident):walkNObjectFieldName_PIdent(ident);
	};
	function walkNDecl_PImportDecl(_import:Token, importPath:NImport, semicolon:Token) {
		walkToken(_import);
		walkNImport(importPath);
		walkToken(semicolon);
	}
	function walkNTypeHint(node:NTypeHint) {
		walkToken(node.colon);
		walkNComplexType(node.type);
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
	function walkNExpr_PDo(_do:Token, e1:NExpr, _while:Token, popen:Token, e2:NExpr, pclose:Token) {
		walkToken(_do);
		walkNExpr(e1);
		walkToken(_while);
		walkToken(popen);
		walkNExpr(e2);
		walkToken(pclose);
	}
	function walkNFieldExpr_PBlockFieldExpr(e:NExpr) {
		walkNExpr(e);
	}
	function walkNMacroExpr_PVar_v(elems:NCommaSeparated<NVarDeclaration>) {
		walkCommaSeparated(elems, function(el) walkNVarDeclaration(el));
	}
	function walkNTypePathParameter_PConstantTypePathParameter(constant:NLiteral) {
		walkNLiteral(constant);
	}
	function walkNDecl_PTypedefDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, _typedef:Token, name:Token, params:Null<NTypeDeclParameters>, assign:Token, type:NComplexType, semicolon:Null<Token>) {
		walkNAnnotations(annotations);
		walkNDecl_PTypedefDecl_flags(flags);
		walkToken(_typedef);
		walkToken(name);
		if (params != null) walkNTypeDeclParameters(params);
		walkToken(assign);
		walkNComplexType(type);
		if (semicolon != null) walkToken(semicolon);
	}
	function walkNEnumFieldArgs(node:NEnumFieldArgs) {
		walkToken(node.popen);
		if (node.args != null) walkNEnumFieldArgs_args(node.args);
		walkToken(node.pclose);
	}
	function walkNPath_idents(elems:Array<NDotIdent>) {
		walkArray(elems, function(el) walkNDotIdent(el));
	}
	function walkNMacroExpr_PClass(c:NClassDecl) {
		walkNClassDecl(c);
	}
	function walkNExpr_PBlock(bropen:Token, elems:Array<NBlockElement>, brclose:Token) {
		walkToken(bropen);
		walkNExpr_PBlock_elems(elems);
		walkToken(brclose);
	}
	function walkNImportMode_PInMode(_in:Token, ident:Token) {
		walkToken(_in);
		walkToken(ident);
	}
	function walkNModifier_PModifierPrivate(token:Token) {
		walkToken(token);
	}
	function walkNClassRelation_PExtends(_extends:Token, path:NTypePath) {
		walkToken(_extends);
		walkNTypePath(path);
	}
	function walkNExpr_PUnsafeCast(_cast:Token, e:NExpr) {
		walkToken(_cast);
		walkNExpr(e);
	}
	function walkNTypePathParameter(node:NTypePathParameter) switch node {
		case PArrayExprTypePathParameter(bkopen, el, bkclose):walkNTypePathParameter_PArrayExprTypePathParameter(bkopen, el, bkclose);
		case PConstantTypePathParameter(constant):walkNTypePathParameter_PConstantTypePathParameter(constant);
		case PTypeTypePathParameter(type):walkNTypePathParameter_PTypeTypePathParameter(type);
	};
	function walkNFile_decls(elems:Array<NDecl>) {
		walkArray(elems, function(el) walkNDecl(el));
	}
	function walkNConst_PConstLiteral(literal:NLiteral) {
		walkNLiteral(literal);
	}
	function walkNExpr_PMetadata(metadata:NMetadata, e:NExpr) {
		walkNMetadata(metadata);
		walkNExpr(e);
	}
	function walkNClassDecl_fields(elems:Array<NClassField>) {
		walkArray(elems, function(el) walkNClassField(el));
	}
	function walkNDotIdent_PDot(_dot:Token) {
		walkToken(_dot);
	}
	function walkNMetadata_PMetadataWithArgs_el(elems:NCommaSeparated<NExpr>) {
		walkCommaSeparated(elems, function(el) walkNExpr(el));
	}
	function walkNAnonymousTypeFields_PAnonymousShortFields(fields:Null<NCommaSeparatedAllowTrailing<NAnonymousTypeField>>) {
		if (fields != null) walkNAnonymousTypeFields_PAnonymousShortFields_fields(fields);
	}
	function walkNClassField_PPropertyField_modifiers(elems:Array<NModifier>) {
		walkArray(elems, function(el) walkNModifier(el));
	}
	function walkNExpr_PSwitch_cases(elems:Array<NCase>) {
		walkArray(elems, function(el) walkNCase(el));
	}
	function walkNExpr_PSafeCast(_cast:Token, popen:Token, e:NExpr, comma:Token, ct:NComplexType, pclose:Token) {
		walkToken(_cast);
		walkToken(popen);
		walkNExpr(e);
		walkToken(comma);
		walkNComplexType(ct);
		walkToken(pclose);
	}
	function walkNExpr(node:NExpr) switch node {
		case PVar(_var, d):walkNExpr_PVar(_var, d);
		case PConst(const):walkNExpr_PConst(const);
		case PDo(_do, e1, _while, popen, e2, pclose):walkNExpr_PDo(_do, e1, _while, popen, e2, pclose);
		case PMacro(_macro, e):walkNExpr_PMacro(_macro, e);
		case PWhile(_while, popen, e1, pclose, e2):walkNExpr_PWhile(_while, popen, e1, pclose, e2);
		case PIntDot(int, dot):walkNExpr_PIntDot(int, dot);
		case PBlock(bropen, elems, brclose):walkNExpr_PBlock(bropen, elems, brclose);
		case PFunction(_function, f):walkNExpr_PFunction(_function, f);
		case PSwitch(_switch, e, bropen, cases, brclose):walkNExpr_PSwitch(_switch, e, bropen, cases, brclose);
		case PReturn(_return):walkNExpr_PReturn(_return);
		case PArrayDecl(bkopen, el, bkclose):walkNExpr_PArrayDecl(bkopen, el, bkclose);
		case PIf(_if, popen, e1, pclose, e2, elseExpr):walkNExpr_PIf(_if, popen, e1, pclose, e2, elseExpr);
		case PReturnExpr(_return, e):walkNExpr_PReturnExpr(_return, e);
		case PArray(e1, bkopen, e2, bkclose):walkNExpr_PArray(e1, bkopen, e2, bkclose);
		case PContinue(_continue):walkNExpr_PContinue(_continue);
		case PParenthesis(popen, e, pclose):walkNExpr_PParenthesis(popen, e, pclose);
		case PTry(_try, e, catches):walkNExpr_PTry(_try, e, catches);
		case PBreak(_break):walkNExpr_PBreak(_break);
		case PCall(e, el):walkNExpr_PCall(e, el);
		case PUnaryPostfix(e, op):walkNExpr_PUnaryPostfix(e, op);
		case PBinop(e1, op, e2):walkNExpr_PBinop(e1, op, e2);
		case PSafeCast(_cast, popen, e, comma, ct, pclose):walkNExpr_PSafeCast(_cast, popen, e, comma, ct, pclose);
		case PUnaryPrefix(op, e):walkNExpr_PUnaryPrefix(op, e);
		case PMacroEscape(ident, bropen, e, brclose):walkNExpr_PMacroEscape(ident, bropen, e, brclose);
		case PIn(e1, _in, e2):walkNExpr_PIn(e1, _in, e2);
		case PMetadata(metadata, e):walkNExpr_PMetadata(metadata, e);
		case PUnsafeCast(_cast, e):walkNExpr_PUnsafeCast(_cast, e);
		case PCheckType(popen, e, colon, type, pclose):walkNExpr_PCheckType(popen, e, colon, type, pclose);
		case PUntyped(_untyped, e):walkNExpr_PUntyped(_untyped, e);
		case PField(e, ident):walkNExpr_PField(e, ident);
		case PIs(popen, e, _is, path, pclose):walkNExpr_PIs(popen, e, _is, path, pclose);
		case PTernary(e1, questionmark, e2, colon, e3):walkNExpr_PTernary(e1, questionmark, e2, colon, e3);
		case PObjectDecl(bropen, fl, brclose):walkNExpr_PObjectDecl(bropen, fl, brclose);
		case PNew(_new, path, el):walkNExpr_PNew(_new, path, el);
		case PThrow(_throw, e):walkNExpr_PThrow(_throw, e);
		case PFor(_for, popen, e1, pclose, e2):walkNExpr_PFor(_for, popen, e1, pclose, e2);
	};
	function walkNCallArgs(node:NCallArgs) {
		walkToken(node.popen);
		if (node.args != null) walkNCallArgs_args(node.args);
		walkToken(node.pclose);
	}
	function walkNEnumFieldArgs_args(elems:NCommaSeparated<NEnumFieldArg>) {
		walkCommaSeparated(elems, function(el) walkNEnumFieldArg(el));
	}
	function walkNConstraints_PMultipleConstraints(colon:Token, popen:Token, types:NCommaSeparated<NComplexType>, pclose:Token) {
		walkToken(colon);
		walkToken(popen);
		walkNConstraints_PMultipleConstraints_types(types);
		walkToken(pclose);
	}
	function walkNExpr_PObjectDecl_fl(elems:NCommaSeparatedAllowTrailing<NObjectField>) {
		walkCommaSeparatedTrailing(elems, function(el) walkNObjectField(el));
	}
	function walkNExpr_PConst(const:NConst) {
		walkNConst(const);
	}
	function walkNExpr_PParenthesis(popen:Token, e:NExpr, pclose:Token) {
		walkToken(popen);
		walkNExpr(e);
		walkToken(pclose);
	}
	function walkNComplexType(node:NComplexType) switch node {
		case PFunctionType(type1, arrow, type2):walkNComplexType_PFunctionType(type1, arrow, type2);
		case PStructuralExtension(bropen, types, fields, brclose):walkNComplexType_PStructuralExtension(bropen, types, fields, brclose);
		case PParenthesisType(popen, ct, pclose):walkNComplexType_PParenthesisType(popen, ct, pclose);
		case PAnonymousStructure(bropen, fields, brclose):walkNComplexType_PAnonymousStructure(bropen, fields, brclose);
		case PTypePath(path):walkNComplexType_PTypePath(path);
		case POptionalType(questionmark, type):walkNComplexType_POptionalType(questionmark, type);
	};
	function walkNComplexType_PStructuralExtension_types(elems:Array<NStructuralExtension>) {
		walkArray(elems, function(el) walkNStructuralExtension(el));
	}
	function walkNMacroExpr_PExpr(e:NExpr) {
		walkNExpr(e);
	}
	function walkNExpr_PBreak(_break:Token) {
		walkToken(_break);
	}
	function walkNDecl_PClassDecl_flags(elems:Array<NCommonFlag>) {
		walkArray(elems, function(el) walkNCommonFlag(el));
	}
	function walkNFile(node:NFile) {
		if (node.pack != null) walkNPackage(node.pack);
		walkNFile_decls(node.decls);
		walkToken(node.eof);
	}
	function walkNModifier_PModifierInline(token:Token) {
		walkToken(token);
	}
	function walkNClassField_PVariableField(annotations:NAnnotations, modifiers:Array<NModifier>, _var:Token, name:Token, typeHint:Null<NTypeHint>, assignment:Null<NAssignment>, semicolon:Token) {
		walkNAnnotations(annotations);
		walkNClassField_PVariableField_modifiers(modifiers);
		walkToken(_var);
		walkToken(name);
		if (typeHint != null) walkNTypeHint(typeHint);
		if (assignment != null) walkNAssignment(assignment);
		walkToken(semicolon);
	}
	function walkNTypeDeclParameters_params(elems:NCommaSeparated<NTypeDeclParameter>) {
		walkCommaSeparated(elems, function(el) walkNTypeDeclParameter(el));
	}
	function walkNMacroExpr_PTypeHint(type:NTypeHint) {
		walkNTypeHint(type);
	}
	function walkNImportMode(node:NImportMode) switch node {
		case PAsMode(_as, ident):walkNImportMode_PAsMode(_as, ident);
		case PNormalMode:{ };
		case PInMode(_in, ident):walkNImportMode_PInMode(_in, ident);
		case PAllMode(dotstar):walkNImportMode_PAllMode(dotstar);
	};
	function walkNExpr_PArrayDecl(bkopen:Token, el:Null<NCommaSeparatedAllowTrailing<NExpr>>, bkclose:Token) {
		walkToken(bkopen);
		if (el != null) walkNExpr_PArrayDecl_el(el);
		walkToken(bkclose);
	}
	function walkNDecl_PAbstractDecl_fields(elems:Array<NClassField>) {
		walkArray(elems, function(el) walkNClassField(el));
	}
	function walkNAssignment(node:NAssignment) {
		walkToken(node.assign);
		walkNExpr(node.e);
	}
	function walkNComplexType_POptionalType(questionmark:Token, type:NComplexType) {
		walkToken(questionmark);
		walkNComplexType(type);
	}
	function walkNComplexType_PAnonymousStructure(bropen:Token, fields:NAnonymousTypeFields, brclose:Token) {
		walkToken(bropen);
		walkNAnonymousTypeFields(fields);
		walkToken(brclose);
	}
	function walkNCase_PDefault_el(elems:Array<NBlockElement>) {
		walkArray(elems, function(el) walkNBlockElement(el));
	}
	function walkNCallArgs_args(elems:NCommaSeparated<NExpr>) {
		walkCommaSeparated(elems, function(el) walkNExpr(el));
	}
	function walkNAbstractRelation(node:NAbstractRelation) switch node {
		case PFrom(_from, type):walkNAbstractRelation_PFrom(_from, type);
		case PTo(_to, type):walkNAbstractRelation_PTo(_to, type);
	};
	function walkNExpr_PObjectDecl(bropen:Token, fl:NCommaSeparatedAllowTrailing<NObjectField>, brclose:Token) {
		walkToken(bropen);
		walkNExpr_PObjectDecl_fl(fl);
		walkToken(brclose);
	}
	function walkNCatch(node:NCatch) {
		walkToken(node._catch);
		walkToken(node.popen);
		walkToken(node.ident);
		walkNTypeHint(node.type);
		walkToken(node.pclose);
		walkNExpr(node.e);
	}
	function walkNAbstractRelation_PTo(_to:Token, type:NComplexType) {
		walkToken(_to);
		walkNComplexType(type);
	}
	function walkNTypeDeclParameter(node:NTypeDeclParameter) {
		walkNAnnotations(node.annotations);
		walkToken(node.name);
		walkNConstraints(node.constraints);
	}
	function walkNExpr_PIntDot(int:Token, dot:Token) {
		walkToken(int);
		walkToken(dot);
	}
	function walkNComplexType_PParenthesisType(popen:Token, ct:NComplexType, pclose:Token) {
		walkToken(popen);
		walkNComplexType(ct);
		walkToken(pclose);
	}
	function walkNModifier(node:NModifier) switch node {
		case PModifierStatic(token):walkNModifier_PModifierStatic(token);
		case PModifierOverride(token):walkNModifier_PModifierOverride(token);
		case PModifierMacro(token):walkNModifier_PModifierMacro(token);
		case PModifierDynamic(token):walkNModifier_PModifierDynamic(token);
		case PModifierInline(token):walkNModifier_PModifierInline(token);
		case PModifierPrivate(token):walkNModifier_PModifierPrivate(token);
		case PModifierPublic(token):walkNModifier_PModifierPublic(token);
	};
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
	function walkNMetadata_PMetadataWithArgs(name:Token, el:NCommaSeparated<NExpr>, pclose:Token) {
		walkToken(name);
		walkNMetadata_PMetadataWithArgs_el(el);
		walkToken(pclose);
	}
	function walkNCommonFlag(node:NCommonFlag) switch node {
		case PExtern(token):walkNCommonFlag_PExtern(token);
		case PPrivate(token):walkNCommonFlag_PPrivate(token);
	};
	function walkNDecl_PUsingDecl(_using:Token, path:NPath, semicolon:Token) {
		walkToken(_using);
		walkNPath(path);
		walkToken(semicolon);
	}
	function walkNModifier_PModifierDynamic(token:Token) {
		walkToken(token);
	}
	function walkNClassField_PFunctionField_modifiers(elems:Array<NModifier>) {
		walkArray(elems, function(el) walkNModifier(el));
	}
	function walkNExpr_PArray(e1:NExpr, bkopen:Token, e2:NExpr, bkclose:Token) {
		walkNExpr(e1);
		walkToken(bkopen);
		walkNExpr(e2);
		walkToken(bkclose);
	}
	function walkNBlockElement_PVar(_var:Token, vl:NCommaSeparated<NVarDeclaration>, semicolon:Token) {
		walkToken(_var);
		walkNBlockElement_PVar_vl(vl);
		walkToken(semicolon);
	}
	function walkNTypePathParameter_PArrayExprTypePathParameter(bkopen:Token, el:Null<NCommaSeparatedAllowTrailing<NExpr>>, bkclose:Token) {
		walkToken(bkopen);
		if (el != null) walkNTypePathParameter_PArrayExprTypePathParameter_el(el);
		walkToken(bkclose);
	}
	function walkNPath(node:NPath) {
		walkToken(node.ident);
		walkNPath_idents(node.idents);
	}
	function walkNAnonymousTypeFields_PAnonymousClassFields_fields(elems:Array<NClassField>) {
		walkArray(elems, function(el) walkNClassField(el));
	}
	function walkNTypePathParameter_PArrayExprTypePathParameter_el(elems:NCommaSeparatedAllowTrailing<NExpr>) {
		walkCommaSeparatedTrailing(elems, function(el) walkNExpr(el));
	}
	function walkNClassField(node:NClassField) switch node {
		case PPropertyField(annotations, modifiers, _var, name, popen, get, comma, set, pclose, typeHint, assignment):walkNClassField_PPropertyField(annotations, modifiers, _var, name, popen, get, comma, set, pclose, typeHint, assignment);
		case PVariableField(annotations, modifiers, _var, name, typeHint, assignment, semicolon):walkNClassField_PVariableField(annotations, modifiers, _var, name, typeHint, assignment, semicolon);
		case PFunctionField(annotations, modifiers, _function, name, params, popen, args, pclose, typeHint, e):walkNClassField_PFunctionField(annotations, modifiers, _function, name, params, popen, args, pclose, typeHint, e);
	};
	function walkNModifier_PModifierOverride(token:Token) {
		walkToken(token);
	}
	function walkNClassRelation(node:NClassRelation) switch node {
		case PExtends(_extends, path):walkNClassRelation_PExtends(_extends, path);
		case PImplements(_implements, path):walkNClassRelation_PImplements(_implements, path);
	};
	function walkNExpr_PContinue(_continue:Token) {
		walkToken(_continue);
	}
	function walkNStructuralExtension(node:NStructuralExtension) {
		walkToken(node.gt);
		walkNTypePath(node.path);
		walkToken(node.comma);
	}
	function walkNVarDeclaration(node:NVarDeclaration) {
		walkToken(node.name);
		if (node.type != null) walkNTypeHint(node.type);
		if (node.assignment != null) walkNAssignment(node.assignment);
	}
	function walkNClassField_PFunctionField(annotations:NAnnotations, modifiers:Array<NModifier>, _function:Token, name:Token, params:Null<NTypeDeclParameters>, popen:Token, args:Null<NCommaSeparated<NFunctionArgument>>, pclose:Token, typeHint:Null<NTypeHint>, e:Null<NFieldExpr>) {
		walkNAnnotations(annotations);
		walkNClassField_PFunctionField_modifiers(modifiers);
		walkToken(_function);
		walkToken(name);
		if (params != null) walkNTypeDeclParameters(params);
		walkToken(popen);
		if (args != null) walkNClassField_PFunctionField_args(args);
		walkToken(pclose);
		if (typeHint != null) walkNTypeHint(typeHint);
		if (e != null) walkNFieldExpr(e);
	}
	function walkNModifier_PModifierStatic(token:Token) {
		walkToken(token);
	}
	function walkNImportMode_PAllMode(dotstar:Token) {
		walkToken(dotstar);
	}
	function walkNObjectField(node:NObjectField) {
		walkNObjectFieldName(node.name);
		walkToken(node.colon);
		walkNExpr(node.e);
	}
	function walkNImport(node:NImport) {
		walkNPath(node.path);
		walkNImportMode(node.mode);
	}
	function walkNLiteral_PLiteralString(s:NString) {
		walkNString(s);
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
		walkArray(elems, function(el) walkNMetadata(el));
	}
	function walkNImportMode_PAsMode(_as:Token, ident:Token) {
		walkToken(_as);
		walkToken(ident);
	}
	function walkNComplexType_PFunctionType(type1:NComplexType, arrow:Token, type2:NComplexType) {
		walkNComplexType(type1);
		walkToken(arrow);
		walkNComplexType(type2);
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
	function walkNDecl_PAbstractDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, _abstract:Token, name:Token, params:Null<NTypeDeclParameters>, underlyingType:Null<NUnderlyingType>, relations:Array<NAbstractRelation>, bropen:Token, fields:Array<NClassField>, brclose:Token) {
		walkNAnnotations(annotations);
		walkNDecl_PAbstractDecl_flags(flags);
		walkToken(_abstract);
		walkToken(name);
		if (params != null) walkNTypeDeclParameters(params);
		if (underlyingType != null) walkNUnderlyingType(underlyingType);
		walkNDecl_PAbstractDecl_relations(relations);
		walkToken(bropen);
		walkNDecl_PAbstractDecl_fields(fields);
		walkToken(brclose);
	}
	function walkNExpr_PFunction(_function:Token, f:NFunction) {
		walkToken(_function);
		walkNFunction(f);
	}
	function walkNCase_PCase_patterns(elems:NCommaSeparated<NExpr>) {
		walkCommaSeparated(elems, function(el) walkNExpr(el));
	}
	function walkNLiteral_PLiteralRegex(token:Token) {
		walkToken(token);
	}
	function walkNExpr_PNew(_new:Token, path:NTypePath, el:NCallArgs) {
		walkToken(_new);
		walkNTypePath(path);
		walkNCallArgs(el);
	}
	function walkNExpr_PThrow(_throw:Token, e:NExpr) {
		walkToken(_throw);
		walkNExpr(e);
	}
	function walkNClassDecl(node:NClassDecl) {
		walkToken(node.kind);
		walkToken(node.name);
		if (node.params != null) walkNTypeDeclParameters(node.params);
		walkNClassDecl_relations(node.relations);
		walkToken(node.bropen);
		walkNClassDecl_fields(node.fields);
		walkToken(node.brclose);
	}
	function walkNConst(node:NConst) switch node {
		case PConstLiteral(literal):walkNConst_PConstLiteral(literal);
		case PConstIdent(ident):walkNConst_PConstIdent(ident);
	};
	function walkNCommonFlag_PExtern(token:Token) {
		walkToken(token);
	}
	function walkNDecl_PEnumDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, _enum:Token, name:Token, params:Null<NTypeDeclParameters>, bropen:Token, fields:Array<NEnumField>, brclose:Token) {
		walkNAnnotations(annotations);
		walkNDecl_PEnumDecl_flags(flags);
		walkToken(_enum);
		walkToken(name);
		if (params != null) walkNTypeDeclParameters(params);
		walkToken(bropen);
		walkNDecl_PEnumDecl_fields(fields);
		walkToken(brclose);
	}
	function walkNTypePathParameters(node:NTypePathParameters) {
		walkToken(node.lt);
		walkNTypePathParameters_parameters(node.parameters);
		walkToken(node.gt);
	}
	function walkNClassField_PVariableField_modifiers(elems:Array<NModifier>) {
		walkArray(elems, function(el) walkNModifier(el));
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
	function walkNDecl_PEnumDecl_flags(elems:Array<NCommonFlag>) {
		walkArray(elems, function(el) walkNCommonFlag(el));
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
		case PMultipleConstraints(colon, popen, types, pclose):walkNConstraints_PMultipleConstraints(colon, popen, types, pclose);
		case PSingleConstraint(colon, type):walkNConstraints_PSingleConstraint(colon, type);
		case PNoConstraints:{ };
	};
	function walkNClassDecl_relations(elems:Array<NClassRelation>) {
		walkArray(elems, function(el) walkNClassRelation(el));
	}
	function walkNCase(node:NCase) switch node {
		case PCase(_case, patterns, guard, colon, el):walkNCase_PCase(_case, patterns, guard, colon, el);
		case PDefault(_default, colon, el):walkNCase_PDefault(_default, colon, el);
	};
	function walkNConstraints_PSingleConstraint(colon:Token, type:NComplexType) {
		walkToken(colon);
		walkNComplexType(type);
	}
	function walkNComplexType_PTypePath(path:NTypePath) {
		walkNTypePath(path);
	}
	function walkNFieldExpr_PExprFieldExpr(e:NExpr, semicolon:Token) {
		walkNExpr(e);
		walkToken(semicolon);
	}
	function walkNDecl_PAbstractDecl_flags(elems:Array<NCommonFlag>) {
		walkArray(elems, function(el) walkNCommonFlag(el));
	}
	function walkNString(node:NString) switch node {
		case PString(s):walkNString_PString(s);
		case PString2(s):walkNString_PString2(s);
	};
	function walkNDecl_PTypedefDecl_flags(elems:Array<NCommonFlag>) {
		walkArray(elems, function(el) walkNCommonFlag(el));
	}
	function walkNAbstractRelation_PFrom(_from:Token, type:NComplexType) {
		walkToken(_from);
		walkNComplexType(type);
	}
	function walkNAnnotations(node:NAnnotations) {
		if (node.doc != null) walkToken(node.doc);
		walkNAnnotations_meta(node.meta);
	}
	function walkNLiteral_PLiteralFloat(token:Token) {
		walkToken(token);
	}
	function walkNExpr_PIf(_if:Token, popen:Token, e1:NExpr, pclose:Token, e2:NExpr, elseExpr:Null<NExprElse>) {
		walkToken(_if);
		walkToken(popen);
		walkNExpr(e1);
		walkToken(pclose);
		walkNExpr(e2);
		if (elseExpr != null) walkNExprElse(elseExpr);
	}
	function walkNDotIdent(node:NDotIdent) switch node {
		case PDotIdent(name):walkNDotIdent_PDotIdent(name);
		case PDot(_dot):walkNDotIdent_PDot(_dot);
	};
	function walkNExpr_PCheckType(popen:Token, e:NExpr, colon:Token, type:NComplexType, pclose:Token) {
		walkToken(popen);
		walkNExpr(e);
		walkToken(colon);
		walkNComplexType(type);
		walkToken(pclose);
	}
	function walkNDecl_PEnumDecl_fields(elems:Array<NEnumField>) {
		walkArray(elems, function(el) walkNEnumField(el));
	}
	function walkNExpr_PUnaryPostfix(e:NExpr, op:Token) {
		walkNExpr(e);
		walkToken(op);
	}
	function walkNFieldExpr_PNoFieldExpr(semicolon:Token) {
		walkToken(semicolon);
	}
	function walkNTypePathParameter_PTypeTypePathParameter(type:NComplexType) {
		walkNComplexType(type);
	}
	function walkNTypePathParameters_parameters(elems:NCommaSeparated<NTypePathParameter>) {
		walkCommaSeparated(elems, function(el) walkNTypePathParameter(el));
	}
	function walkNExpr_PMacro(_macro:Token, e:NMacroExpr) {
		walkToken(_macro);
		walkNMacroExpr(e);
	}
	function walkNModifier_PModifierPublic(token:Token) {
		walkToken(token);
	}
	function walkNExpr_PBlock_elems(elems:Array<NBlockElement>) {
		walkArray(elems, function(el) walkNBlockElement(el));
	}
	function walkNFunction_args(elems:NCommaSeparated<NFunctionArgument>) {
		walkCommaSeparated(elems, function(el) walkNFunctionArgument(el));
	}
	function walkNModifier_PModifierMacro(token:Token) {
		walkToken(token);
	}
	function walkNConstraints_PMultipleConstraints_types(elems:NCommaSeparated<NComplexType>) {
		walkCommaSeparated(elems, function(el) walkNComplexType(el));
	}
	function walkNLiteral_PLiteralInt(token:Token) {
		walkToken(token);
	}
	function walkNBlockElement_PInlineFunction(_inline:Token, _function:Token, f:NFunction, semicolon:Token) {
		walkToken(_inline);
		walkToken(_function);
		walkNFunction(f);
		walkToken(semicolon);
	}
	function walkNCase_PCase_el(elems:Array<NBlockElement>) {
		walkArray(elems, function(el) walkNBlockElement(el));
	}
	function walkNExpr_PIn(e1:NExpr, _in:Token, e2:NExpr) {
		walkNExpr(e1);
		walkToken(_in);
		walkNExpr(e2);
	}
	function walkNClassField_PPropertyField(annotations:NAnnotations, modifiers:Array<NModifier>, _var:Token, name:Token, popen:Token, get:Token, comma:Token, set:Token, pclose:Token, typeHint:Null<NTypeHint>, assignment:Null<NAssignment>) {
		walkNAnnotations(annotations);
		walkNClassField_PPropertyField_modifiers(modifiers);
		walkToken(_var);
		walkToken(name);
		walkToken(popen);
		walkToken(get);
		walkToken(comma);
		walkToken(set);
		walkToken(pclose);
		if (typeHint != null) walkNTypeHint(typeHint);
		if (assignment != null) walkNAssignment(assignment);
	}
	function walkNAnonymousTypeFields_PAnonymousClassFields(fields:Array<NClassField>) {
		walkNAnonymousTypeFields_PAnonymousClassFields_fields(fields);
	}
	function walkNAnonymousTypeField(node:NAnonymousTypeField) {
		if (node.questionmark != null) walkToken(node.questionmark);
		walkToken(node.name);
		walkNTypeHint(node.typeHint);
	}
	function walkNUnderlyingType(node:NUnderlyingType) {
		walkToken(node.popen);
		walkNComplexType(node.type);
		walkToken(node.pclose);
	}
	function walkNGuard(node:NGuard) {
		walkToken(node._if);
		walkToken(node.popen);
		walkNExpr(node.e);
		walkToken(node.pclose);
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
	function walkNDecl(node:NDecl) switch node {
		case PClassDecl(annotations, flags, c):walkNDecl_PClassDecl(annotations, flags, c);
		case PTypedefDecl(annotations, flags, _typedef, name, params, assign, type, semicolon):walkNDecl_PTypedefDecl(annotations, flags, _typedef, name, params, assign, type, semicolon);
		case PUsingDecl(_using, path, semicolon):walkNDecl_PUsingDecl(_using, path, semicolon);
		case PImportDecl(_import, importPath, semicolon):walkNDecl_PImportDecl(_import, importPath, semicolon);
		case PAbstractDecl(annotations, flags, _abstract, name, params, underlyingType, relations, bropen, fields, brclose):walkNDecl_PAbstractDecl(annotations, flags, _abstract, name, params, underlyingType, relations, bropen, fields, brclose);
		case PEnumDecl(annotations, flags, _enum, name, params, bropen, fields, brclose):walkNDecl_PEnumDecl(annotations, flags, _enum, name, params, bropen, fields, brclose);
	};
	function walkNBlockElement(node:NBlockElement) switch node {
		case PVar(_var, vl, semicolon):walkNBlockElement_PVar(_var, vl, semicolon);
		case PExpr(e, semicolon):walkNBlockElement_PExpr(e, semicolon);
		case PInlineFunction(_inline, _function, f, semicolon):walkNBlockElement_PInlineFunction(_inline, _function, f, semicolon);
	};
	function walkNExpr_PSwitch(_switch:Token, e:NExpr, bropen:Token, cases:Array<NCase>, brclose:Token) {
		walkToken(_switch);
		walkNExpr(e);
		walkToken(bropen);
		walkNExpr_PSwitch_cases(cases);
		walkToken(brclose);
	}
	function walkNExpr_PField(e:NExpr, ident:NDotIdent) {
		walkNExpr(e);
		walkNDotIdent(ident);
	}
	function walkNExpr_PFor(_for:Token, popen:Token, e1:NExpr, pclose:Token, e2:NExpr) {
		walkToken(_for);
		walkToken(popen);
		walkNExpr(e1);
		walkToken(pclose);
		walkNExpr(e2);
	}
	function walkNEnumFieldArg(node:NEnumFieldArg) {
		if (node.questionmark != null) walkToken(node.questionmark);
		walkToken(node.name);
		walkNTypeHint(node.typeHint);
	}
	function walkNMetadata(node:NMetadata) switch node {
		case PMetadata(name):walkNMetadata_PMetadata(name);
		case PMetadataWithArgs(name, el, pclose):walkNMetadata_PMetadataWithArgs(name, el, pclose);
	};
	function walkNClassRelation_PImplements(_implements:Token, path:NTypePath) {
		walkToken(_implements);
		walkNTypePath(path);
	}
	function walkNTypePath(node:NTypePath) {
		walkNPath(node.path);
		if (node.params != null) walkNTypePathParameters(node.params);
	}
	function walkNExpr_PIs(popen:Token, e:NExpr, _is:Token, path:NTypePath, pclose:Token) {
		walkToken(popen);
		walkNExpr(e);
		walkToken(_is);
		walkNTypePath(path);
		walkToken(pclose);
	}
	function walkNExpr_PWhile(_while:Token, popen:Token, e1:NExpr, pclose:Token, e2:NExpr) {
		walkToken(_while);
		walkToken(popen);
		walkNExpr(e1);
		walkToken(pclose);
		walkNExpr(e2);
	}
	function walkNCase_PCase(_case:Token, patterns:NCommaSeparated<NExpr>, guard:Null<NGuard>, colon:Token, el:Array<NBlockElement>) {
		walkToken(_case);
		walkNCase_PCase_patterns(patterns);
		if (guard != null) walkNGuard(guard);
		walkToken(colon);
		walkNCase_PCase_el(el);
	}
	function walkNObjectFieldName_PIdent(ident:Token) {
		walkToken(ident);
	}
	function walkNDecl_PAbstractDecl_relations(elems:Array<NAbstractRelation>) {
		walkArray(elems, function(el) walkNAbstractRelation(el));
	}
	function walkNExpr_PReturnExpr(_return:Token, e:NExpr) {
		walkToken(_return);
		walkNExpr(e);
	}
	function walkNExpr_PTry_catches(elems:Array<NCatch>) {
		walkArray(elems, function(el) walkNCatch(el));
	}
	function walkNMacroExpr_PVar(_var:Token, v:NCommaSeparated<NVarDeclaration>) {
		walkToken(_var);
		walkNMacroExpr_PVar_v(v);
	}
	function walkNAnonymousTypeFields(node:NAnonymousTypeFields) switch node {
		case PAnonymousClassFields(fields):walkNAnonymousTypeFields_PAnonymousClassFields(fields);
		case PAnonymousShortFields(fields):walkNAnonymousTypeFields_PAnonymousShortFields(fields);
	};
	function walkNAnonymousTypeFields_PAnonymousShortFields_fields(elems:NCommaSeparatedAllowTrailing<NAnonymousTypeField>) {
		walkCommaSeparatedTrailing(elems, function(el) walkNAnonymousTypeField(el));
	}
	function walkNCommonFlag_PPrivate(token:Token) {
		walkToken(token);
	}
	function walkNString_PString(s:Token) {
		walkToken(s);
	}
	function walkNClassField_PFunctionField_args(elems:NCommaSeparated<NFunctionArgument>) {
		walkCommaSeparated(elems, function(el) walkNFunctionArgument(el));
	}
	function walkNFunction(node:NFunction) {
		if (node.ident != null) walkToken(node.ident);
		if (node.params != null) walkNTypeDeclParameters(node.params);
		walkToken(node.popen);
		if (node.args != null) walkNFunction_args(node.args);
		walkToken(node.pclose);
		if (node.type != null) walkNTypeHint(node.type);
		walkNExpr(node.e);
	}
	function walkNExpr_PMacroEscape(ident:Token, bropen:Token, e:NExpr, brclose:Token) {
		walkToken(ident);
		walkToken(bropen);
		walkNExpr(e);
		walkToken(brclose);
	}
	function walkNExpr_PReturn(_return:Token) {
		walkToken(_return);
	}
	function walkNComplexType_PStructuralExtension(bropen:Token, types:Array<NStructuralExtension>, fields:NAnonymousTypeFields, brclose:Token) {
		walkToken(bropen);
		walkNComplexType_PStructuralExtension_types(types);
		walkNAnonymousTypeFields(fields);
		walkToken(brclose);
	}
	function walkNExprElse(node:NExprElse) {
		walkToken(node._else);
		walkNExpr(node.e);
	}
}