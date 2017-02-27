// This file is autogenerated from ParseTree data structures
// Use build-walker.hxml to re-generate!

package hxParser;

import hxParser.ParseTree;

enum NodeKind {
	AbstractRelation_From(fromKeyword:Token, type:ComplexType);
	AbstractRelation_To(toKeyword:Token, type:ComplexType);
	CallArgs(node:CallArgs);
	Catch(node:Catch);
	ClassDecl(node:ClassDecl);
	ClassField_Function(annotations:NAnnotations, modifiers:Array<FieldModifier>, functionKeyword:Token, name:Token, params:Null<TypeDeclParameters>, parenOpen:Token, args:Null<CommaSeparated<NFunctionArgument>>, parenClose:Token, typeHint:Null<TypeHint>, expr:Null<NFieldExpr>);
	ClassField_Property(annotations:NAnnotations, modifiers:Array<FieldModifier>, varKeyword:Token, name:Token, parenOpen:Token, read:Token, comma:Token, write:Token, parenClose:Token, typeHint:Null<TypeHint>, assignment:Null<NAssignment>, semicolon:Token);
	ClassField_Variable(annotations:NAnnotations, modifiers:Array<FieldModifier>, varKeyword:Token, name:Token, typeHint:Null<TypeHint>, assignment:Null<NAssignment>, semicolon:Token);
	ClassRelation_Extends(extendsKeyword:Token, path:TypePath);
	ClassRelation_Implements(implementsKeyword:Token, path:TypePath);
	ComplexType_PAnonymousStructure(braceOpen:Token, fields:NAnonymousTypeFields, braceClose:Token);
	ComplexType_PFunctionType(type1:ComplexType, arrow:Token, type2:ComplexType);
	ComplexType_POptionalType(questionmark:Token, type:ComplexType);
	ComplexType_PParenthesisType(parenOpen:Token, ct:ComplexType, parenClose:Token);
	ComplexType_PStructuralExtension(braceOpen:Token, types:Array<NStructuralExtension>, fields:NAnonymousTypeFields, braceClose:Token);
	ComplexType_PTypePath(path:TypePath);
	Decl_AbstractDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, abstractKeyword:Token, name:Token, params:Null<TypeDeclParameters>, underlyingType:Null<NUnderlyingType>, relations:Array<AbstractRelation>, braceOpen:Token, fields:Array<ClassField>, braceClose:Token);
	Decl_ClassDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, classDecl:ClassDecl);
	Decl_EnumDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, enumKeyword:Token, name:Token, params:Null<TypeDeclParameters>, braceOpen:Token, fields:Array<NEnumField>, braceClose:Token);
	Decl_ImportDecl(importKeyword:Token, path:NPath, mode:ImportMode, semicolon:Token);
	Decl_TypedefDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, typedefKeyword:Token, name:Token, params:Null<TypeDeclParameters>, assign:Token, type:ComplexType, semicolon:Null<Token>);
	Decl_UsingDecl(usingKeyword:Token, path:NPath, semicolon:Token);
	ExprElse(node:ExprElse);
	Expr_EArrayAccess(expr:Expr, bracketOpen:Token, exprKey:Expr, bracketClose:Token);
	Expr_EArrayDecl(bracketOpen:Token, el:Null<CommaSeparatedAllowTrailing<Expr>>, bracketClose:Token);
	Expr_EBinop(exprLeft:Expr, op:Token, exprRight:Expr);
	Expr_EBlock(braceOpen:Token, elems:Array<NBlockElement>, braceClose:Token);
	Expr_EBreak(breakKeyword:Token);
	Expr_ECall(expr:Expr, args:CallArgs);
	Expr_ECheckType(parenOpen:Token, e:Expr, colon:Token, type:ComplexType, parenClose:Token);
	Expr_EConst(const:NConst);
	Expr_EContinue(continueKeyword:Token);
	Expr_EDo(doKeyword:Token, exprBody:Expr, whileKeyword:Token, parenOpen:Token, exprCond:Expr, parenClose:Token);
	Expr_EDollarIdent(ident:Token);
	Expr_EField(expr:Expr, ident:NDotIdent);
	Expr_EFor(forKeyword:Token, parenOpen:Token, exprIter:Expr, parenClose:Token, exprBody:Expr);
	Expr_EFunction(functionKeyword:Token, fun:NFunction);
	Expr_EIf(ifKeyword:Token, parenOpen:Token, exprCond:Expr, parenClose:Token, exprThen:Expr, exprElse:Null<ExprElse>);
	Expr_EIn(exprLeft:Expr, inKeyword:Token, exprRight:Expr);
	Expr_EIntDot(int:Token, dot:Token);
	Expr_EIs(parenOpen:Token, expr:Expr, isKeyword:Token, path:TypePath, parenClose:Token);
	Expr_EMacro(macroKeyword:Token, expr:NMacroExpr);
	Expr_EMacroEscape(ident:Token, braceOpen:Token, expr:Expr, braceClose:Token);
	Expr_EMetadata(metadata:NMetadata, expr:Expr);
	Expr_ENew(newKeyword:Token, path:TypePath, args:CallArgs);
	Expr_EObjectDecl(braceOpen:Token, fields:CommaSeparatedAllowTrailing<ObjectField>, braceClose:Token);
	Expr_EParenthesis(parenOpen:Token, e:Expr, parenClose:Token);
	Expr_EReturn(returnKeyword:Token);
	Expr_EReturnExpr(returnKeyword:Token, expr:Expr);
	Expr_ESafeCast(castKeyword:Token, parenOpen:Token, expr:Expr, comma:Token, type:ComplexType, parenClose:Token);
	Expr_ESwitch(switchKeyword:Token, expr:Expr, braceOpen:Token, cases:Array<NCase>, braceClose:Token);
	Expr_ETernary(exprCond:Expr, questionmark:Token, exprThen:Expr, colon:Token, exprElse:Expr);
	Expr_EThrow(throwKeyword:Token, expr:Expr);
	Expr_ETry(tryKeyword:Token, expr:Expr, catches:Array<Catch>);
	Expr_EUnaryPostfix(expr:Expr, op:Token);
	Expr_EUnaryPrefix(op:Token, expr:Expr);
	Expr_EUnsafeCast(castKeyword:Token, expr:Expr);
	Expr_EUntyped(untypedKeyword:Token, expr:Expr);
	Expr_EVar(varKeyword:Token, decl:NVarDeclaration);
	Expr_EWhile(whileKeyword:Token, parenOpen:Token, exprCond:Expr, parenClose:Token, exprBody:Expr);
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
	NBlockElement_PExpr(e:Expr, semicolon:Token);
	NBlockElement_PInlineFunction(_inline:Token, _function:Token, f:NFunction, semicolon:Token);
	NBlockElement_PVar(_var:Token, vl:CommaSeparated<NVarDeclaration>, semicolon:Token);
	NCase_PCase(_case:Token, patterns:CommaSeparated<Expr>, guard:Null<NGuard>, colon:Token, el:Array<NBlockElement>);
	NCase_PDefault(_default:Token, colon:Token, el:Array<NBlockElement>);
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
	NFieldExpr_PBlockFieldExpr(e:Expr);
	NFieldExpr_PExprFieldExpr(e:Expr, semicolon:Token);
	NFieldExpr_PNoFieldExpr(semicolon:Token);
	NFunction(node:NFunction);
	NFunctionArgument(node:NFunctionArgument);
	NGuard(node:NGuard);
	NLiteral_PLiteralFloat(token:Token);
	NLiteral_PLiteralInt(token:Token);
	NLiteral_PLiteralRegex(token:Token);
	NLiteral_PLiteralString(s:NString);
	NMacroExpr_PClass(c:ClassDecl);
	NMacroExpr_PExpr(e:Expr);
	NMacroExpr_PTypeHint(typeHint:TypeHint);
	NMacroExpr_PVar(_var:Token, v:CommaSeparated<NVarDeclaration>);
	NMetadata_PMetadata(name:Token);
	NMetadata_PMetadataWithArgs(name:Token, el:CommaSeparated<Expr>, parenClose:Token);
	NPath(node:NPath);
	NString_PString(s:Token);
	NString_PString2(s:Token);
	NStructuralExtension(node:NStructuralExtension);
	NTypePathParameter_PArrayExprTypePathParameter(bracketOpen:Token, el:Null<CommaSeparatedAllowTrailing<Expr>>, bracketClose:Token);
	NTypePathParameter_PConstantTypePathParameter(constant:NLiteral);
	NTypePathParameter_PTypeTypePathParameter(type:ComplexType);
	NTypePathParameters(node:NTypePathParameters);
	NUnderlyingType(node:NUnderlyingType);
	NVarDeclaration(node:NVarDeclaration);
	ObjectField(node:ObjectField);
	ObjectFieldName_NIdent(ident:Token);
	ObjectFieldName_NString(string:NString);
	Package(node:Package);
	TypeDeclParameter(node:TypeDeclParameter);
	TypeDeclParameters(node:TypeDeclParameters);
	TypeHint(node:TypeHint);
	TypePath(node:TypePath);
}