package hxParser;

import hxParser.JResult;

typedef Tree = {
    var kind:TreeKind;
    var start:Int;
    var end:Int;
}

enum TreeKind {
    Node(name:String, children:Array<Tree>);
    Token(token:String, trivia:Trivia);
}
