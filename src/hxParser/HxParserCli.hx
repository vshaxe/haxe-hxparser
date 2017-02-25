package hxParser;

import js.node.ChildProcess;
import js.node.child_process.ChildProcess.ChildProcessEvent;
import js.node.stream.Readable;
import util.Result;

class HxParserCli {
    public static function parse(hxparserPath:String, src:String, handler:Result<JResult>->Void) {
        var data = "";
        var cp = ChildProcess.spawn(hxparserPath, ["--recover", "--json", "<stdin>"]);
        cp.stdin.end(src);
        cp.stdout.on(ReadableEvent.Data, function(s:String) data += s);
        cp.on(ChildProcessEvent.Close, function(code, _) {
            if (code != 0)
                handler(Failure("Exit code " + code));
            handler(Success(haxe.Json.parse(data)));
        });
    }
}
