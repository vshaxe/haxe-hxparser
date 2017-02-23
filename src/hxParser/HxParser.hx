package hxParser;

import hxParser.JsonParser.JResult;
import util.Result;

class HxParser {
    public static function parse(src:String, entryPoint = "file"):Result<JResult> {
        return try Success(parser("<stdin>", entryPoint, src)) catch (e:Any) Failure(Std.string(e));
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
