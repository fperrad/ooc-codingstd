
import io/FileReader
import os/Process
import structs/ArrayList
import text/StringTokenizer

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
    if (fname endsWith?(".h"))
        return false
    if (fname contains?("/art/"))
        return false
    return true
}

check: func(fname: String) -> Bool {
    file := FileReader new(fname, "rt")
    res := true
    i := 1
    file eachLine(
        func(line: String) -> Bool {
            if (line endsWith?(" ")) {
                "# %s:%d" format(fname, i) println()
                res = false
            }
            i += 1
            return true
        }
    )
    file close()
    return res
}
