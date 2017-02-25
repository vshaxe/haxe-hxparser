package hxParser;

import hxParser.JResult;
import hxParser.ParseTree;
using hxParser.Converter.JNodeTools;
using StringTools;

class JNodeTools {
	public static function asNode(j:JNodeBase, name:String):JNode {
		if (j.name != name) throw "expected " + name + ", got " + j;
		return cast j;
	}

	public static function asToken(j:JNodeBase):JToken {
		if (j.name != "token") throw "expected token, got " + j;
		return cast j;
	}

	public static inline function convertToToken(token:JToken):Token {
		return Token.fromJToken(token);
	}

	public static inline function toToken(j:JNodeBase):Token {
		return convertToToken(asToken(j));
	}
}

class Converter {
	public static function convertResult(root:JResult):NFile {
		return convertFile(root.document.tree.asNode("tree").sub[0].asNode("file"));
	}

	static function convertFile(node:JNode):NFile {
		var decls = node.sub[1];
		var decls = if (decls != null) decls.asNode("decls").sub.map(convertDecl) else [];
		var eof = node.sub[2].toToken();

		var result:NFile = {
			decls: decls,
			eof: eof,
		};
		var packNode = node.sub[0];
		if (packNode != null)
			result.pack = convertPack(packNode);

		return result;
	}

	static function convertPack(node:JNodeBase):NPackage {
		var node = node.asNode("package");

		var pack:NPackage = {
			_package: node.sub[0].toToken(),
			semicolon: node.sub[2].toToken(),
		};

		var pathNode = node.sub[1];
		if (pathNode != null)
			pack.path = convertPath(pathNode);

		return pack;
	}

	static function convertPath(node:JNodeBase):NPath {
		var node = node.asNode("path");
		var first = convertDollarIdent(node.sub[0]);
		var rest = node.sub.slice(1).map(convertDotIdent);
		return {
			ident: first,
			idents: rest,
		}
	}

	static function convertDotIdent(node:JNodeBase):NDotIdent {
		var name = node.asNode("dot_ident").sub[0].toToken();
		return PDotIdent(name);
	}

	static inline function convertDollarIdent(node:JNodeBase):Token {
		return convertIdent(node.asNode("dollar_ident").sub[0]);
	}

	static inline function convertIdent(node:JNodeBase):Token {
		return node.asNode("ident").sub[0].toToken();
	}

	static function convertAnnotations(node:JNodeBase):NAnnotations {
		if (node == null)
			return {meta: []};

		var node = node.asNode("annotations");
		var doc = node.sub[0]; // TODO: what next?
		var meta = node.sub[1].asNode("metadatas").sub.map(convertMeta);
		var result:NAnnotations = {
			meta: meta,
		};
		return result;
	}

	static function convertMeta(node:JNodeBase):NMetadata {
		var node = node.asNode("metadata");
		return switch (node.sub) {
			case [tok]:
				PMetadata(tok.toToken());
			case [tok, exprs, pclose]:
				var el = commaSeparated(exprs.asNode("exprs").sub, convertExpr);
				PMetadataWithArgs(tok.toToken(), el, pclose.toToken());
			case unknown:
				throw 'Unknown metadata format: ${haxe.Json.stringify(unknown)}';
		}
	}

	static function convertFlags(node:JNodeBase):Array<NCommonFlag> {
		if (node == null)
			return [];
		return node.asNode("flags").sub.map(function(node) {
			var tok = node.asNode("common_flags").sub[0].asToken();
			return switch (tok.token) {
				case "extern": PExtern(tok.convertToToken());
				case "private": PPrivate(tok.convertToToken());
				case unknown:
					throw "Unknown common flag " + unknown;
			}
		});
	}

	static function convertTypeParameter(node:JNodeBase):NTypePathParameter {
		var node:JNode = cast node;
		return switch (node.name) {
			case "complex_type":
				PTypeTypePathParameter(convertComplexType(node));
			case "literal":
				PConstantTypePathParameter(convertLiteral(node.sub[0]));
			case "bracket":
				var elems = commaSeparatedTrailing(node.sub[1].asNode("elements").sub, convertExpr);
				PArrayExprTypePathParameter(node.sub[0].toToken(), elems, node.sub[2].toToken());
			case unknown:
				throw 'Unknown type parameter type: $unknown';
		}
	}

	static function convertTypePath(node:JNodeBase):NTypePath {
		var node = node.asNode("type_path");
		var result:NTypePath = {path: convertPath(node.sub[0])};

		var tparams = node.sub[1];
		if (tparams != null) {
			var tparams = tparams.asNode("type_path_parameters");
			result.params = {
				lt: tparams.sub[0].toToken(),
				parameters: commaSeparated(tparams.sub[1].asNode("params").sub, convertTypeParameter),
				gt: tparams.sub[2].toToken(),
			};
		}

		return result;
	}

	static function convertClassRelation(node:JNodeBase):NClassRelation {
		var node = node.asNode("class_relations");
		var token = node.sub[0].asToken();
		return switch (token.token)  {
			case "extends":
				PExtends(token.convertToToken(), convertTypePath(node.sub[1]));
			case "implements":
				PImplements(token.convertToToken(), convertTypePath(node.sub[1]));
			case unknown:
				throw 'Unknown class relation type $unknown';
		}
	}

	static function convertClassField(node:JNodeBase):NClassField {
		return switch (node.name) {
			case "variable_field":
				convertVar(node);
			case "function_field":
				convertMethod(node);
			case "property_field":
				convertProperty(node);
			case unknown:
				throw 'Unknown class field type: $unknown';
		}
	}

	static function convertModifiers(node:JNodeBase):Array<NModifier> {
		if (node == null)
			return [];
		return node.asNode("modifiers").sub.map(function(node) {
			var token = node.asToken();
			return switch (token.token) {
				case "static": PModifierStatic(token.convertToToken());
				case "macro": PModifierMacro(token.convertToToken());
				case "public": PModifierPublic(token.convertToToken());
				case "private": PModifierPrivate(token.convertToToken());
				case "override": PModifierOverride(token.convertToToken());
				case "dynamic": PModifierDynamic(token.convertToToken());
				case "inline": PModifierInline(token.convertToToken());
				case unknown: throw 'Unknown modifier token: $unknown';
			}
		});
	}

	static function convertAnonymousFields(node:JNodeBase):NAnonymousTypeFields {
		if (node == null)
			return PAnonymousShortFields(null);
		var node:JNode = cast node;
		return switch (node.name) {
			case "class_fields":
				PAnonymousClassFields(node.sub.map(convertClassField));
			case "short_fields":
				function convertAnonField(node:JNodeBase):NAnonymousTypeField {
					var node = node.asNode("anonymous_type_field");
					var result:NAnonymousTypeField = cast {
						name: convertDollarIdent(node.sub[1]),
						colon: node.sub[2].toToken(),
						type: convertComplexType(node.sub[3]),
					};
					var questionMark = node.sub[0];
					if (questionMark != null)
						result.questionmark = questionMark.toToken();
					return result;
				}
				PAnonymousShortFields(commaSeparatedTrailing(node.sub, convertAnonField));
			case unknown:
				throw 'Unknown anonymous fields notation: $unknown';
		}
	}

	static function convertComplexType(node:JNodeBase):NComplexType {
		var node:JNode = cast node.asNode("complex_type").sub[0];
		return switch (node.name) {
			case "path":
				PTypePath(convertTypePath(node.sub[0]));

			case "anonymous":
				PAnoymousStructure(node.sub[0].toToken(), convertAnonymousFields(node.sub[1]), node.sub[2].toToken());

			case "function":
				PFunctionType(convertComplexType(node.sub[0]), node.sub[1].toToken(), convertComplexType(node.sub[2]));

			case "parenthesis":
				PParenthesisType(node.sub[0].toToken(), convertComplexType(node.sub[1]), node.sub[2].toToken());

			case "optional":
				POptionalType(node.sub[0].toToken(), convertComplexType(node.sub[1]));

			case "extension":
				var extensions = node.sub[1].asNode("extensions").sub.map(function(node):NStructuralExtension {
					var node = node.asNode("structural_extension");
					return {
						gt: node.sub[0].toToken(),
						path: convertTypePath(node.sub[1]),
						comma: node.sub[2].toToken(),
					};
				});
				PStructuralExtension(
					node.sub[0].toToken(),
					extensions,
					convertAnonymousFields(node.sub[2]),
					node.sub[3].toToken()
				);

			case unknown:
				throw 'Unknown ComplexType type: $unknown';
		};
	}

	static function convertTypeHint(node:JNodeBase):NTypeHint {
		var node = node.asNode("type_hint");
		return {
			colon: node.sub[0].toToken(),
			type: convertComplexType(node.sub[1])
		};
	}

	static function convertLiteral(node:JNodeBase):NLiteral {
		var node:JNode = cast node;
		return switch (node.name) {
			case "literal_int":
				PLiteralInt(node.sub[0].toToken());
			case "literal_float":
				PLiteralFloat(node.sub[0].toToken());
			case "literal_regex":
				PLiteralRegex(node.sub[0].toToken());
			case "literal_string":
				PLiteralString(convertString(node.sub[0]));
			case unknown:
				throw 'Unknown literal type: $unknown';
		}
	}

	static function convertString(node:JNodeBase):NString {
		var node = node.asNode("string");
		var token = node.sub[0].asToken();
		return switch (token.token.fastCodeAt(0)) {
			case '"'.code: PString(token.convertToToken());
			case "'".code: PString2(token.convertToToken());
			case unknown: throw 'Unknown string quote: ${String.fromCharCode(unknown)}';
		};
	}

	static function convertCallArgs(node:JNodeBase):NCallArgs {
		var node = node.asNode("call_args");
		var result:NCallArgs = {
			popen: node.sub[0].toToken(),
			pclose: node.sub[2].toToken(),
		};
		if (node.sub[1] != null)
			result.args = commaSeparated(node.sub[1].asNode("exprs").sub, convertExpr);
		return result;
	}

	static function convertExpr(node:JNodeBase):NExpr {
		var node:JNode = cast node;
		return switch (node.name) {
			case "expr_binop":
				var a = convertExpr(node.sub[0]);
				var op = node.sub[1].toToken();
				var b = convertExpr(node.sub[2]);
				PBinop(a, op, b);

			case "expr_const":
				var const:JNode = cast node.sub[0];
				PConst(switch (const.name) {
					case "ident":
						PConstIdent(const.sub[0].toToken());
					case "literal":
						PConstLiteral(convertLiteral(const.sub[0]));
					case unknown:
						throw 'Unknown constant type: $unknown';
				});

			case "expr_call":
				var e = convertExpr(node.sub[0]);
				var args = convertCallArgs(node.sub[1]);
				PCall(e, args);

			case "expr_unary_prefix":
				var op = node.sub[0].toToken();
				var e = convertExpr(node.sub[1]);
				PUnaryPrefix(op, e);

			case "expr_unary_postfix":
				var e = convertExpr(node.sub[0]);
				var op = node.sub[1].toToken();
				PUnaryPostfix(e, op);

			case "expr_continue":
				PContinue(node.sub[0].toToken());

			case "expr_break":
				PBreak(node.sub[0].toToken());

			case "expr_return":
				PReturn(node.sub[0].toToken());

			case "expr_return_value":
				PReturnExpr(node.sub[0].toToken(), convertExpr(node.sub[1]));

			case "expr_unsafe_cast":
				PUnsafeCast(node.sub[0].toToken(), convertExpr(node.sub[1]));

			case "expr_safe_cast":
				PSafeCast(
					node.sub[0].toToken(), // cast
					node.sub[1].toToken(), // (
					convertExpr(node.sub[2]), // expr
					node.sub[3].toToken(), // ,
					convertComplexType(node.sub[4]), // type
					node.sub[5].toToken() // )
				);

			case "expr_untyped":
				PUntyped(node.sub[0].toToken(), convertExpr(node.sub[1]));

			case "expr_field":
				PField(convertExpr(node.sub[0]), convertDotIdent(node.sub[1]));

			case "expr_parenthesis":
				PParenthesis(node.sub[0].toToken(), convertExpr(node.sub[1]), node.sub[2].toToken());

			case "expr_typecheck":
				PCheckType(node.sub[0].toToken(), convertExpr(node.sub[1]), node.sub[2].toToken(), convertComplexType(node.sub[3]), node.sub[4].toToken());

			case "expr_metadata":
				PMetadata(convertMeta(node.sub[0]), convertExpr(node.sub[1]));

			case "expr_in":
				PIn(convertExpr(node.sub[0]), node.sub[1].toToken(), convertExpr(node.sub[2]));

			case "expr_throw":
				PThrow(node.sub[0].toToken(), convertExpr(node.sub[1]));

			case "expr_keyword_ident":
				PConst(PConstIdent(node.sub[0].asNode("keyword_ident").sub[0].toToken()));

			case "expr_if":
				var ifToken = node.sub[0].toToken();
				var popen = node.sub[1].toToken();
				var econd = convertExpr(node.sub[2]);
				var pclose = node.sub[3].toToken();
				var eif = convertExpr(node.sub[4]);
				var elseNode = node.sub[5];
				var els = if (elseNode == null) null else {
					var node = elseNode.asNode("else_expr");
					{
						_else: node.sub[0].toToken(),
						e: convertExpr(node.sub[1]),
					}
				};
				PIf(ifToken, popen, econd, pclose, eif, els);

			case "expr_empty_block":
				PBlock(node.sub[0].toToken(), [], node.sub[1].toToken());

			case "expr_nonempty_block":
				var elems = node.sub[1].asNode("elements").sub.map(convertBlockElement);
				PBlock(node.sub[0].toToken(), elems, node.sub[2].toToken());

			case "expr_for":
				var forToken = node.sub[0].toToken();
				var popen = node.sub[1].toToken();
				var e1 = convertExpr(node.sub[2]);
				var pclose = node.sub[3].toToken();
				var e2 = convertExpr(node.sub[4]);
				PFor(forToken, popen, e1, pclose, e2);

			case "expr_while":
				var whileToken = node.sub[0].toToken();
				var popen = node.sub[1].toToken();
				var e1 = convertExpr(node.sub[2]);
				var pclose = node.sub[3].toToken();
				var e2 = convertExpr(node.sub[4]);
				PWhile(whileToken, popen, e1, pclose, e2);

			case "expr_do":
				var doToken = node.sub[0].toToken();
				var e1 = convertExpr(node.sub[1]);
				var whileToken = node.sub[2].toToken();
				var popen = node.sub[3].toToken();
				var e2 = convertExpr(node.sub[4]);
				var pclose = node.sub[5].toToken();
				PDo(doToken, e1, whileToken, popen, e2, pclose);

			case "expr_array_declaration":
				var bkopen = node.sub[0].toToken();
				var elems = if (node.sub[1] == null) null else commaSeparatedTrailing(node.sub[1].asNode("elements").sub, convertExpr);
				var bkclose = node.sub[2].toToken();
				PArrayDecl(bkopen, elems, bkclose);

			case "expr_object_declaration":
				function convertObjectField(node:JNodeBase):NObjectField {
					var node = node.asNode("object_field");

					var name = {
						var n:JNode = cast node.sub[0].asNode("object_field_name").sub[0];
						switch (n.name) {
							case "dollar_ident":
								NObjectFieldName.PIdent(convertDollarIdent(n));
							case "string":
								NObjectFieldName.PString(convertString(n));
							case unknown:
								throw 'Unknown object field name type: $unknown';
						}
					}
					var colon = node.sub[1].toToken();
					var expr = convertExpr(node.sub[2]);

					return {name: name, colon: colon, e: expr};
				}

				PObjectDecl(
					node.sub[0].toToken(),
					commaSeparatedTrailing(node.sub[1].asNode("object_fields").sub, convertObjectField),
					node.sub[2].toToken()
				);

			case "expr_is":
				var e = convertExpr(node.sub[1]);
				var tp = convertTypePath(node.sub[3]);
				PIs(node.sub[0].toToken(), e, node.sub[2].toToken(), tp, node.sub[4].toToken());

			case "expr_new":
				PNew(node.sub[0].toToken(), convertTypePath(node.sub[1]), convertCallArgs(node.sub[2]));

			case "expr_try":
				var catches = node.sub[2].asNode("catches").sub.map(function(node):NCatch {
					var node = node.asNode("catch");
					return {
						_catch: node.sub[0].toToken(),
						popen: node.sub[1].toToken(),
						ident: convertDollarIdent(node.sub[2]),
						type: convertTypeHint(node.sub[3]),
						pclose: node.sub[4].toToken(),
						e: convertExpr(node.sub[5]),
					};
				});
				PTry(node.sub[0].toToken(), convertExpr(node.sub[1]), catches);

			case "expr_var":
				PVar(node.sub[0].toToken(), convertVarDecl(node.sub[1]));

			case "expr_function":
				var funToken = node.sub[0].toToken();
				PFunction(funToken, convertFunction(node.sub[1]));

			case "expr_array_access":
				PArray(
					convertExpr(node.sub[0]), // expr
					node.sub[1].toToken(), // [
					convertExpr(node.sub[2]), // expr
					node.sub[3].toToken() // ]
				);

			case "expr_dotint":
				// TODO wtf is this?
				PIntDot(node.sub[0].toToken(), node.sub[1].toToken());

			case "expr_macro":
				PMacro(node.sub[0].toToken(), convertMacroExpr(node.sub[1]));

			case "expr_macro_escape":
				PMacroEscape(node.sub[0].toToken(), node.sub[1].toToken(), convertExpr(node.sub[2]), node.sub[3].toToken());

			case "expr_switch":
				var cases = node.sub[3].asNode("cases").sub.map(function(node):NCase {
					var node = node.asNode("case");
					var token = node.sub[0].asToken();
					return switch (token.token) {
						case "default":
							var elems = if (node.sub[2] == null) [] else node.sub[2].asNode("elements").sub.map(convertBlockElement);
							PDefault(token.convertToToken(), node.sub[1].toToken(), elems);
						case "case":
							var patterns = commaSeparated(node.sub[1].asNode("exprs").sub, convertExpr);
							var guardNode = node.sub[2];
							var guard:NGuard = if (guardNode == null) null else {
								var node = guardNode.asNode("guard");
								{
									_if: node.sub[0].toToken(),
									popen: node.sub[1].toToken(),
									e: convertExpr(node.sub[2]),
									pclose: node.sub[3].toToken(),
								}
							};
							var elems = if (node.sub[4] == null) [] else node.sub[4].asNode("elements").sub.map(convertBlockElement);
							PCase(token.convertToToken(), patterns, guard, node.sub[3].toToken(), elems);
						case unknown:
							throw 'Unknown switch case token: $unknown';
					}
				});
				PSwitch(
					node.sub[0].toToken(),
					convertExpr(node.sub[1]),
					node.sub[2].toToken(),
					cases,
					node.sub[4].toToken()
				);

			case "expr_ternary":
				var econd = convertExpr(node.sub[0]);
				var ethen = convertExpr(node.sub[2]);
				var eelse = convertExpr(node.sub[4]);
				PTernary(econd, node.sub[1].toToken(), ethen, node.sub[3].toToken(), eelse);

			case unknown:
				throw 'Unknown expression type: $unknown';
		}
	}

	static function convertMacroExpr(node:JNodeBase):NMacroExpr {
		var node:JNode = cast node.asNode("macro_expr").sub[0];
		return switch (node.name) {
			case "macro_type_hint":
				PTypeHint(convertTypeHint(node.sub[0]));
			case "macro_expr_expr":
				PExpr(convertExpr(node.sub[0]));
			case "macro_var":
				var decls = commaSeparated(node.sub[1].asNode("vars").sub, convertVarDecl);
				PVar(node.sub[0].toToken(), decls);
			case "macro_class_decl":
				PClass(convertClassDeclInner(node, 0));
			case unknown:
				throw 'Unknown macro expr type: $unknown';
		}
	}

	static function convertFunction(node:JNodeBase):NFunction {
		var node = node.asNode("function");
		var result:NFunction = {
			params: convertTypeDeclParameters(node.sub[1]),
			popen: node.sub[2].toToken(),
			pclose: node.sub[4].toToken(),
			e: convertExpr(node.sub[6])
		};
		if (node.sub[0] != null)
			result.ident = convertDollarIdent(node.sub[0]);
		if (node.sub[3] != null)
			result.args = commaSeparated(node.sub[3].asNode("args").sub, convertFunctionArg);
		if (node.sub[5] != null)
			result.type = convertTypeHint(node.sub[5]);
		return result;
	}

	static function convertVarDecl(node:JNodeBase):NVarDeclaration {
		var node = node.asNode("var_declaration");
		var result:NVarDeclaration = {name: convertDollarIdent(node.sub[0])};
		var hintNode = node.sub[1];
		if (hintNode != null)
			result.type = convertTypeHint(hintNode);
		var assNode = node.sub[2];
		if (assNode != null)
			result.assignment = convertAssignment(assNode);
		return result;
	}

	static function convertBlockElement(node:JNodeBase):NBlockElement {
		var node:JNode = cast node;
		return switch (node.name) {
			case "block_element_expr":
				PExpr(convertExpr(node.sub[0]), node.sub[1].toToken());
			case "block_element_inline_function":
				PInlineFunction(
					node.sub[0].toToken(),
					node.sub[1].toToken(),
					convertFunction(node.sub[2]),
					node.sub[3].toToken()
				);
			case "block_element_var":
				var decls = commaSeparated(node.sub[1].asNode("vars").sub, convertVarDecl);
				return PVar(node.sub[0].toToken(), decls, node.sub[2].toToken());
			case unknown:
				throw 'Unknown block element type: $unknown';
		}
	}

	static function convertAssignment(node:JNodeBase):NAssignment {
		var node = node.asNode("assignment");
		return {
			assign: node.sub[0].toToken(),
			e: convertExpr(node.sub[1]),
		};
	}

	static function convertFunctionArg(node:JNodeBase):NFunctionArgument {
		var node = node.asNode("function_argument");
		var result:NFunctionArgument = {
			annotations: convertAnnotations(node.sub[0]),
			name: convertDollarIdent(node.sub[2]),
		};
		if (node.sub[1] != null)
			result.questionmark = node.sub[1].toToken();
		if (node.sub[3] != null)
			result.typeHint = convertTypeHint(node.sub[3]);
		if (node.sub[4] != null)
			result.assignment = convertAssignment(node.sub[4]);
		return result;
	}

	static function convertMethod(node:JNodeBase):NClassField {
		var node = node.asNode("function_field");

		var annotations = convertAnnotations(node.sub[0]);
		var modifiers = convertModifiers(node.sub[1]);
		var functionToken = node.sub[2].toToken();
		var name =
			if (node.sub[3].name == "token") // e.g. `function new`
				node.sub[3].toToken();
			else
				convertDollarIdent(node.sub[3]);
		var params = convertTypeDeclParameters(node.sub[4]);
		var popen = node.sub[5].toToken();
		var args = if (node.sub[6] == null) null else commaSeparated(node.sub[6].asNode("args").sub, convertFunctionArg);
		var pclose = node.sub[7].toToken();
		var returnTypeHint = if (node.sub[8] == null) null else convertTypeHint(node.sub[8]);
		var expr = convertFieldExpr(node.sub[9]);

		return PFunctionField(annotations, modifiers, functionToken, name, params, popen, args, pclose, returnTypeHint, expr);
	}

	static function convertFieldExpr(node:JNodeBase):NFieldExpr {
		var node:JNode = cast node;
		return switch (node.name) {
			case "field_expr_none": PNoFieldExpr(node.sub[0].toToken());
			case "field_expr_expr": PExprFieldExpr(convertExpr(node.sub[0]), node.sub[1].toToken());
			case "field_expr_block": PBlockFieldExpr(convertExpr(node.sub[0]));
			case unknown: throw 'Unknown field expr type: $unknown';
		}
	}

	static function convertProperty(node:JNodeBase):NClassField {
		var node = node.asNode("property_field");
		inline function convertPropertyIdent(n:JNodeBase) return convertIdent(n.asNode("property_ident").sub[0]);
		return PPropertyField(
			convertAnnotations(node.sub[0]),
			convertModifiers(node.sub[1]),
			node.sub[2].toToken(),
			convertDollarIdent(node.sub[3]),
			node.sub[4].toToken(),
			convertPropertyIdent(node.sub[5]),
			node.sub[6].toToken(),
			convertPropertyIdent(node.sub[7]),
			node.sub[8].toToken(),
			if (node.sub[9] == null) null else convertTypeHint(node.sub[9]),
			if (node.sub[10] == null) null else convertAssignment(node.sub[10])
		);
	}

	static function convertVar(node:JNodeBase):NClassField {
		var node = node.asNode("variable_field");
		var annotations = convertAnnotations(node.sub[0]);
		var modifiers = convertModifiers(node.sub[1]);
		var varToken = node.sub[2].toToken();
		var name = convertDollarIdent(node.sub[3]);
		var typeHint = if (node.sub[4] == null) null else convertTypeHint(node.sub[4]);
		var assignment = if (node.sub[5] == null) null else convertAssignment(node.sub[5]);
		var semicolon = node.sub[6].toToken();
		return PVariableField(annotations, modifiers, varToken, name, typeHint, assignment, semicolon);
	}

	static function commaSeparatedTrailing<T>(nodes:Array<JNodeBase>, convert:JNodeBase->T):Null<NCommaSeparatedAllowTrailing<T>> {
		var elem = convert(nodes[0]);
		var rest = [];
		var i = 1;
		var trailingComma = null;
		while (i < nodes.length) {
			var comma = nodes[i].toToken();
			if (i + 1 >= nodes.length) {
				trailingComma = comma;
				break;
			} else {
				var elem = convert(nodes[i + 1]);
				rest.push({arg: elem, comma: comma});
				i += 2;
			}
		}

		var result:NCommaSeparatedAllowTrailing<T> = {
			arg: elem,
			args: rest,
		};
		if (trailingComma != null) result.comma = trailingComma;
		return result;
	}

	static function commaSeparated<T>(nodes:Array<JNodeBase>, convert:JNodeBase->T):Null<NCommaSeparated<T>> {
		if (nodes.length == 0)
			return null;

		var elem = convert(nodes[0]);
		var rest = [];
		var i = 1;
		while (i < nodes.length) {
			var comma = nodes[i].toToken();
			var elem = convert(nodes[i + 1]);
			rest.push({arg: elem, comma: comma});
			i += 2;
		}

		return {
			arg: elem,
			args: rest,
		};
	}

	static function convertTypeDeclParameter(node:JNodeBase):NTypeDeclParameter {
		var node = node.asNode("type_decl_parameter");

		var constraints =
			if (node.sub[2] == null)
				PNoConstraints;
			else {
				var node:JNode = cast node.sub[2];
				switch (node.name) {
					case "single":
						PSingleConstraint(node.sub[0].toToken(), convertComplexType(node.sub[1]));
					case "multiple":
						var typeNodes = node.sub.slice(2,4);
						typeNodes = typeNodes.concat(node.sub[4].asNode("types").sub);
						var types = commaSeparated(typeNodes, convertComplexType);
						PMultipleConstraints(node.sub[0].toToken(), node.sub[1].toToken(), types, node.sub[5].toToken());
					case unknown:
						throw 'Unknown type constraint node: $unknown';
				}
			}

		return {
			annotations: convertAnnotations(node.sub[0]),
			name: convertDollarIdent(node.sub[1]),
			constraints: constraints,
		};
	}

	static function convertTypeDeclParameters(node:JNodeBase):NTypeDeclParameters {
		if (node == null)
			return null;

		var node = node.asNode("type_decl_parameters");
		var params = commaSeparated(node.sub[1].asNode("params").sub, convertTypeDeclParameter);
		return {
			lt: node.sub[0].toToken(),
			params: params,
			gt: node.sub[2].toToken(),
		};
	}

	static function convertUsingDecl(node:JNodeBase):NDecl {
		var node = node.asNode("using_decl");
		return PUsingDecl(node.sub[0].toToken(), convertPath(node.sub[1]), node.sub[2].toToken());
	}

	static function convertImportDecl(node:JNodeBase):NDecl {
		var node = node.asNode("import_decl");
		var importToken = node.sub[0].toToken();

		var p = node.sub[1].asNode("import");
		var path = convertPath(p.sub[0]);

		var mode =
			if (p.sub[1] == null)
				PNormalMode
			else {
				var node:JNode =  cast p.sub[1];
				switch (node.name) {
					case "alias":
						var tok = node.sub[0].asToken();
						var ident = convertIdent(node.sub[1]);
						switch (tok.token) {
							case "as": PAsMode(tok.convertToToken(), ident);
							case "in": PInMode(tok.convertToToken(), ident);
							case unknown: throw "Unknown as/in import mode: " + unknown;
						}
					case "all":
						PAllMode(node.sub[0].toToken());
					case unknown:
						throw "Unknown import mode: " + unknown;
				}
			}

		var semicolonToken = node.sub[2].toToken();
		return PImportDecl(importToken, {path: path, mode: mode}, semicolonToken);
	}

	static function convertTypedefDecl(node:JNodeBase):NDecl {
		var node = node.asNode("typedef_decl");
		return PTypedefDecl(
			convertAnnotations(node.sub[0]),
			convertFlags(node.sub[1]),
			node.sub[2].toToken(),
			convertDollarIdent(node.sub[3]),
			convertTypeDeclParameters(node.sub[4]),
			node.sub[5].toToken(),
			convertComplexType(node.sub[6]),
			if (node.sub[7] != null) node.sub[7].toToken() else null
		);
	}

	static function convertEnumDecl(node:JNodeBase):NDecl {
		var node = node.asNode("enum_decl");

		function convertEnumArgs(node:JNodeBase):NEnumFieldArgs {
			if (node == null)
				return null;

			var node = node.asNode("enum_field_args");

			function convertEnumArg(node:JNodeBase):NEnumFieldArg {
				var node = node.asNode("enum_field_arg");
				var result:NEnumFieldArg = {
					name: convertDollarIdent(node.sub[1]),
					typeHint: convertTypeHint(node.sub[2]),
				}
				if (node.sub[0] != null)
					result.questionmark = node.sub[0].toToken();
				return result;
			}

			return {
				popen: node.sub[0].toToken(),
				args: commaSeparated(node.sub[1].asNode("args").sub, convertEnumArg),
				pclose: node.sub[2].toToken(),
			};
			return null;
		}

		var fieldsNode = node.sub[6];
		var fields = if (fieldsNode == null) [] else fieldsNode.asNode("enum_fields").sub.map(function(node) {
			var node = node.asNode("enum_field");
			return {
				annotations: convertAnnotations(node.sub[0]),
				name: convertDollarIdent(node.sub[1]),
				params: convertTypeDeclParameters(node.sub[2]),
				args: convertEnumArgs(node.sub[3]),
				type: if (node.sub[4] == null) null else convertTypeHint(node.sub[4]),
				semicolon: node.sub[5].toToken(),
			};
		});

		return PEnumDecl(
			convertAnnotations(node.sub[0]),
			convertFlags(node.sub[1]),
			node.sub[2].toToken(),
			convertDollarIdent(node.sub[3]),
			convertTypeDeclParameters(node.sub[4]),
			node.sub[5].toToken(),
			fields,
			node.sub[7].toToken()
		);
	}

	static function convertAbstractDecl(node:JNodeBase):NDecl {
		var node = node.asNode("abstract_decl");

		function convertUnderlyingType(node:JNodeBase):NUnderlyingType {
			var node = node.asNode("underlying_type");
			return {
				popen: node.sub[0].toToken(),
				type: convertComplexType(node.sub[1]),
				pclose: node.sub[2].toToken(),
			};
		}

		function convertAbstractRelations(node:JNodeBase):Array<NAbstractRelation> {
			if (node == null)
				return [];
			var node = node.asNode("relations");
			return node.sub.map(function(node) {
				var node = node.asNode("abstract relations");
				var tok = node.sub[0].asToken();
				var ct = convertComplexType(node.sub[1]);
				return switch (tok.token) {
					case "from": PFrom(tok.convertToToken(), ct);
					case "to": PTo(tok.convertToToken(), ct);
					case unknown: throw 'Unknown abstract relation type: $unknown';
				}
			});
		}

		return PAbstractDecl(
			convertAnnotations(node.sub[0]),
			convertFlags(node.sub[1]),
			node.sub[2].toToken(),
			convertDollarIdent(node.sub[3]),
			convertTypeDeclParameters(node.sub[4]),
			if (node.sub[5] == null) null else convertUnderlyingType(node.sub[5]),
			convertAbstractRelations(node.sub[6]),
			node.sub[7].toToken(),
			if (node.sub[8] == null) [] else node.sub[8].asNode("class_fields").sub.map(convertClassField),
			node.sub[9].toToken()
		);
	}

	static function convertClassDeclInner(node:JNode, offset:Int):NClassDecl {
		var kind = node.sub[offset].asNode("class_or_interface").sub[0].toToken();
		var name = if (node.sub[offset+1] == null) null else convertDollarIdent(node.sub[offset+1]); // name can be null in macro case
		var relations = if (node.sub[offset+3] == null) [] else node.sub[offset+3].asNode("relations").sub.map(convertClassRelation);
		var bropen = node.sub[offset+4].toToken();
		var fields = if (node.sub[offset+5] == null) [] else node.sub[offset+5].asNode("class_fields").sub.map(convertClassField);
		var brclose = node.sub[offset+6].toToken();
		return {
			kind: kind,
			name: name,
			params: convertTypeDeclParameters(node.sub[offset+2]),
			relations: relations,
			bropen: bropen,
			brclose: brclose,
			fields: fields,
		};
	}

	static function convertClassDecl(node:JNodeBase):NDecl {
		var node = node.asNode("class_decl");
		var annotations = convertAnnotations(node.sub[0]);
		var flags = convertFlags(node.sub[1]);
		return PClassDecl(annotations, flags, convertClassDeclInner(node, 2));
	}

	static function convertDecl(node:JNodeBase):NDecl {
		return switch (node.name) {
			case "class_decl":
				convertClassDecl(node);
			case "import_decl":
				convertImportDecl(node);
			case "using_decl":
				convertUsingDecl(node);
			case "typedef_decl":
				convertTypedefDecl(node);
			case "enum_decl":
				convertEnumDecl(node);
			case "abstract_decl":
				convertAbstractDecl(node);
			case unknown:
				throw 'Unknown decl node name: $unknown';
		}
	}
}