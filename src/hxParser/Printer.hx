package hxParser;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
using haxe.macro.Tools;
#end

import hxParser.ParseTree;

class Printer extends Walker {
    var add:String->Void;
    var buf:StringBuf;

    function new(printToken) {
        buf = new StringBuf();
        this.add = if (printToken == null) function(s) buf.add(s) else function(s) buf.add(printToken(s));
    }

    override function walkToken(token:Token) {
        if (token.leadingTrivia != null) for (trivia in token.leadingTrivia) add(trivia.text);
        if (token.text != "<eof>")
            add(token.text);
        if (token.trailingTrivia != null) for (trivia in token.trailingTrivia) add(trivia.text);
    }

    public static macro function print(node, ?printToken:ExprOf<String->String>):ExprOf<String> {
        var type = Context.typeof(node).toComplexType();
        switch (type) {
            case TPath({pack: [], name: "StdTypes", sub: "Null", params: [TPType(t)]}): type = t;
            default:
        }

        var walkMethod = switch (type) {
            case TPath({pack: ["hxParser"], name: "ParseTree", sub: name}): 'walk$name';
            case type: throw new Error("Unsupported node type " + type.toString(), node.pos);
        }

        return macro @:privateAccess {
            var printer = new hxParser.Printer($printToken);
            printer.$walkMethod($node);
            printer.buf.toString();
        }
    }
}
