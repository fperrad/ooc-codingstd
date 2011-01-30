
import io/FileReader
import os/Process
import structs/ArrayList
import structs/HashMap
import text/Regexp
import text/StringTokenizer

rx := Regexp compile("([A-Za-z_][\\w_?]*)(\\s*)\\(")
comment := Regexp compile("(^\\s*\\*|/[/*])")
keywords := HashMap <String, Bool> new() // control flow + modifier
keywords put("const", true)
keywords put("for", true)
keywords put("if", true)
keywords put("match", true)
keywords put("return", true)
keywords put("while", true)

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
    if (fname endsWith?(".ooc"))
        return true
    return false
}

check: func(fname: String) -> Bool {
    file := FileReader new(fname, "rt")
    res := true
    i := 1
    file eachLine(
        func(line: String) -> Bool {
            m := rx matches(line)
            if (m != null && comment matches(line) == null) {
                idf := m group(1)
                sp := m group(2)
                if (keywords contains?(idf)) {
                    if (sp == "") {
                        "#Space %s:%d %s" format(fname, i, idf) println()
                        "# %s" format(line) println()
                        res = false
                    }
                }
                else {
                    if (sp != "") {
                        "#NoSpace %s:%d %s" format(fname, i, idf) println()
                        "# %s" format(line) println()
                        res = false
                    }
                }
            }
            i += 1
            return true
        }
    )
    file close()
    return res
}
