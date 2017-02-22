package hxParser;

import hxParser.JsonParser;
using Lambda;

class Printer {
    public static function print(tree:Tree):String {
        var haxeBuf = new StringBuf();
        inline function add(token:String) {
            haxeBuf.add(token);
        }
        function loop(tree:Tree) {
            switch (tree.kind) {
                case Node(_, children): children.iter(loop);
                case Token(token, trivia):
                    if (trivia == null) haxeBuf.add(token)
                    else {
                        if (trivia.leading != null) for (trivia in trivia.leading) add(trivia.token);
                        if (!trivia.implicit && !trivia.inserted && token != "<eof>") add(token);
                        if (trivia.trailing != null) for (trivia in trivia.trailing) add(trivia.token);
                    }
            }
        }
        loop(tree);
        return haxeBuf.toString();
    }
}