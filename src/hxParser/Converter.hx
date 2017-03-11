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
}

class Converter {

    var data:JResult;
    var skippedOffset:Int;
    var tokenOffset:Int;

    public function new(data:JResult) {
        this.data = data;
        this.skippedOffset = 0;
        this.tokenOffset = 0;
    }

    function nextToken() {
        var doc = data.document;
        var leading = [for (i in 0...doc.skipped[skippedOffset++]) doc.tokens[tokenOffset++]];
        var token = new Token(doc.tokens[tokenOffset++]);
        token.leadingTrivia = leading.map(Trivia.new);
        token.trailingTrivia = [];
        var k = doc.skipped[skippedOffset];
        for (i in 0...k) {
            switch (doc.tokens[tokenOffset]) {
                case "#if" | "#else" | "#elseif": break; // I think having #end as trailing makes sense?
                case tok:
                    token.trailingTrivia.push(new Trivia(tok));
                    ++tokenOffset;
                    --doc.skipped[skippedOffset];
                    if (tok == "\n") break;
            }
        }
        return token;
    }

    public function convertResultToFile():File {
        return convertFile(data.document.tree.asNode("tree").sub[0].asNode("file"));
    }

    public function convertResultToClassFields():Array<ClassField> {
        var classFields = data.document.tree.asNode("tree").sub[0].asNode("class_fields_only").sub[0].asNode("class_fields").sub;
        return classFields.map(convertClassField);
    }

    function convertFile(node:JNode):File {
        var packNode = node.sub[0];
        var pack = null;
        if (packNode != null)
            pack = convertPack(packNode);

        var decls = node.sub[1];
        var decls = if (decls != null) decls.asNode("decls").sub.map(convertDecl) else [];

        var eof = nextToken();

        return {
            pack: pack,
            decls: decls,
            eof: eof,
        };
    }

    function convertPack(node:JNodeBase):Package {
        var node = node.asNode("package");

        var packageKeyword = nextToken();

        var path = null;
        var pathNode = node.sub[1];
        if (pathNode != null)
            path = convertPath(pathNode);

        var semicolon = nextToken();

        return {
            packageKeyword: packageKeyword,
            path: path,
            semicolon: semicolon
        };
    }

    function convertPath(node:JNodeBase):NPath {
        var node = node.asNode("path");
        var first = nextToken();
        var rest = node.sub.slice(1).map(convertDotIdent);
        return {
            ident: first,
            idents: rest,
        }
    }

    function convertDotIdent(node:JNodeBase):NDotIdent {
        var name = nextToken();
        return PDotIdent(name);
    }

    inline function convertDollarIdent(node:JNodeBase):Token {
        var node = node.asNode("dollar_ident").sub[0];
        // TODO: Maybe this should change in hxparser
        if (node.name == "token") return nextToken();
        else return convertIdent(node);
    }

    inline function convertIdent(node:JNodeBase):Token {
        return nextToken();
    }

    function convertAnnotations(node:JNodeBase):NAnnotations {
        if (node == null)
            return {metadata: []};

        var node = node.asNode("annotations");
        var doc = node.sub[0]; // TODO: what next?
        var meta = node.sub[1].asNode("metadatas").sub.map(convertMeta);
        var result:NAnnotations = {
            metadata: meta,
        };
        return result;
    }

    function convertMeta(node:JNodeBase):Metadata {
        var node = node.asNode("metadata");
        return switch (node.sub) {
            case [tok]:
                Simple(nextToken());
            case [tok, exprs, parenClose]:
                var tok = nextToken();
                var el = commaSeparated(exprs.asNode("exprs").sub, convertExpr);
                WithArgs(tok, el, nextToken());
            case unknown:
                throw 'Unknown metadata format: ${haxe.Json.stringify(unknown)}';
        }
    }

    function convertFlags(node:JNodeBase):Array<NCommonFlag> {
        if (node == null)
            return [];
        return node.asNode("flags").sub.map(function(node) {
            var tok = nextToken();
            return switch (tok.text) {
                case "extern": PExtern(tok);
                case "private": PPrivate(tok);
                case unknown:
                    throw "Unknown common flag " + unknown;
            }
        });
    }

    function convertTypeParameter(node:JNodeBase):TypePathParameter {
        var node:JNode = cast node;
        return switch (node.name) {
            case "complex_type":
                Type(convertComplexType(node));
            case "literal":
                Literal(convertLiteral(node.sub[0]));
            case "bracket":
                var bkOpen = nextToken();
                var elems = commaSeparatedTrailing(node.sub[1].asNode("elements").sub, convertExpr);
                ArrayExpr(bkOpen, elems, nextToken());
            case unknown:
                throw 'Unknown type parameter type: $unknown';
        }
    }

    function convertTypePath(node:JNodeBase):TypePath {
        var node = node.asNode("type_path");
        var result:TypePath = {path: convertPath(node.sub[0])};

        var tparams = node.sub[1];
        if (tparams != null) {
            var tparams = tparams.asNode("type_path_parameters");
            result.params = {
                lt: nextToken(),
                params: commaSeparated(tparams.sub[1].asNode("params").sub, convertTypeParameter),
                gt: nextToken(),
            };
        }

        return result;
    }

    function convertClassRelation(node:JNodeBase):ClassRelation {
        var node = node.asNode("class_relations");
        var token = nextToken();
        return switch (token.text) {
            case "extends":
                Extends(token, convertTypePath(node.sub[1]));
            case "implements":
                Implements(token, convertTypePath(node.sub[1]));
            case unknown:
                throw 'Unknown class relation type $unknown';
        }
    }

    function convertClassField(node:JNodeBase):ClassField {
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

    function convertModifiers(node:JNodeBase):Array<FieldModifier> {
        if (node == null)
            return [];
        return node.asNode("modifiers").sub.map(function(node) {
            var token = nextToken();
            return switch (token.text) {
                case "static": Static(token);
                case "macro": Macro(token);
                case "public": Public(token);
                case "private": Private(token);
                case "override": Override(token);
                case "dynamic": Dynamic(token);
                case "inline": Inline(token);
                case unknown: throw 'Unknown modifier token: $unknown';
            }
        });
    }

    function convertAnonymousFields(node:JNodeBase):AnonymousStructureFields {
        if (node == null)
            return ShortNotation(null);
        var node:JNode = cast node;
        return switch (node.name) {
            case "class_fields":
                ClassNotation(node.sub.map(convertClassField));
            case "short_fields":
                function convertAnonField(node:JNodeBase):AnonymousStructureField {
                    var node = node.asNode("anonymous_type_field");
                    var questionMark = null;
                    var questionMarkNode = node.sub[0];
                    if (questionMarkNode != null)
                        questionMark = nextToken();
                    return {
                        questionMark: questionMark,
                        name: convertDollarIdent(node.sub[1]),
                        typeHint: convertTypeHint(node.sub[2]),
                    };
                }
                ShortNotation(commaSeparatedTrailing(node.sub, convertAnonField));
            case unknown:
                throw 'Unknown anonymous fields notation: $unknown';
        }
    }

    function convertComplexType(node:JNodeBase):ComplexType {
        var node:JNode = cast node.asNode("complex_type").sub[0];
        return switch (node.name) {
            case "path":
                TypePath(convertTypePath(node.sub[0]));

            case "anonymous":
                AnonymousStructure(nextToken(), convertAnonymousFields(node.sub[1]), nextToken());

            case "function":
                Function(convertComplexType(node.sub[0]), nextToken(), convertComplexType(node.sub[2]));

            case "parenthesis":
                Parenthesis(nextToken(), convertComplexType(node.sub[1]), nextToken());

            case "optional":
                Optional(nextToken(), convertComplexType(node.sub[1]));

            case "extension":
                var brOpen = nextToken();
                var extensions = node.sub[1].asNode("extensions").sub.map(function(node):StructuralExtension {
                    var node = node.asNode("structural_extension");
                    return {
                        gt: nextToken(),
                        path: convertTypePath(node.sub[1]),
                        comma: nextToken(),
                    };
                });
                StructuralExtension(
                    brOpen,
                    extensions,
                    convertAnonymousFields(node.sub[2]),
                    nextToken()
                );

            case unknown:
                throw 'Unknown ComplexType type: $unknown';
        };
    }

    function convertTypeHint(node:JNodeBase):TypeHint {
        var node = node.asNode("type_hint");
        return {
            colon: nextToken(),
            type: convertComplexType(node.sub[1])
        };
    }

    function convertLiteral(node:JNodeBase):Literal {
        var node:JNode = cast node;
        return switch (node.name) {
            case "literal_int":
                PLiteralInt(nextToken());
            case "literal_float":
                PLiteralFloat(nextToken());
            case "literal_regex":
                PLiteralRegex(nextToken());
            case "literal_string":
                PLiteralString(convertString(node.sub[0]));
            case unknown:
                throw 'Unknown literal type: $unknown';
        }
    }

    function convertString(node:JNodeBase):StringToken {
        var node = node.asNode("string");
        var token = nextToken();
        return switch (token.text.fastCodeAt(0)) {
            case '"'.code: DoubleQuote(token);
            case "'".code: SingleQuote(token);
            case unknown: throw 'Unknown string quote: ${String.fromCharCode(unknown)}';
        };
    }

    function convertCallArgs(node:JNodeBase):CallArgs {
        var node = node.asNode("call_args");
        var pOpen = nextToken();
        var args = null;
        if (node.sub[1] != null)
            args = commaSeparated(node.sub[1].asNode("exprs").sub, convertExpr);
        return {
            parenOpen: pOpen,
            args: args,
            parenClose: nextToken(),
        };
    }

    function convertExpr(node:JNodeBase):Expr {
        var node:JNode = cast node;
        return switch (node.name) {
            case "expr_binop":
                var a = convertExpr(node.sub[0]);
                var op = nextToken();
                var b = convertExpr(node.sub[2]);
                EBinop(a, op, b);

            case "expr_const":
                var const:JNode = cast node.sub[0];
                EConst(switch (const.name) {
                    case "ident":
                        PConstIdent(nextToken());
                    case "literal":
                        PConstLiteral(convertLiteral(const.sub[0]));
                    case unknown:
                        throw 'Unknown constant type: $unknown';
                });

            case "expr_call":
                var e = convertExpr(node.sub[0]);
                var args = convertCallArgs(node.sub[1]);
                ECall(e, args);

            case "expr_unary_prefix":
                var op = nextToken();
                var e = convertExpr(node.sub[1]);
                EUnaryPrefix(op, e);

            case "expr_unary_postfix":
                var e = convertExpr(node.sub[0]);
                var op = nextToken();
                EUnaryPostfix(e, op);

            case "expr_continue":
                EContinue(nextToken());

            case "expr_break":
                EBreak(nextToken());

            case "expr_return":
                EReturn(nextToken());

            case "expr_return_value":
                EReturnExpr(nextToken(), convertExpr(node.sub[1]));

            case "expr_unsafe_cast":
                EUnsafeCast(nextToken(), convertExpr(node.sub[1]));

            case "expr_safe_cast":
                ESafeCast(
                    nextToken(), // cast
                    nextToken(), // (
                    convertExpr(node.sub[2]), // expr
                    nextToken(), // ,
                    convertComplexType(node.sub[4]), // type
                    nextToken() // )
                );

            case "expr_untyped":
                EUntyped(nextToken(), convertExpr(node.sub[1]));

            case "expr_field":
                EField(convertExpr(node.sub[0]), convertDotIdent(node.sub[1]));

            case "expr_parenthesis":
                EParenthesis(nextToken(), convertExpr(node.sub[1]), nextToken());

            case "expr_typecheck":
                ECheckType(nextToken(), convertExpr(node.sub[1]), nextToken(), convertComplexType(node.sub[3]), nextToken());

            case "expr_metadata":
                EMetadata(convertMeta(node.sub[0]), convertExpr(node.sub[1]));

            case "expr_in":
                EIn(convertExpr(node.sub[0]), nextToken(), convertExpr(node.sub[2]));

            case "expr_throw":
                EThrow(nextToken(), convertExpr(node.sub[1]));

            case "expr_keyword_ident":
                EConst(PConstIdent(nextToken()));

            case "expr_if":
                var ifToken = nextToken();
                var parenOpen = nextToken();
                var econd = convertExpr(node.sub[2]);
                var parenClose = nextToken();
                var eif = convertExpr(node.sub[4]);
                var elseNode = node.sub[5];
                var els = if (elseNode == null) null else {
                    var node = elseNode.asNode("else_expr");
                    {
                        elseKeyword: nextToken(),
                        expr: convertExpr(node.sub[1]),
                    }
                };
                EIf(ifToken, parenOpen, econd, parenClose, eif, els);

            case "expr_empty_block":
                EBlock(nextToken(), [], nextToken());

            case "expr_nonempty_block":
                var brOpen = nextToken();
                var elems = node.sub[1].asNode("elements").sub.map(convertBlockElement);
                EBlock(brOpen, elems, nextToken());

            case "expr_for":
                var forToken = nextToken();
                var parenOpen = nextToken();
                var e1 = convertExpr(node.sub[2]);
                var parenClose = nextToken();
                var e2 = convertExpr(node.sub[4]);
                EFor(forToken, parenOpen, e1, parenClose, e2);

            case "expr_while":
                var whileToken = nextToken();
                var parenOpen = nextToken();
                var e1 = convertExpr(node.sub[2]);
                var parenClose = nextToken();
                var e2 = convertExpr(node.sub[4]);
                EWhile(whileToken, parenOpen, e1, parenClose, e2);

            case "expr_do":
                var doToken = nextToken();
                var e1 = convertExpr(node.sub[1]);
                var whileToken = nextToken();
                var parenOpen = nextToken();
                var e2 = convertExpr(node.sub[4]);
                var parenClose = nextToken();
                EDo(doToken, e1, whileToken, parenOpen, e2, parenClose);

            case "expr_array_declaration":
                var bkopen = nextToken();
                var elems = if (node.sub[1] == null) null else commaSeparatedTrailing(node.sub[1].asNode("elements").sub, convertExpr);
                var bkclose = nextToken();
                EArrayDecl(bkopen, elems, bkclose);

            case "expr_object_declaration":
                function convertObjectField(node:JNodeBase):ObjectField {
                    var node = node.asNode("object_field");

                    var name:ObjectFieldName = {
                        var n:JNode = cast node.sub[0].asNode("object_field_name").sub[0];
                        switch (n.name) {
                            case "dollar_ident":
                                NIdent(convertDollarIdent(n));
                            case "string":
                                NString(convertString(n));
                            case unknown:
                                throw 'Unknown object field name type: $unknown';
                        }
                    }
                    var colon = nextToken();
                    var expr = convertExpr(node.sub[2]);

                    return {name: name, colon: colon, expr: expr};
                }

                EObjectDecl(
                    nextToken(),
                    commaSeparatedTrailing(node.sub[1].asNode("object_fields").sub, convertObjectField),
                    nextToken()
                );

            case "expr_is":
                var parenOpen = nextToken();
                var e = convertExpr(node.sub[1]);
                var isToken = nextToken();
                var tp = convertTypePath(node.sub[3]);
                var parenClose = nextToken();
                EIs(parenOpen, e, isToken, tp, parenClose);

            case "expr_new":
                ENew(nextToken(), convertTypePath(node.sub[1]), convertCallArgs(node.sub[2]));

            case "expr_try":
                var tryToken = nextToken();
                var catches = node.sub[2].asNode("catches").sub.map(function(node):Catch {
                    var node = node.asNode("catch");
                    return {
                        catchKeyword:nextToken(),
                        parenOpen: nextToken(),
                        ident: convertDollarIdent(node.sub[2]),
                        typeHint: convertTypeHint(node.sub[3]),
                        parenClose: nextToken(),
                        expr: convertExpr(node.sub[5]),
                    };
                });
                ETry(tryToken, convertExpr(node.sub[1]), catches);

            case "expr_var":
                EVar(nextToken(), convertVarDecl(node.sub[1]));

            case "expr_function":
                var funToken = nextToken();
                EFunction(funToken, convertFunction(node.sub[1]));

            case "expr_array_access":
                EArrayAccess(
                    convertExpr(node.sub[0]), // expr
                    nextToken(), // [
                    convertExpr(node.sub[2]), // expr
                    nextToken() // ]
                );

            case "expr_dotint":
                // TODO wtf is this?
                EIntDot(nextToken(), nextToken());

            case "expr_macro":
                EMacro(nextToken(), convertMacroExpr(node.sub[1]));

            case "expr_macro_escape":
                EMacroEscape(nextToken(), nextToken(), convertExpr(node.sub[2]), nextToken());

            case "expr_switch":
                var switchToken = nextToken();
                var expr = convertExpr(node.sub[1]);
                var brOpen = nextToken();
                var cases = node.sub[3].asNode("cases").sub.map(function(node):Case {
                    var node = node.asNode("case");
                    var token = nextToken();
                    return switch (token.text) {
                        case "default":
                            var colon = nextToken();
                            var elems = if (node.sub[2] == null) [] else node.sub[2].asNode("elements").sub.map(convertBlockElement);
                            Default(token, colon, elems);
                        case "case":
                            var patterns = commaSeparated(node.sub[1].asNode("exprs").sub, convertExpr);
                            var guardNode = node.sub[2];
                            var guard:Guard = if (guardNode == null) null else {
                                var node = guardNode.asNode("guard");
                                {
                                    ifKeyword: nextToken(),
                                    parenOpen: nextToken(),
                                    expr: convertExpr(node.sub[2]),
                                    parenClose: nextToken(),
                                }
                            };
                            var colon = nextToken();
                            var elems = if (node.sub[4] == null) [] else node.sub[4].asNode("elements").sub.map(convertBlockElement);
                            Case(token, patterns, guard, colon, elems);
                        case unknown:
                            throw 'Unknown switch case token: $unknown';
                    }
                });
                ESwitch(
                    switchToken,
                    expr,
                    brOpen,
                    cases,
                    nextToken()
                );

            case "expr_ternary":
                var econd = convertExpr(node.sub[0]);
                var questionmark = nextToken();
                var ethen = convertExpr(node.sub[2]);
                var colon = nextToken();
                var eelse = convertExpr(node.sub[4]);
                ETernary(econd, questionmark, ethen, colon, eelse);

            case "expr_dollarident":
                EDollarIdent(nextToken());

            case unknown:
                throw 'Unknown expression type: $unknown';
        }
    }

    function convertMacroExpr(node:JNodeBase):MacroExpr {
        var node:JNode = cast node.asNode("macro_expr").sub[0];
        return switch (node.name) {
            case "macro_type_hint":
                TypeHint(convertTypeHint(node.sub[0]));
            case "macro_expr_expr":
                Expr(convertExpr(node.sub[0]));
            case "macro_var":
                var varToken = nextToken();
                var decls = commaSeparated(node.sub[1].asNode("vars").sub, convertVarDecl);
                Var(varToken, decls);
            case "macro_class_decl":
                Class(convertClassDeclInner(node, 0));
            case unknown:
                throw 'Unknown macro expr type: $unknown';
        }
    }

    function convertFunction(node:JNodeBase):Function {
        var node = node.asNode("function");
        var name = null;
        if (node.sub[0] != null)
            name = convertDollarIdent(node.sub[0]);
        var params = convertTypeDeclParameters(node.sub[1]);
        var parenOpen = nextToken();
        var args = null;
        if (node.sub[3] != null)
            args = commaSeparated(node.sub[3].asNode("args").sub, convertFunctionArg);
        var parenClose = nextToken();
        return {
            name: name,
            params: params,
            parenOpen: parenOpen,
            args: args,
            parenClose: parenClose,
            typeHint: node.sub[5] == null ? null : convertTypeHint(node.sub[5]),
            expr: convertExpr(node.sub[6])
        };
    }

    function convertVarDecl(node:JNodeBase):VarDecl {
        var node = node.asNode("var_declaration");
        var result:VarDecl = {name: convertDollarIdent(node.sub[0])};
        var hintNode = node.sub[1];
        if (hintNode != null)
            result.typeHint = convertTypeHint(hintNode);
        var assNode = node.sub[2];
        if (assNode != null)
            result.assignment = convertAssignment(assNode);
        return result;
    }

    function convertBlockElement(node:JNodeBase):BlockElement {
        var node:JNode = cast node;
        return switch (node.name) {
            case "block_element_expr":
                Expr(convertExpr(node.sub[0]), nextToken());
            case "block_element_inline_function":
                InlineFunction(
                    nextToken(),
                    nextToken(),
                    convertFunction(node.sub[2]),
                    nextToken()
                );
            case "block_element_var":
                var varToken = nextToken();
                var decls = commaSeparated(node.sub[1].asNode("vars").sub, convertVarDecl);
                return Var(varToken, decls, nextToken());
            case unknown:
                throw 'Unknown block element type: $unknown';
        }
    }

    function convertAssignment(node:JNodeBase):Assignment {
        var node = node.asNode("assignment");
        return {
            assign: nextToken(),
            expr: convertExpr(node.sub[1]),
        };
    }

    function convertFunctionArg(node:JNodeBase):FunctionArgument {
        var node = node.asNode("function_argument");
        var result:FunctionArgument = {
            annotations: convertAnnotations(node.sub[0]),
            questionMark: node.sub[1] == null ? null : nextToken(),
            name: convertDollarIdent(node.sub[2]),
        };
        if (node.sub[3] != null)
            result.typeHint = convertTypeHint(node.sub[3]);
        if (node.sub[4] != null)
            result.assignment = convertAssignment(node.sub[4]);
        return result;
    }

    function convertMethod(node:JNodeBase):ClassField {
        var node = node.asNode("function_field");

        var annotations = convertAnnotations(node.sub[0]);
        var modifiers = convertModifiers(node.sub[1]);
        var functionToken = nextToken();
        var name =
            if (node.sub[3].name == "token") // e.g. `function new`
                nextToken();
            else
                convertDollarIdent(node.sub[3]);
        var params = convertTypeDeclParameters(node.sub[4]);
        var parenOpen = nextToken();
        var args = if (node.sub[6] == null) null else commaSeparated(node.sub[6].asNode("args").sub, convertFunctionArg);
        var parenClose = nextToken();
        var returnTypeHint = if (node.sub[8] == null) null else convertTypeHint(node.sub[8]);
        var expr = convertMethodExpr(node.sub[9]);

        return Function(annotations, modifiers, functionToken, name, params, parenOpen, args, parenClose, returnTypeHint, expr);
    }

    function convertMethodExpr(node:JNodeBase):MethodExpr {
        var node:JNode = cast node;
        return switch (node.name) {
            case "field_expr_none": None(nextToken());
            case "field_expr_expr": Expr(convertExpr(node.sub[0]), nextToken());
            case "field_expr_block": Block(convertExpr(node.sub[0]));
            case unknown: throw 'Unknown field expr type: $unknown';
        }
    }

    function convertProperty(node:JNodeBase):ClassField {
        var node = node.asNode("property_field");
        function convertPropertyIdent(n:JNodeBase) {
            var node = n.asNode("property_ident").sub[0];
            if (node.name == "token") return nextToken()
            else return convertIdent(node);
        }
        return Property(
            convertAnnotations(node.sub[0]),
            convertModifiers(node.sub[1]),
            nextToken(),
            convertDollarIdent(node.sub[3]),
            nextToken(),
            convertPropertyIdent(node.sub[5]),
            nextToken(),
            convertPropertyIdent(node.sub[7]),
            nextToken(),
            if (node.sub[9] == null) null else convertTypeHint(node.sub[9]),
            if (node.sub[10] == null) null else convertAssignment(node.sub[10]),
            nextToken()
        );
    }

    function convertVar(node:JNodeBase):ClassField {
        var node = node.asNode("variable_field");
        var annotations = convertAnnotations(node.sub[0]);
        var modifiers = convertModifiers(node.sub[1]);
        var varToken = nextToken();
        var name = convertDollarIdent(node.sub[3]);
        var typeHint = if (node.sub[4] == null) null else convertTypeHint(node.sub[4]);
        var assignment = if (node.sub[5] == null) null else convertAssignment(node.sub[5]);
        var semicolon = nextToken();
        return Variable(annotations, modifiers, varToken, name, typeHint, assignment, semicolon);
    }

    function commaSeparatedTrailing<T>(nodes:Array<JNodeBase>, convert:JNodeBase->T):Null<CommaSeparatedAllowTrailing<T>> {
        var elem = convert(nodes[0]);
        var rest = [];
        var i = 1;
        var trailingComma = null;
        while (i < nodes.length) {
            var comma = nextToken();
            if (i + 1 >= nodes.length) {
                trailingComma = comma;
                break;
            } else {
                var elem = convert(nodes[i + 1]);
                rest.push({arg: elem, comma: comma});
                i += 2;
            }
        }

        var result:CommaSeparatedAllowTrailing<T> = {
            arg: elem,
            args: rest,
        };
        if (trailingComma != null) result.comma = trailingComma;
        return result;
    }

    function commaSeparated<T>(nodes:Array<JNodeBase>, convert:JNodeBase->T):Null<CommaSeparated<T>> {
        if (nodes.length == 0)
            return null;

        var elem = convert(nodes[0]);
        var rest = [];
        var i = 1;
        while (i < nodes.length) {
            var comma = nextToken();
            var elem = convert(nodes[i + 1]);
            rest.push({arg: elem, comma: comma});
            i += 2;
        }

        return {
            arg: elem,
            args: rest,
        };
    }

    function convertTypeDeclParameter(node:JNodeBase):TypeDeclParameter {
        var node = node.asNode("type_decl_parameter");

        return {
            annotations: convertAnnotations(node.sub[0]),
            name: convertDollarIdent(node.sub[1]),
            constraints:
                if (node.sub[2] == null)
                    None;
                else {
                    var node:JNode = cast node.sub[2];
                    switch (node.name) {
                        case "single":
                            Single(nextToken(), convertComplexType(node.sub[1]));
                        case "multiple":
                            var colon = nextToken();
                            var parenOpen = nextToken();
                            var typeNodes = node.sub.slice(2,4);
                            typeNodes = typeNodes.concat(node.sub[4].asNode("types").sub);
                            var types = commaSeparated(typeNodes, convertComplexType);
                            Multiple(colon, parenOpen, types, nextToken());
                        case unknown:
                            throw 'Unknown type constraint node: $unknown';
                    }
                }
        }
    }

    function convertTypeDeclParameters(node:JNodeBase):TypeDeclParameters {
        if (node == null)
            return null;

        var node = node.asNode("type_decl_parameters");
        return {
            lt: nextToken(),
            params: commaSeparated(node.sub[1].asNode("params").sub, convertTypeDeclParameter),
            gt: nextToken(),
        };
    }

    function convertUsingDecl(node:JNodeBase):Decl {
        var node = node.asNode("using_decl");
        return UsingDecl({
            usingKeyword: nextToken(),
            path: convertPath(node.sub[1]),
            semicolon: nextToken()
        });
    }

    function convertImportDecl(node:JNodeBase):Decl {
        var node = node.asNode("import_decl");
        var importToken = nextToken();
        var path = convertPath(node.sub[1]);

        var mode = if (node.sub[2] == null)
            INormal
        else {
            var node:JNode = cast node.sub[2];
            switch (node.name) {
                case "alias":
                    var tok = nextToken();
                    var ident = convertIdent(node.sub[1]);
                    switch (tok.text) {
                        case "as": IAs(tok, ident);
                        case "in": IIn(tok, ident);
                        case unknown: throw "Unknown as/in import mode: " + unknown;
                    }
                case "all":
                    IAll(nextToken());
                case unknown:
                    throw "Unknown import mode: " + unknown;
            }
        }
        var semicolonToken = nextToken();
        return ImportDecl({
            importKeyword: importToken,
            path: path,
            mode: mode,
            semicolon: semicolonToken
        });
    }

    function convertTypedefDecl(node:JNodeBase):Decl {
        var node = node.asNode("typedef_decl");
        return TypedefDecl({
            annotations: convertAnnotations(node.sub[0]),
            flags: convertFlags(node.sub[1]),
            typedefKeyword: nextToken(),
            name: convertDollarIdent(node.sub[3]),
            params: convertTypeDeclParameters(node.sub[4]),
            assign: nextToken(),
            type: convertComplexType(node.sub[6]),
            semicolon: if (node.sub[7] != null) nextToken() else null // TODO: This won't work if we remove the indices
        });
    }

    function convertEnumDecl(node:JNodeBase):Decl {
        var node = node.asNode("enum_decl");

        function convertEnumArgs(node:JNodeBase):NEnumFieldArgs {
            if (node == null)
                return null;

            var node = node.asNode("enum_field_args");

            function convertEnumArg(node:JNodeBase):NEnumFieldArg {
                var node = node.asNode("enum_field_arg");
                var result:NEnumFieldArg = {
                    questionMark: node.sub[0] == null ? null : nextToken(),
                    name: convertDollarIdent(node.sub[1]),
                    typeHint: convertTypeHint(node.sub[2]),
                }
                return result;
            }

            return {
                parenOpen: nextToken(),
                args: if (node.sub[1] == null) null else commaSeparated(node.sub[1].asNode("args").sub, convertEnumArg),
                parenClose: nextToken(),
            };
            return null;
        }

        var fieldsNode = node.sub[6];
        return EnumDecl({
            annotations: convertAnnotations(node.sub[0]),
            flags: convertFlags(node.sub[1]),
            enumKeyword: nextToken(),
            name: convertDollarIdent(node.sub[3]),
            params: convertTypeDeclParameters(node.sub[4]),
            braceOpen: nextToken(),
            fields: if (fieldsNode == null) [] else fieldsNode.asNode("enum_fields").sub.map(function(node) {
                var node = node.asNode("enum_field");
                return {
                    annotations: convertAnnotations(node.sub[0]),
                    name: convertDollarIdent(node.sub[1]),
                    params: convertTypeDeclParameters(node.sub[2]),
                    args: convertEnumArgs(node.sub[3]),
                    typeHint: if (node.sub[4] == null) null else convertTypeHint(node.sub[4]),
                    semicolon: nextToken(),
                };
            }),
            braceClose: nextToken()
        });
    }

    function convertAbstractDecl(node:JNodeBase):Decl {
        var node = node.asNode("abstract_decl");

        function convertUnderlyingType(node:JNodeBase):UnderlyingType {
            var node = node.asNode("underlying_type");
            return {
                parenOpen: nextToken(),
                type: convertComplexType(node.sub[1]),
                parenClose: nextToken(),
            };
        }

        function convertAbstractRelations(node:JNodeBase):Array<AbstractRelation> {
            if (node == null)
                return [];
            var node = node.asNode("relations");
            return node.sub.map(function(node) {
                var node = node.asNode("abstract relations");
                var tok = nextToken();
                var ct = convertComplexType(node.sub[1]);
                return switch (tok.text) {
                    case "from": From(tok, ct);
                    case "to": To(tok, ct);
                    case unknown: throw 'Unknown abstract relation type: $unknown';
                }
            });
        }

        var annotations = convertAnnotations(node.sub[0]);
        var flags = convertFlags(node.sub[1]);
        var abstractToken = nextToken();
        var name = convertDollarIdent(node.sub[3]);
        var params = convertTypeDeclParameters(node.sub[4]);
        var underlyingType = if (node.sub[5] == null) null else convertUnderlyingType(node.sub[5]);
        var relations = convertAbstractRelations(node.sub[6]);
        var brOpen = nextToken();
        var fields = if (node.sub[8] == null) [] else node.sub[8].asNode("class_fields").sub.map(convertClassField);
        var brClose = nextToken();

        return AbstractDecl({
            annotations: annotations,
            flags: flags,
            abstractKeyword: abstractToken,
            name: name,
            params: params,
            underlyingType: underlyingType,
            relations: relations,
            braceOpen: brOpen,
            fields: fields,
            braceClose: brClose
    });
    }

    function convertClassDeclInner(node:JNode, offset:Int):ClassDecl {
        var kind = nextToken();
        var name = if (node.sub[offset+1] == null) null else convertDollarIdent(node.sub[offset+1]); // name can be null in macro case
        var params = convertTypeDeclParameters(node.sub[offset+2]);
        var relations = if (node.sub[offset+3] == null) [] else node.sub[offset+3].asNode("relations").sub.map(convertClassRelation);
        var braceOpen = nextToken();
        var fields = if (node.sub[offset+5] == null) [] else node.sub[offset+5].asNode("class_fields").sub.map(convertClassField);
        var braceClose = nextToken();
        return {
            kind: kind,
            name: name,
            params: params,
            relations: relations,
            braceOpen: braceOpen,
            braceClose: braceClose,
            fields: fields,
        };
    }

    function convertClassDecl(node:JNodeBase):Decl {
        var node = node.asNode("class_decl");
        var annotations = convertAnnotations(node.sub[0]);
        var flags = convertFlags(node.sub[1]);
        return ClassDecl({
            annotations: annotations,
            flags: flags,
            decl: convertClassDeclInner(node, 2)
        });
    }

    function convertDecl(node:JNodeBase):Decl {
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
