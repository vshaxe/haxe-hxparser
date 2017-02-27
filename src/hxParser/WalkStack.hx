package hxParser;

enum WalkStack {
    Edge(edge:String, parent:WalkStack);
    Element(index:Int, parent:WalkStack);
    Node(kind:NodeKind, parent:WalkStack);
    Root;
}
