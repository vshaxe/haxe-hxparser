package hxParser;

class WalkStackTools {
    public static function print(stack:WalkStack):String {
        var reverseStack = [];
        function loop(stack:WalkStack) {
            reverseStack.push(switch (stack) {
                case Edge(edge, parent):
                    loop(parent);
                    'Edge($edge)';
                case Element(index, parent):
                    loop(parent);
                    'Element($index)';
                case Node(kind, parent):
                    loop(parent);
                    'Node(${kind.getName()})';
                case Root:
                    "Root";
            });
        }
        loop(stack);
        var buf = new StringBuf();
        var indent = "";
        for (item in reverseStack) {
            buf.add(indent);
            buf.add(item);
            buf.add("\n");
            indent += "  ";
        }
        return buf.toString();
    }

    public static inline function dump(stack:WalkStack) {
        Sys.println(print(stack));
    }
}