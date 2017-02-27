package hxParser;

enum WalkStack {
    Item(edge:String, parent:WalkStack);
    Element(index:Int, parent:WalkStack);
    Root;
}
