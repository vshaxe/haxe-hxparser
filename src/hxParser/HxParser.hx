package hxParser;

import hxParser.JsonParser.JResult;
import util.Result;

@:enum abstract EntryPoint(String) to String {
    var File = "file";
    var ClassFields = "class_fields";
    var ClassDecl = "class_decl";
}

class HxParser {
    public static function parse(src:String, entryPoint:EntryPoint = File):Result<JResult> {
        return try {
            var result = parser("<stdin>", entryPoint, src);
            if (result.document == null) {
                Failure(Std.string(result));
            } else {
                Success(result);
            }
        } catch (e:Any) Failure(Std.string(e));
    }

    static var parser:String->String->String->JResult;

    static function initParser() {
        untyped __js__("
        var module = {{exports: {{}}}};
        var embed = {0};
        embed(global);
        {1} = module.exports.parse;
        ", haxe.macro.Compiler.includeFile("../hxparserjs.js", "inline"), parser);
    }

    static function __init__() {
        initParser();
    }
}
