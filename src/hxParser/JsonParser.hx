package hxParser;

import hxParser.Tree;
import hxParser.JResult;

class JsonParser {
    public static function parseTree(input:JNodeBase):Tree {

        function loop(t:JNodeBase):Tree {
            if (t.name == "token") {
                var tok:JToken = cast t;
                var trivia = tok.trivia;
                return {
                    kind: Token(tok.token, if (trivia == null) {} else trivia),
                    start: tok.start,
                    end: tok.end,
                };
            } else {
                var tok:JNode = cast t;
                var start = -1, end = -1;
                var children = [];
                if (tok.sub != null) {
                    for (elem in tok.sub) {
                        if (elem == null) continue;
                        var t = loop(elem);
                        children.push(t);
                        if (start == -1 || t.start < start)
                            start = t.start;
                        if (end == -1 || t.end > end)
                            end = t.end;
                    }
                }
                return {
                    kind: Node(tok.name, children),
                    start: start,
                    end: end,
                };
            }
        }

        return loop(input);
    }

    public static function parse(input:JResult) {
        return parseTree(input.document.tree);
    }
}
