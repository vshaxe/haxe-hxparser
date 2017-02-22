package hxParser;

import hxParser.JsonParser.JNodeBase;
import util.Result;

class HxParser {
    public static function parse(hxParser:String->String->JNodeBase, src:String):Result<JNodeBase> {
        return try Success(hxParser("<stdin>", src)) catch (e:Any) Failure(Std.string(e));
    }
}
