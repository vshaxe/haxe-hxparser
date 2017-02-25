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
    @:optional var trivia:Trivia;
}

typedef JResult = {
    document: {
        tree: JNodeBase,
        blocks: Array<{start:Int, end:Int}>
    }
}

typedef Trivia = {
    @:optional var leading:Array<PlacedToken>;
    @:optional var trailing:Array<PlacedToken>;
    @:optional var implicit:Bool; // Omitted as allowed by the grammar (semicolon after }) (good)
    @:optional var inserted:Bool; // Actually missing (bad)
}

typedef PlacedToken = {
    var token:String;
    var start:Int;
    var end:Int;
}
