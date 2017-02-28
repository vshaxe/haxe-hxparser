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
    var offset:Int;

    public override function new() {
        reset();
    }

    public function reset() {
        parsingPoints = [];
        offset = 0;
    }

    override function walkToken(token:Token, stack:WalkStack) {
        var start = offset;
        inline function updateTrivia(trivia:Trivia) {
            offset += trivia.text.length;
        }
        if (token.leadingTrivia != null) for (trivia in token.leadingTrivia) updateTrivia(trivia);
        offset += !token.appearsInSource() ? 0 : token.text.length;
        if (token.trailingTrivia != null) for (trivia in token.trailingTrivia) updateTrivia(trivia);
         var end = offset;
        if (currentPoint != null) {
            currentPoint.end = end;
            if (currentPoint.start == -1 || start < currentPoint.start) {
                currentPoint.start = start;
            }
        }
    }

    override function walkClassField(node:ClassField, stack:WalkStack) {
        var callback = switch (stack) {
            case Element(id, Edge("fields", Node(ClassDecl({fields: fields}) | AnonymousStructureFields_ClassNotation(fields), _))):
                function(newTree:JResult) {
                    fields[id] = hxParser.Converter.convertResultToClassFields(newTree)[0];
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