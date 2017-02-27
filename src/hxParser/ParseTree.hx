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

typedef NCommaSeparated<T> = { args:Array<{arg:T, comma:Token}>, arg:T }

typedef NCommaSeparatedAllowTrailing<T> = { args:Array<{arg:T, comma:Token}>, arg:T, ?comma:Token }

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
	?ident:Token, ?params:NTypeDeclParameters, popen:Token, ?args:NCommaSeparated<NFunctionArgument>, pclose:Token, ?type:NTypeHint, e:NExpr
}

typedef NVarDeclaration = {
	name:Token, ?type:NTypeHint, ?assignment:NAssignment
}

enum NMacroExpr {
	PTypeHint(type:NTypeHint);
	PVar(_var:Token, v:NCommaSeparated<NVarDeclaration>);
	PClass(c:NClassDecl);
	PExpr(e:NExpr);
}

typedef NExprElse = {
	_else:Token, e:NExpr
}

typedef NCatch = {
	_catch:Token, popen:Token, ident:Token, type:NTypeHint, pclose:Token, e:NExpr
}

typedef NGuard = {
	_if:Token, popen:Token, e:NExpr, pclose:Token
}

enum NBlockElement {
	PVar(_var:Token, vl:NCommaSeparated<NVarDeclaration>, semicolon:Token);
	PInlineFunction(_inline:Token, _function:Token, f:NFunction, semicolon:Token);
	PExpr(e:NExpr, semicolon:Token);
}

enum NCase {
	PCase(_case:Token, patterns:NCommaSeparated<NExpr>, ?guard:NGuard, colon:Token, el:Array<NBlockElement>);
	PDefault(_default:Token, colon:Token, el:Array<NBlockElement>);
}

enum NExpr {
	PVar(_var:Token, d:NVarDeclaration);
	PMetadata(metadata:NMetadata, e:NExpr);
	PMacro(_macro:Token, e:NMacroExpr);
	PThrow(_throw:Token, e:NExpr);
	PIf(_if:Token, popen:Token, e1:NExpr, pclose:Token, e2:NExpr, ?elseExpr:NExprElse);
	PReturn(_return:Token);
	PReturnExpr(_return:Token, e:NExpr);
	PBreak(_break:Token);
	PContinue(_continue:Token);
	PDo(_do:Token, e1:NExpr, _while:Token, popen:Token, e2:NExpr, pclose:Token);
	PTry(_try:Token, e:NExpr, catches:Array<NCatch>);
	PSwitch(_switch:Token, e:NExpr, bropen:Token, cases:Array<NCase>, brclose:Token);
	PFor(_for:Token, popen:Token, e1:NExpr, pclose:Token, e2:NExpr);
	PWhile(_while:Token, popen:Token, e1:NExpr, pclose:Token, e2:NExpr);
	PUntyped(_untyped:Token, e:NExpr);
	PObjectDecl(bropen:Token, fl:NCommaSeparatedAllowTrailing<NObjectField>, brclose:Token);
	PConst(const:NConst);
	PUnsafeCast(_cast:Token, e:NExpr);
	PSafeCast(_cast:Token, popen:Token, e:NExpr, comma:Token, ct:NComplexType, pclose:Token);
	PNew(_new:Token, path:NTypePath, el:NCallArgs);
	PParenthesis(popen:Token, e:NExpr, pclose:Token);
	PCheckType(popen:Token, e:NExpr, colon:Token, type:NComplexType, pclose:Token);
	PIs(popen:Token, e:NExpr, _is:Token, path:NTypePath, pclose:Token);
	PArrayDecl(bkopen:Token, ?el:NCommaSeparatedAllowTrailing<NExpr>, bkclose:Token);
	PFunction(_function:Token, f:NFunction);
	PUnaryPrefix(op:Token, e:NExpr);
	PField(e:NExpr, ident:NDotIdent);
	PCall(e:NExpr, el:NCallArgs);
	PArray(e1:NExpr, bkopen:Token, e2:NExpr, bkclose:Token);
	PUnaryPostfix(e:NExpr, op:Token);
	PBinop(e1:NExpr, op:Token, e2:NExpr);
	PTernary(e1:NExpr, questionmark:Token, e2:NExpr, colon:Token, e3:NExpr);
	PIn(e1:NExpr, _in:Token, e2:NExpr);
	PIntDot(int:Token, dot:Token);
	PDollarIdent(ident:Token);
	PMacroEscape(ident:Token, bropen:Token, e:NExpr, brclose:Token);
	PBlock(bropen:Token, elems:Array<NBlockElement>, brclose:Token);
}

typedef NCallArgs = {
	popen:Token, ?args:NCommaSeparated<NExpr>, pclose:Token
}

enum NMetadata {
	PMetadata(name:Token);
	PMetadataWithArgs(name:Token, el:NCommaSeparated<NExpr>, pclose:Token);
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
	gt:Token, path:NTypePath, comma:Token
}

enum NLiteral {
	PLiteralString(s:NString);
	PLiteralInt(token:Token);
	PLiteralFloat(token:Token);
	PLiteralRegex(token:Token);
}

enum NTypePathParameter {
	PArrayExprTypePathParameter(bkopen:Token, ?el:NCommaSeparatedAllowTrailing<NExpr>, bkclose:Token);
	PTypeTypePathParameter(type:NComplexType);
	PConstantTypePathParameter(constant:NLiteral);
}

typedef NTypePathParameters = {
	lt:Token, parameters:NCommaSeparated<NTypePathParameter>, gt:Token
}

typedef NTypePath = {
	path:NPath, ?params:NTypePathParameters
}

enum NModifier {
	PModifierStatic(token:Token);
	PModifierMacro(token:Token);
	PModifierPublic(token:Token);
	PModifierPrivate(token:Token);
	PModifierOverride(token:Token);
	PModifierDynamic(token:Token);
	PModifierInline(token:Token);
}

typedef NTypeHint = {
	colon:Token, type:NComplexType
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

enum NClassField {
	PFunctionField(annotations:NAnnotations, modifiers:Array<NModifier>, _function:Token, name:Token, ?params:NTypeDeclParameters, popen:Token, ?args:NCommaSeparated<NFunctionArgument>, pclose:Token, ?typeHint:NTypeHint, ?e:NFieldExpr);
	PVariableField(annotations:NAnnotations, modifiers:Array<NModifier>, _var:Token, name:Token, ?typeHint:NTypeHint, ?assignment:NAssignment, semicolon:Token);
	PPropertyField(annotations:NAnnotations, modifiers:Array<NModifier>, _var:Token, name:Token, popen:Token, get:Token, comma:Token, set:Token, pclose:Token, ?typeHint:NTypeHint, ?assignment:NAssignment);
}

typedef NAnonymousTypeField = {
	?questionmark:Token, name:Token, typeHint:NTypeHint
}

enum NAnonymousTypeFields {
	PAnonymousClassFields(fields:Array<NClassField>);
	PAnonymousShortFields(?fields:NCommaSeparatedAllowTrailing<NAnonymousTypeField>);
}

typedef NEnumFieldArg = {
	?questionmark:Token, name:Token, typeHint:NTypeHint
}

typedef NEnumFieldArgs = {
	popen:Token, ?args:NCommaSeparated<NEnumFieldArg>, pclose:Token
}

typedef NEnumField = {
	annotations:NAnnotations, name:Token, ?params:NTypeDeclParameters, ?args:NEnumFieldArgs, ?type:NTypeHint, semicolon:Token
}

enum NComplexType {
	PParenthesisType(popen:Token, ct:NComplexType, pclose:Token);
	PStructuralExtension(bropen:Token, types:Array<NStructuralExtension>, fields:NAnonymousTypeFields, brclose:Token);
	PAnonymousStructure(bropen:Token, fields:NAnonymousTypeFields, brclose:Token);
	POptionalType(questionmark:Token, type:NComplexType);
	PTypePath(path:NTypePath);
	PFunctionType(type1:NComplexType, arrow:Token, type2:NComplexType);
}

enum NConstraints {
	PMultipleConstraints(colon:Token, popen:Token, types:NCommaSeparated<NComplexType>, pclose:Token);
	PSingleConstraint(colon:Token, type:NComplexType);
	PNoConstraints;
}

enum NClassRelation {
	PExtends(_extends:Token, path:NTypePath);
	PImplements(_implements:Token, path:NTypePath);
}

typedef NUnderlyingType = {
	popen:Token, type:NComplexType, pclose:Token
}

enum NAbstractRelation {
	PTo(_to:Token, type:NComplexType);
	PFrom(_from:Token, type:NComplexType);
}

typedef NTypeDeclParameter = {
	annotations:NAnnotations, name:Token, constraints:NConstraints
}

typedef NTypeDeclParameters = {
	lt:Token, params:NCommaSeparated<NTypeDeclParameter>, gt:Token
}

enum NImportMode {
	PInMode(_in:Token, ident:Token);
	PAsMode(_as:Token, ident:Token);
	PAllMode(dotstar:Token);
	PNormalMode;
}

typedef NImport = {
	path:NPath, mode:NImportMode
}

typedef NClassDecl = {
	kind:Token, name:Token, ?params:NTypeDeclParameters, relations:Array<NClassRelation>, bropen:Token, fields:Array<NClassField>, brclose:Token
}

enum NDecl {
	PImportDecl(_import:Token, importPath:NImport, semicolon:Token);
	PUsingDecl(_using:Token, path:NPath, semicolon:Token);
	PClassDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, c:NClassDecl);
	PEnumDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, _enum:Token, name:Token, ?params:NTypeDeclParameters, bropen:Token, fields:Array<NEnumField>, brclose:Token);
	PTypedefDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, _typedef:Token, name:Token, ?params:NTypeDeclParameters, assign:Token, type:NComplexType, ?semicolon:Token);
	PAbstractDecl(annotations:NAnnotations, flags:Array<NCommonFlag>, _abstract:Token, name:Token, ?params:NTypeDeclParameters, ?underlyingType:NUnderlyingType, relations:Array<NAbstractRelation>, bropen:Token, fields:Array<NClassField>, brclose:Token);
}

typedef NPackage = {
	_package:Token, ?path:NPath, semicolon:Token
}

typedef NFile = {
	?pack:NPackage, decls:Array<NDecl>, eof:Token
}
