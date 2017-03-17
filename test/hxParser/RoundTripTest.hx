package hxParser;

import sys.FileSystem;
import sys.io.File;
using StringTools;

class RoundTripTest {
    static function main() {
        new RoundTripTest().run(Sys.args());
    }

    var successes:Int = 0;
    var failures:Int = 0;

    function new() {}

    function run(paths:Array<String>) {
        function loop(paths:Array<String>) {
            for (path in paths) {
                if (FileSystem.isDirectory(path))
                    loop([for (file in FileSystem.readDirectory(path))
                        if (!isDirectoryIgnored(file)) '$path/$file'
                    ]);
                else
                    try rePrintFile(path)
                    catch (e:Any) {
                        failures++;
                        Sys.println('- ERROR: $e while reprinting \'$path\'');
                    }
            }
        }
        loop(paths);

        var failed = failures > 0;
        Sys.println('\n${if (failed) "FAILED" else "OK"} ${successes + failures} tests, $failures failed, $successes success');
        Sys.exit(if (failed) 1 else 0);
    }

    function isDirectoryIgnored(name:String):Bool {
        return [".git", ".haxelib", "dump", "node_modules"].indexOf(name) != -1;
    }

    function rePrintFile(file:String) {
        if (!file.endsWith(".hx") || file.endsWith(".unit.hx"))
            return;

        var content = File.getContent(file);
        var parsed = HxParser.parse(content);
        switch (parsed) {
            case Success(data):
                var tree = new Converter(data).convertResultToFile();
                if (Printer.print(tree) == content) {
                    successes++;
                } else {
                    Sys.println('- ERROR: \'$file\' is different after reprint');
                    failures++;
                }
            case Failure(reason):
                Sys.println('- ERROR: unable to parse \'$file\' ($reason)');
        }
    }
}