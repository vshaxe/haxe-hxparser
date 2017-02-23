package hxParser;

import hxParser.Tree;

typedef EnclosingNodeResult = Null<{name:String, start:Int, end:Int, callback:Tree -> Void}>;

class ParseTreeTools {
    static public function findEnclosingNode(tree:Tree, start:Int, end:Int, acceptedNodes:Array<String>) {
        var acceptedMap = [for (name in acceptedNodes) name => true];
        function loop(node:Tree):EnclosingNodeResult {
            if (node.start <= start && node.end >= end) {
                switch (node.kind) {
                    case Node(name, children):
                        for (i in 0...children.length) {
                            var child = loop(children[i]);
                            if (child != null) {
                                if (child.callback == null) {
                                    child.callback = function(newNode) children[i] = newNode;
                                }
                                return child;
                            }
                        }
                        var split = name.split(" "); // Maybe not good to fold names after all...
                        for (name in split) {
                            if (acceptedMap[name]) {
                                return {name: name, start: node.start, end: node.end, callback:null};
                            }
                        }
                    case Token(_):
                }
            }
            return null;
        }
        return loop(tree);
    }

    static public function calculatePositions(tree:Tree) {
        var offset = 0;
        function loop(node:Tree) {
            switch (node.kind) {
                case Token(token, trivia):
                    inline function updateTrivia(trivia) {
                        trivia.start = offset;
                        offset += trivia.token.length;
                        trivia.end = offset;
                    }
                    if (trivia.leading != null) for (trivia in trivia.leading) updateTrivia(trivia);
                    node.start = offset;
                    offset += token.length;
                    node.end = offset;
                    if (trivia.trailing != null) for (trivia in trivia.trailing) updateTrivia(trivia);
                case Node(_,children):
                    node.start = offset;
                    for (child in children) loop(child);
                    node.end = offset;
            }
        }
        loop(tree);
    }
}