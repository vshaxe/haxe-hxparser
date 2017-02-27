package hxParser;

// this is the new parse tree

class Trivia {
	public var text:String;
	public var start:Int;
	public var end:Int;

	public function new(text, start, end) {
		this.text = text;
		this.start = start;
		this.end = end;
	}

	public static function fromJTrivia(jtrivia:hxParser.JResult.JPlacedToken):Trivia {
		return new Trivia(jtrivia.token, jtrivia.start, jtrivia.end);
	}

	@:keep
	public function toString() return '${haxe.Json.stringify(text)} [$start..$end)';
}

class Token {
	public var text:String;
	public var start:Int;
	public var end:Int;
	public var leadingTrivia:Array<Trivia>;
	public var trailingTrivia:Array<Trivia>;
	public var implicit:Bool;
	public var inserted:Bool;

	public function new(text, start, end) {
		this.text = text;
		this.start = start;
		this.end = end;
		implicit = false;
		inserted = false;
	}

	public static function fromJToken(jtoken:hxParser.JResult.JToken):Token {
		var token = new Token(jtoken.token, jtoken.start, jtoken.end);
		if (jtoken.trivia != null) {
			if (jtoken.trivia.implicit != null) token.implicit = jtoken.trivia.implicit;
			if (jtoken.trivia.inserted != null) token.inserted = jtoken.trivia.inserted;
			if (jtoken.trivia.leading != null) token.leadingTrivia = jtoken.trivia.leading.map(Trivia.fromJTrivia);
			if (jtoken.trivia.trailing != null) token.trailingTrivia = jtoken.trivia.trailing.map(Trivia.fromJTrivia);
		}
		return token;
	}

	@:keep
	public function toString() return '$text [$start..$end)';
}

typedef CommaSeparated<T> = { args:Array<{arg:T, comma:Token}>, arg:T }

typedef CommaSeparatedAllowTrailing<T> = { args:Array<{arg:T, comma:Token}>, arg:T, ?comma:Token }

enum NDotIdent {
	PDotIdent(name:Token);
	PDot(_dot:Token);
}

enum NString {
	PString(s:Token);
	PString2(s:Token);
}

enum NObjectFieldName {
	PIdent(ident:Token);
	PString(string:NString);
}

typedef NObjectField = {
	name:NObjectFieldName, colon:Token, e:NExpr
}

enum NConst {
	PConstIdent(ident:Token);
	PConstLiteral(literal:NLiteral);
}

typedef NFunction = {
	?ident:Token, ?params:TypeDeclParameters, parenOpen:Token, ?args:CommaSeparated<NFunctionArgument>, parenClose:Token, ?type:NTypeHint, e:NExpr
}

typedef NVarDeclaration = {
	name:Token, ?type:NTypeHint, ?assignment:NAssignment
}

enum NMacroExpr {
	PTypeHint(type:NTypeHint);
	PVar(_var:Token, v:CommaSeparated<NVarDeclaration>);
	PClass(c:ClassDecl);
	PExpr(e:NExpr);
}

typedef NExprElse = {
	_else:Token, e:NExpr
}

typedef NCatch = {
	_catch:Token, parenOpen:Token, ident:Token, type:NTypeHint, parenClose:Token, e:NExpr
}

typedef NGuard = {
	_if:Token, parenOpen:Token, e:NExpr, parenClose:Token
}

enum NBlockElement {
	PVar(_var:Token, vl:CommaSeparated<NVarDeclaration>, semicolon:Token);
	PInlineFunction(_inline:Token, _function:Token, f:NFunction, semicolon:Token);
	PExpr(e:NExpr, semicolon:Token);
}

enum NCase {
	PCase(_case:Token, patterns:CommaSeparated<NExpr>, ?guard:NGuard, colon:Token, el:Array<NBlockElement>);
	PDefault(_default:Token, colon:Token, el:Array<NBlockElement>);
}

enum NExpr {
	PVar(_var:Token, d:NVarDeclaration);
	PMetadata(metadata:NMetadata, e:NExpr);
	PMacro(_macro:Token, e:NMacroExpr);
	PThrow(_throw:Token, e:NExpr);
	PIf(_if:Token, parenOpen:Token, e1:NExpr, parenClose:Token, e2:NExpr, ?elseExpr:NExprElse);
	PReturn(_return:Token);
	PReturnExpr(_return:Token, e:NExpr);
	PBreak(_break:Token);
	PContinue(_continue:Token);
	PDo(_do:Token, e1:NExpr, _while:Token, parenOpen:Token, e2:NExpr, parenClose:Token);
	PTry(_try:Token, e:NExpr, catches:Array<NCatch>);
	PSwitch(_switch:Token, e:NExpr, braceOpen:Token, cases:Array<NCase>, braceClose:Token);
	PFor(_for:Token, parenOpen:Token, e1:NExpr, parenClose:Token, e2:NExpr);
	PWhile(_while:Token, parenOpen:Token, e1:NExpr, parenClose:Token, e2:NExpr);
	PUntyped(_untyped:Token, e:NExpr);
	PObjectDecl(braceOpen:Token, fl:CommaSeparatedAllowTrailing<NObjectField>, braceClose:Token);
	PConst(const:NConst);
	PUnsafeCast(_cast:Token, e:NExpr);
	PSafeCast(_cast:Token, parenOpen:Token, e:NExpr, comma:Token, ct:ComplexType, parenClose:Token);
	PNew(_new:Token, path:TypePath, el:NCallArgs);
	PParenthesis(parenOpen:Token, e:NExpr, parenClose:Token);
	PCheckType(parenOpen:Token, e:NExpr, colon:Token, type:ComplexType, parenClose:Token);
	PIs(parenOpen:Token, e:NExpr, _is:Token, path:TypePath, parenClose:Token);
	PArrayDecl(bracketOpen:Token, ?el:CommaSeparatedAllowTrailing<NExpr>, bracketClose:Token);
	PFunction(_function:Token, f:NFunction);
	PUnaryPrefix(op:Token, e:NExpr);
	PField(e:NExpr, ident:NDotIdent);
	PCall(e:NExpr, el:NCallArgs);
	PArray(e1:NExpr, bracketOpen:Token, e2:NExpr, bracketClose:Token);
	PUnaryPostfix(e:NExpr, op:Token);
	PBinop(e1:NExpr, op:Token, e2:NExpr);
	PTernary(e1:NExpr, questionmark:Token, e2:NExpr, colon:Token, e3:NExpr);
	PIn(e1:NExpr, _in:Token, e2:NExpr);
	PIntDot(int:Token, dot:Token);
	PDollarIdent(ident:Token);
	PMacroEscape(ident:Token, braceOpen:Token, e:NExpr, braceClose:Token);
	PBlock(braceOpen:Token, elems:Array<NBlockElement>, braceClose:Token);
}

typedef NCallArgs = {
	parenOpen:Token, ?args:CommaSeparated<NExpr>, parenClose:Token
}

enum NMetadata {
	PMetadata(name:Token);
	PMetadataWithArgs(name:Token, el:CommaSeparated<NExpr>, parenClose:Token);
}

typedef NAnnotations = {
	?doc:Token, meta:Array<NMetadata>
}

typedef NPath = {
	ident:Token, idents:Array<NDotIdent>
}

enum NCommonFlag {
	PPrivate(token:Token);
	PExtern(token:Token);
}

typedef NStructuralExtension = {
	gt:Token, path:TypePath, comma:Token
}

enum NLiteral {
	PLiteralString(s:NString);
	PLiteralInt(token:Token);
	PLiteralFloat(token:Token);
	PLiteralRegex(token:Token);
}

enum NTypePathParameter {
	PArrayExprTypePathParameter(bracketOpen:Token, ?el:CommaSeparatedAllowTrailing<NExpr>, bracketClose:Token);
	PTypeTypePathParameter(type:ComplexType);
	PConstantTypePathParameter(constant:NLiteral);
}

typedef NTypePathParameters = {
	lt:Token, parameters:CommaSeparated<NTypePathParameter>, gt:Token
}

typedef TypePath = {
	path:NPath, ?params:NTypePathParameters
}

enum FieldModifier {
	Static(keyword:Token);
	Macro(keyword:Token);
	Public(keyword:Token);
	Private(keyword:Token);
	Override(keyword:Token);
	Dynamic(keyword:Token);
	Inline(keyword:Token);
}

typedef NTypeHint = {
	colon:Token, type:ComplexType
}

typedef NAssignment = {
	assign:Token, e:NExpr
}

enum NFieldExpr {
	PNoFieldExpr(semicolon:Token);
	PBlockFieldExpr(e:NExpr);
	PExprFieldExpr(e:NExpr, semicolon:Token);
}

typedef NFunctionArgument = {
	annotations:NAnnotations, ?questionmark:Token, name:Token, ?typeHint:NTypeHint, ?assignment:NAssignment
}

enum ClassField {
	Function(annotations:NAnnotations, modifiers:Array<FieldModifier>, functionKeyword:Token, name:Token, ?params:TypeDeclParameters, parenOpen:Token, ?args:CommaSeparated<NFunctionArgument>, parenClose:Token, ?typeHint:NTypeHint, ?expr:NFieldExpr);
	Variable(annotations:NAnnotations, modifiers:Array<FieldModifier>, varKeyword:Token, name:Token, ?typeHint:NTypeHint, ?assignment:NAssignment, semicolon:Token);
	Property(annotations:NAnnotations, modifiers:Array<FieldModifier>, varKeyword:Token, name:Token, parenOpen:Token, read:Token, comma:Token, write:Token, parenClose:Token, ?typeHint:NTypeHint, ?assignment:NAssignment, semicolon:Token);
}

typedef NAnonymousTypeField = {
	?questionmark:Token, name:Token, typeHint:NTypeHint
}

enum NAnonymousTypeFields {
	PAnonymousClassFields(fields:Array<ClassField>);
	PAnonymousShortFields(?fields:CommaSeparatedAllowTrailing<NAnonymousTypeField>);
}

typedef NEnumFieldArg = {
	?questionmark:Token, name:Token, typeHint:NTypeHint
}

typedef NEnumFieldArgs = {
	parenOpen:Token, ?args:CommaSeparated<NEnumFieldArg>, parenClose:Token
}

typedef NEnumField = {
	annotations:NAnnotations, name:Token, ?params:TypeDeclParameters, ?args:NEnumFieldArgs, ?type:NTypeHint, semicolon:Token
}

enum ComplexType {
	PParenthesisType(parenOpen:Token, ct:ComplexType, parenClose:Token);
	PStructuralExtension(braceOpen:Token, types:Array<NStructuralExtension>, fields:NAnonymousTypeFields, braceClose:Token);
	PAnonymousStructure(braceOpen:Token, fields:NAnonymousTypeFields, braceClose:Token);
	POptionalType(questionmark:Token, type:ComplexType);
	PTypePath(path:TypePath);
	PFunctionType(type1:ComplexType, arrow:Token, type2:ComplexType);
}

enum NConstraints {
	PMultipleConstraints(colon:Token, parenOpen:Token, types:CommaSeparated<ComplexType>, parenClose:Token);
	PSingleConstraint(colon:Token, type:ComplexType);
	PNoConstraints;
}

enum ClassRelation {
	Extends(extendsKeyword:Token, path:TypePath);
	Implements(implementsKeyword:Token, path:TypePath);
}

typedef NUnderlyingType = {
	parenOpen:Token, type:ComplexType, parenClose:Token
}

enum AbstractRelation {
	To(toKeyword:Token, type:ComplexType);
	From(fromKeyword:Token, type:ComplexType);
}

typedef TypeDeclParameter = {
	annotations:NAnnotations, name:Token, constraints:NConstraints
}

typedef TypeDeclParameters = {
	lt:Token, params:CommaSeparated<TypeDeclParameter>, gt:Token
}

enum ImportMode {
	IIn(inKeyword:Token, ident:Token);
	IAs(asKeyword:Token, ident:Token);
	IAll(dotstar:Token);
	INormal;
}

typedef ClassDecl = {
	kind:Token,
	name:Token,
	?params:TypeDeclParameters,
	relations:Array<ClassRelation>,
	braceOpen:Token,
	fields:Array<ClassField>,
	braceClose:Token
}

enum Decl {
	ImportDecl(importKeyword:Token, path:NPath, mode:ImportMode, semicolon:Token);
	UsingDecl(usingKeyword:Token, path:NPath, semicolon:Token);
	ClassDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, classDecl:ClassDecl);
	EnumDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, enumKeyword:Token, name:Token, ?params:TypeDeclParameters, braceOpen:Token, fields:Array<NEnumField>, braceClose:Token);
	TypedefDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, typedefKeyword:Token, name:Token, ?params:TypeDeclParameters, assign:Token, type:ComplexType, ?semicolon:Token);
	AbstractDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, abstractKeyword:Token, name:Token, ?params:TypeDeclParameters, ?underlyingType:NUnderlyingType, relations:Array<AbstractRelation>, braceOpen:Token, fields:Array<ClassField>, braceClose:Token);
}

typedef Package = {
	packageKeyword:Token, ?path:NPath, semicolon:Token
}

typedef File = {
	?pack:Package, decls:Array<Decl>, eof:Token
}
