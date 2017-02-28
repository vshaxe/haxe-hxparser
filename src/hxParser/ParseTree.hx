package hxParser;

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

enum StringToken {
	DoubleQuote(token:Token);
	SingleQuote(token:Token);
}

enum ObjectFieldName {
	NIdent(ident:Token);
	NString(string:StringToken);
}

typedef ObjectField = {
	name:ObjectFieldName, colon:Token, expr:Expr
}

enum NConst {
	PConstIdent(ident:Token);
	PConstLiteral(literal:Literal);
}

typedef Function = {
	?name:Token, ?params:TypeDeclParameters, parenOpen:Token, ?args:CommaSeparated<FunctionArgument>, parenClose:Token, ?typeHint:TypeHint, expr:Expr
}

typedef VarDecl = {
	name:Token, ?typeHint:TypeHint, ?assignment:Assignment
}

enum NMacroExpr {
	PTypeHint(typeHint:TypeHint);
	PVar(_var:Token, v:CommaSeparated<VarDecl>);
	PClass(c:ClassDecl);
	PExpr(e:Expr);
}

typedef ExprElse = {
	elseKeyword:Token, expr:Expr
}

typedef Catch = {
	catchKeyword:Token, parenOpen:Token, ident:Token, typeHint:TypeHint, parenClose:Token, expr:Expr
}

typedef NGuard = {
	_if:Token, parenOpen:Token, e:Expr, parenClose:Token
}

enum NBlockElement {
	PVar(_var:Token, vl:CommaSeparated<VarDecl>, semicolon:Token);
	PInlineFunction(_inline:Token, _function:Token, f:Function, semicolon:Token);
	PExpr(e:Expr, semicolon:Token);
}

enum NCase {
	PCase(_case:Token, patterns:CommaSeparated<Expr>, ?guard:NGuard, colon:Token, el:Array<NBlockElement>);
	PDefault(_default:Token, colon:Token, el:Array<NBlockElement>);
}

enum Expr {
	EVar(varKeyword:Token, decl:VarDecl);
	EMetadata(metadata:NMetadata, expr:Expr);
	EMacro(macroKeyword:Token, expr:NMacroExpr);
	EThrow(throwKeyword:Token, expr:Expr);
	EIf(ifKeyword:Token, parenOpen:Token, exprCond:Expr, parenClose:Token, exprThen:Expr, ?exprElse:ExprElse);
	EReturn(returnKeyword:Token);
	EReturnExpr(returnKeyword:Token, expr:Expr);
	EBreak(breakKeyword:Token);
	EContinue(continueKeyword:Token);
	EDo(doKeyword:Token, exprBody:Expr, whileKeyword:Token, parenOpen:Token, exprCond:Expr, parenClose:Token);
	ETry(tryKeyword:Token, expr:Expr, catches:Array<Catch>);
	ESwitch(switchKeyword:Token, expr:Expr, braceOpen:Token, cases:Array<NCase>, braceClose:Token);
	EFor(forKeyword:Token, parenOpen:Token, exprIter:Expr, parenClose:Token, exprBody:Expr);
	EWhile(whileKeyword:Token, parenOpen:Token, exprCond:Expr, parenClose:Token, exprBody:Expr);
	EUntyped(untypedKeyword:Token, expr:Expr);
	EObjectDecl(braceOpen:Token, fields:CommaSeparatedAllowTrailing<ObjectField>, braceClose:Token);
	EConst(const:NConst);
	EUnsafeCast(castKeyword:Token, expr:Expr);
	ESafeCast(castKeyword:Token, parenOpen:Token, expr:Expr, comma:Token, type:ComplexType, parenClose:Token);
	ENew(newKeyword:Token, path:TypePath, args:CallArgs);
	EParenthesis(parenOpen:Token, expr:Expr, parenClose:Token);
	ECheckType(parenOpen:Token, expr:Expr, colon:Token, type:ComplexType, parenClose:Token);
	EIs(parenOpen:Token, expr:Expr, isKeyword:Token, path:TypePath, parenClose:Token);
	EArrayDecl(bracketOpen:Token, ?elems:CommaSeparatedAllowTrailing<Expr>, bracketClose:Token);
	EFunction(functionKeyword:Token, fun:Function);
	EUnaryPrefix(op:Token, expr:Expr);
	EField(expr:Expr, ident:NDotIdent);
	ECall(expr:Expr, args:CallArgs);
	EArrayAccess(expr:Expr, bracketOpen:Token, exprKey:Expr, bracketClose:Token);
	EUnaryPostfix(expr:Expr, op:Token);
	EBinop(exprLeft:Expr, op:Token, exprRight:Expr);
	ETernary(exprCond:Expr, questionmark:Token, exprThen:Expr, colon:Token, exprElse:Expr);
	EIn(exprLeft:Expr, inKeyword:Token, exprRight:Expr);
	EIntDot(int:Token, dot:Token);
	EDollarIdent(ident:Token);
	EMacroEscape(ident:Token, braceOpen:Token, expr:Expr, braceClose:Token);
	EBlock(braceOpen:Token, elems:Array<NBlockElement>, braceClose:Token);
}

typedef CallArgs = {
	parenOpen:Token, ?args:CommaSeparated<Expr>, parenClose:Token
}

enum NMetadata {
	PMetadata(name:Token);
	PMetadataWithArgs(name:Token, el:CommaSeparated<Expr>, parenClose:Token);
}

typedef NAnnotations = {
	?doc:Token, metadata:Array<NMetadata>
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

enum Literal {
	PLiteralString(s:StringToken);
	PLiteralInt(token:Token);
	PLiteralFloat(token:Token);
	PLiteralRegex(token:Token);
}

enum TypePathParameter {
	ArrayExpr(bracketOpen:Token, ?elems:CommaSeparatedAllowTrailing<Expr>, bracketClose:Token);
	Type(type:ComplexType);
	Literal(literal:Literal);
}

typedef TypePathParameters = {
	lt:Token, params:CommaSeparated<TypePathParameter>, gt:Token
}

typedef TypePath = {
	path:NPath, ?params:TypePathParameters
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

typedef TypeHint = {
	colon:Token, type:ComplexType
}

typedef Assignment = {
	assign:Token, expr:Expr
}

enum NFieldExpr {
	PNoFieldExpr(semicolon:Token);
	PBlockFieldExpr(e:Expr);
	PExprFieldExpr(e:Expr, semicolon:Token);
}

typedef FunctionArgument = {
	annotations:NAnnotations, ?questionmark:Token, name:Token, ?typeHint:TypeHint, ?assignment:Assignment
}

enum ClassField {
	Function(annotations:NAnnotations, modifiers:Array<FieldModifier>, functionKeyword:Token, name:Token, ?params:TypeDeclParameters, parenOpen:Token, ?args:CommaSeparated<FunctionArgument>, parenClose:Token, ?typeHint:TypeHint, ?expr:NFieldExpr);
	Variable(annotations:NAnnotations, modifiers:Array<FieldModifier>, varKeyword:Token, name:Token, ?typeHint:TypeHint, ?assignment:Assignment, semicolon:Token);
	Property(annotations:NAnnotations, modifiers:Array<FieldModifier>, varKeyword:Token, name:Token, parenOpen:Token, read:Token, comma:Token, write:Token, parenClose:Token, ?typeHint:TypeHint, ?assignment:Assignment, semicolon:Token);
}

typedef NAnonymousTypeField = {
	?questionmark:Token, name:Token, typeHint:TypeHint
}

enum NAnonymousTypeFields {
	PAnonymousClassFields(fields:Array<ClassField>);
	PAnonymousShortFields(?fields:CommaSeparatedAllowTrailing<NAnonymousTypeField>);
}

typedef NEnumFieldArg = {
	?questionmark:Token, name:Token, typeHint:TypeHint
}

typedef NEnumFieldArgs = {
	parenOpen:Token, ?args:CommaSeparated<NEnumFieldArg>, parenClose:Token
}

typedef NEnumField = {
	annotations:NAnnotations, name:Token, ?params:TypeDeclParameters, ?args:NEnumFieldArgs, ?typeHint:TypeHint, semicolon:Token
}

enum ComplexType {
	PParenthesisType(parenOpen:Token, ct:ComplexType, parenClose:Token);
	PStructuralExtension(braceOpen:Token, types:Array<NStructuralExtension>, fields:NAnonymousTypeFields, braceClose:Token);
	PAnonymousStructure(braceOpen:Token, fields:NAnonymousTypeFields, braceClose:Token);
	POptionalType(questionmark:Token, type:ComplexType);
	PTypePath(path:TypePath);
	PFunctionType(type1:ComplexType, arrow:Token, type2:ComplexType);
}

enum Constraints {
	Multiple(colon:Token, parenOpen:Token, types:CommaSeparated<ComplexType>, parenClose:Token);
	Single(colon:Token, type:ComplexType);
	None;
}

enum ClassRelation {
	Extends(extendsKeyword:Token, path:TypePath);
	Implements(implementsKeyword:Token, path:TypePath);
}

typedef UnderlyingType = {
	parenOpen:Token, type:ComplexType, parenClose:Token
}

enum AbstractRelation {
	To(toKeyword:Token, type:ComplexType);
	From(fromKeyword:Token, type:ComplexType);
}

typedef TypeDeclParameter = {
	annotations:NAnnotations, name:Token, constraints:Constraints
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
	AbstractDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, abstractKeyword:Token, name:Token, ?params:TypeDeclParameters, ?underlyingType:UnderlyingType, relations:Array<AbstractRelation>, braceOpen:Token, fields:Array<ClassField>, braceClose:Token);
}

typedef Package = {
	packageKeyword:Token, ?path:NPath, semicolon:Token
}

typedef File = {
	?pack:Package, decls:Array<Decl>, eof:Token
}
