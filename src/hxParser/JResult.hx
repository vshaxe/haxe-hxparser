package hxParser;

typedef JNodeBase = {
    var name:String;
}

typedef JNode = {
    >JNodeBase,
    @:optional var sub:Array<JNodeBase>;
}

typedef JToken = {
    >JNodeBase,
    var token:String;
    var start:Int;
    var end:Int;
    @:optional var trivia:JTrivia;
}

@:enum abstract JTriviaFlag(String) {
    var Implicit = "implicit";
    var Inserted = "inserted";
}

typedef JResult = {
    document: {
        tree: JNodeBase,
        blocks: Array<{start:Int, end:Int}>,
        errors: Array<String>,
        tokens: Array<{token: String, ?flag:JTriviaFlag}>,
        skipped: Array<Int>
    }
}

typedef JTrivia = {
    @:optional var leading:Array<JPlacedToken>;
    @:optional var trailing:Array<JPlacedToken>;
    @:optional var implicit:Bool; // Omitted as allowed by the grammar (semicolon after }) (good)
    @:optional var inserted:Bool; // Actually missing (bad)
}

typedef JPlacedToken = {
    var token:String;
    var start:Int;
    var end:Int;
}
