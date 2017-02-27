// This file is autogenerated from ParseTree data structures
// Use build-walker.hxml to re-generate!

package hxParser;

import hxParser.ParseTree;

enum NodeKind {
	AbstractRelation_From(fromKeyword:Token, type:ComplexType);
	AbstractRelation_To(toKeyword:Token, type:ComplexType);
	ClassDecl(node:ClassDecl);
	ClassField_Function(annotations:NAnnotations, modifiers:Array<FieldModifier>, functionKeyword:Token, name:Token, params:Null<NTypeDeclParameters>, parenOpen:Token, args:Null<CommaSeparated<NFunctionArgument>>, parenClose:Token, typeHint:Null<NTypeHint>, expr:Null<NFieldExpr>);
	ClassField_Property(annotations:NAnnotations, modifiers:Array<FieldModifier>, varKeyword:Token, name:Token, parenOpen:Token, read:Token, comma:Token, write:Token, parenClose:Token, typeHint:Null<NTypeHint>, assignment:Null<NAssignment>);
	ClassField_Variable(annotations:NAnnotations, modifiers:Array<FieldModifier>, varKeyword:Token, name:Token, typeHint:Null<NTypeHint>, assignment:Null<NAssignment>, semicolon:Token);
	ClassRelation_Extends(extendsKeyword:Token, path:TypePath);
	ClassRelation_Implements(implementsKeyword:Token, path:TypePath);
	ComplexType_PAnonymousStructure(braceOpen:Token, fields:NAnonymousTypeFields, braceClose:Token);
	ComplexType_PFunctionType(type1:ComplexType, arrow:Token, type2:ComplexType);
	ComplexType_POptionalType(questionmark:Token, type:ComplexType);
	ComplexType_PParenthesisType(parenOpen:Token, ct:ComplexType, parenClose:Token);
	ComplexType_PStructuralExtension(braceOpen:Token, types:Array<NStructuralExtension>, fields:NAnonymousTypeFields, braceClose:Token);
	ComplexType_PTypePath(path:TypePath);
	Decl_AbstractDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, abstractKeyword:Token, name:Token, params:Null<NTypeDeclParameters>, underlyingType:Null<NUnderlyingType>, relations:Array<AbstractRelation>, braceOpen:Token, fields:Array<ClassField>, braceClose:Token);
	Decl_ClassDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, classDecl:ClassDecl);
	Decl_EnumDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, enumKeyword:Token, name:Token, params:Null<NTypeDeclParameters>, braceOpen:Token, fields:Array<NEnumField>, braceClose:Token);
	Decl_ImportDecl(importKeyword:Token, path:NPath, mode:ImportMode, semicolon:Token);
	Decl_TypedefDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, typedefKeyword:Token, name:Token, params:Null<NTypeDeclParameters>, assign:Token, type:ComplexType, semicolon:Null<Token>);
	Decl_UsingDecl(usingKeyword:Token, path:NPath, semicolon:Token);
	FieldModifier_Dynamic(keyword:Token);
	FieldModifier_Inline(keyword:Token);
	FieldModifier_Macro(keyword:Token);
	FieldModifier_Override(keyword:Token);
	FieldModifier_Private(keyword:Token);
	FieldModifier_Public(keyword:Token);
	FieldModifier_Static(keyword:Token);
	File(node:File);
	ImportMode_IAll(dotstar:Token);
	ImportMode_IAs(asKeyword:Token, ident:Token);
	ImportMode_IIn(inKeyword:Token, ident:Token);
	NAnnotations(node:NAnnotations);
	NAnonymousTypeField(node:NAnonymousTypeField);
	NAnonymousTypeFields_PAnonymousClassFields(fields:Array<ClassField>);
	NAnonymousTypeFields_PAnonymousShortFields(fields:Null<CommaSeparatedAllowTrailing<NAnonymousTypeField>>);
	NAssignment(node:NAssignment);
	NBlockElement_PExpr(e:NExpr, semicolon:Token);
	NBlockElement_PInlineFunction(_inline:Token, _function:Token, f:NFunction, semicolon:Token);
	NBlockElement_PVar(_var:Token, vl:CommaSeparated<NVarDeclaration>, semicolon:Token);
	NCallArgs(node:NCallArgs);
	NCase_PCase(_case:Token, patterns:CommaSeparated<NExpr>, guard:Null<NGuard>, colon:Token, el:Array<NBlockElement>);
	NCase_PDefault(_default:Token, colon:Token, el:Array<NBlockElement>);
	NCatch(node:NCatch);
	NCommonFlag_PExtern(token:Token);
	NCommonFlag_PPrivate(token:Token);
	NConst_PConstIdent(ident:Token);
	NConst_PConstLiteral(literal:NLiteral);
	NConstraints_PMultipleConstraints(colon:Token, parenOpen:Token, types:CommaSeparated<ComplexType>, parenClose:Token);
	NConstraints_PSingleConstraint(colon:Token, type:ComplexType);
	NDotIdent_PDot(_dot:Token);
	NDotIdent_PDotIdent(name:Token);
	NEnumField(node:NEnumField);
	NEnumFieldArg(node:NEnumFieldArg);
	NEnumFieldArgs(node:NEnumFieldArgs);
	NExprElse(node:NExprElse);
	NExpr_PArray(e1:NExpr, bracketOpen:Token, e2:NExpr, bracketClose:Token);
	NExpr_PArrayDecl(bracketOpen:Token, el:Null<CommaSeparatedAllowTrailing<NExpr>>, bracketClose:Token);
	NExpr_PBinop(e1:NExpr, op:Token, e2:NExpr);
	NExpr_PBlock(braceOpen:Token, elems:Array<NBlockElement>, braceClose:Token);
	NExpr_PBreak(_break:Token);
	NExpr_PCall(e:NExpr, el:NCallArgs);
	NExpr_PCheckType(parenOpen:Token, e:NExpr, colon:Token, type:ComplexType, parenClose:Token);
	NExpr_PConst(const:NConst);
	NExpr_PContinue(_continue:Token);
	NExpr_PDo(_do:Token, e1:NExpr, _while:Token, parenOpen:Token, e2:NExpr, parenClose:Token);
	NExpr_PDollarIdent(ident:Token);
	NExpr_PField(e:NExpr, ident:NDotIdent);
	NExpr_PFor(_for:Token, parenOpen:Token, e1:NExpr, parenClose:Token, e2:NExpr);
	NExpr_PFunction(_function:Token, f:NFunction);
	NExpr_PIf(_if:Token, parenOpen:Token, e1:NExpr, parenClose:Token, e2:NExpr, elseExpr:Null<NExprElse>);
	NExpr_PIn(e1:NExpr, _in:Token, e2:NExpr);
	NExpr_PIntDot(int:Token, dot:Token);
	NExpr_PIs(parenOpen:Token, e:NExpr, _is:Token, path:TypePath, parenClose:Token);
	NExpr_PMacro(_macro:Token, e:NMacroExpr);
	NExpr_PMacroEscape(ident:Token, braceOpen:Token, e:NExpr, braceClose:Token);
	NExpr_PMetadata(metadata:NMetadata, e:NExpr);
	NExpr_PNew(_new:Token, path:TypePath, el:NCallArgs);
	NExpr_PObjectDecl(braceOpen:Token, fl:CommaSeparatedAllowTrailing<NObjectField>, braceClose:Token);
	NExpr_PParenthesis(parenOpen:Token, e:NExpr, parenClose:Token);
	NExpr_PReturn(_return:Token);
	NExpr_PReturnExpr(_return:Token, e:NExpr);
	NExpr_PSafeCast(_cast:Token, parenOpen:Token, e:NExpr, comma:Token, ct:ComplexType, parenClose:Token);
	NExpr_PSwitch(_switch:Token, e:NExpr, braceOpen:Token, cases:Array<NCase>, braceClose:Token);
	NExpr_PTernary(e1:NExpr, questionmark:Token, e2:NExpr, colon:Token, e3:NExpr);
	NExpr_PThrow(_throw:Token, e:NExpr);
	NExpr_PTry(_try:Token, e:NExpr, catches:Array<NCatch>);
	NExpr_PUnaryPostfix(e:NExpr, op:Token);
	NExpr_PUnaryPrefix(op:Token, e:NExpr);
	NExpr_PUnsafeCast(_cast:Token, e:NExpr);
	NExpr_PUntyped(_untyped:Token, e:NExpr);
	NExpr_PVar(_var:Token, d:NVarDeclaration);
	NExpr_PWhile(_while:Token, parenOpen:Token, e1:NExpr, parenClose:Token, e2:NExpr);
	NFieldExpr_PBlockFieldExpr(e:NExpr);
	NFieldExpr_PExprFieldExpr(e:NExpr, semicolon:Token);
	NFieldExpr_PNoFieldExpr(semicolon:Token);
	NFunction(node:NFunction);
	NFunctionArgument(node:NFunctionArgument);
	NGuard(node:NGuard);
	NLiteral_PLiteralFloat(token:Token);
	NLiteral_PLiteralInt(token:Token);
	NLiteral_PLiteralRegex(token:Token);
	NLiteral_PLiteralString(s:NString);
	NMacroExpr_PClass(c:ClassDecl);
	NMacroExpr_PExpr(e:NExpr);
	NMacroExpr_PTypeHint(type:NTypeHint);
	NMacroExpr_PVar(_var:Token, v:CommaSeparated<NVarDeclaration>);
	NMetadata_PMetadata(name:Token);
	NMetadata_PMetadataWithArgs(name:Token, el:CommaSeparated<NExpr>, parenClose:Token);
	NObjectField(node:NObjectField);
	NObjectFieldName_PIdent(ident:Token);
	NObjectFieldName_PString(string:NString);
	NPath(node:NPath);
	NString_PString(s:Token);
	NString_PString2(s:Token);
	NStructuralExtension(node:NStructuralExtension);
	NTypeDeclParameter(node:NTypeDeclParameter);
	NTypeDeclParameters(node:NTypeDeclParameters);
	NTypeHint(node:NTypeHint);
	NTypePathParameter_PArrayExprTypePathParameter(bracketOpen:Token, el:Null<CommaSeparatedAllowTrailing<NExpr>>, bracketClose:Token);
	NTypePathParameter_PConstantTypePathParameter(constant:NLiteral);
	NTypePathParameter_PTypeTypePathParameter(type:ComplexType);
	NTypePathParameters(node:NTypePathParameters);
	NUnderlyingType(node:NUnderlyingType);
	NVarDeclaration(node:NVarDeclaration);
	Package(node:Package);
	TypePath(node:TypePath);
}