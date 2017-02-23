package hxParser;

typedef Tree = {
    var kind:TreeKind;
    var start:Int;
    var end:Int;
}

enum TreeKind {
    Node(name:String, children:Array<Tree>);
    Token(token:String, trivia:Trivia);
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