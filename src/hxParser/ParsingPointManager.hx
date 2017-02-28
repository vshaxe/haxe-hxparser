package hxParser;

import hxParser.ParseTree;
import hxParser.HxParser;

private typedef ParsingPoint = {
    start:Int,
    end:Int,
    entryPoint:EntryPoint,
    callback:JResult -> Void
}

class ParsingPointManager extends hxParser.StackAwareWalker {
    var parsingPoints:Array<ParsingPoint>;
    var currentPoint:Null<ParsingPoint>;

    public override function new() {
        parsingPoints = [];
    }

    override function walkToken(token:Token, stack:WalkStack) {
        if (currentPoint != null) {
            currentPoint.end = token.end;
            if (currentPoint.start == -1 || token.start < currentPoint.start) {
                currentPoint.start = token.start;
            }
        }
    }

    override function walkClassField(node:ClassField, stack:WalkStack) {
        var callback = switch (stack) {
            case Element(id, Edge("fields", Node(ClassDecl(c), _))):
                function(newTree:JResult) {
                    c.fields[id] = hxParser.Converter.convertResultToClassFields(newTree)[0];
                }
            case _: throw "Errrr...";
        }
        var point = { start: -1, end: -1, entryPoint: ClassFields, callback: callback };
        currentPoint = point;
        super.walkClassField(node, stack);
        parsingPoints.push(currentPoint);
        currentPoint = null;
    }

    public function findEnclosing(start:Int, end:Int) {
        for (point in parsingPoints) {
            if (point.start <= start && point.end >= end) {
                return { start:point.start, end:point.end, name:point.entryPoint, callback:point.callback };
            }
        }
        return null;
    }
}