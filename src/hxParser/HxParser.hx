package hxParser;

import hxParser.JsonParser.JNodeBase;
import util.Result;

class HxParser {
    public static function parse(src:String):Result<JNodeBase> {
        return try Success(_parse("<stdin>", src)) catch (e:Any) Failure(Std.string(e));
    }

    static var _parse:String->String->JNodeBase = js.Lib.require("../formatter/hxparserjs.js").parse;
}
