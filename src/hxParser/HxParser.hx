package hxParser;

import hxParser.JsonParser.JResult;
import util.Result;

class HxParser {
    public static function parse(hxParser:String->String->JResult, src:String):Result<JResult> {
        return try Success(hxParser("<stdin>", src)) catch (e:Any) Failure(Std.string(e));
    }
}
