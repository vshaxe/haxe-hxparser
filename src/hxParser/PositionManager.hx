package hxParser;

import hxParser.ParseTree;

class PositionManager extends Walker {
    var offset:Int;

    public function new() {
        offset = 0;
    }

    override function walkToken(token:Token) {
        inline function updateTrivia(trivia:Trivia) {
            trivia.start = offset;
            offset += trivia.text.length;
            trivia.end = offset;
        }
        if (token.leadingTrivia != null) for (trivia in token.leadingTrivia) updateTrivia(trivia);
        token.start = offset;
        offset += token.text.length;
        token.end = offset;
        if (token.trailingTrivia != null) for (trivia in token.trailingTrivia) updateTrivia(trivia);
    }
}