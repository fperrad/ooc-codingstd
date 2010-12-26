
import io/FileReader
import os/Env
import os/Process
import structs/ArrayList
import text/StringTokenizer

var := Env get("OOC_LINE_LENGTH")
MAX := const (var != null) ? var toInt() : 132

main: func(args: ArrayList<String>) {
    progname := args removeAt(0)
    if (args getSize() == 0)
        args = Process new(["git", "ls-files"]) getOutput() split("\n")

    "1..1" println()
    res := true
    for (fname in args)
        if (filter(fname))
            res &= check(fname)

    if (res)
        ("ok 1 - " + progname) println()
    else
        ("not ok 1 - " + progname) println()
}

filter: func(fname: String) -> Bool {
    if (fname == "")
        return false
    if (fname endsWith?(".a"))
        return false
    if (fname endsWith?(".c"))
        return false
    if (fname endsWith?(".h"))
        return false
    return true
}

check: func(fname: String) -> Bool {
    file := FileReader new(fname, "rt")
    res := true
    i := 1
    file eachLine(
        func(line: String) -> Bool {
            len := line length()
            if (len > MAX) {
                "# %s:%d: %d cols" format(fname, i, len) println()
                res = false
            }
            i += 1
            return true
        }
    )
    file close()
    return res
}
