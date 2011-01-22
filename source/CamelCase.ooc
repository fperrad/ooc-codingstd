
import io/FileReader
import os/Process
import structs/ArrayList
import text/Regexp
import text/StringTokenizer

rx := Regexp compile("([A-Za-z_][\\w_?]*)\\s*:=?\\s*((abstract|extern(\\([^)]*\\))?|inline|static)\\s+)?([\\w_?-]+)")
comment := Regexp compile("(^\\s+\\*|/[/*])")
ternaryOp := Regexp compile("\\?[^:]+:")
capsWithUnderscore := Regexp compile("^[0-9A-Z_]+$")
lowerCamelCase := Regexp compile("^_*[a-z][0-9A-Za-z]*[_?]*$")
upperCamelCase := Regexp compile("^[A-Z][0-9A-Za-z]*$")

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
            if (m != null && comment matches(line) == null &&
                             ternaryOp matches(line) == null) {
                idf := m group(1)
                modifier := m group(2)
                word := m group(5)
                if (modifier startsWith?("extern")) {
                }
                else if (word == "const") {
                    if (capsWithUnderscore matches(idf) == null) {
                        "#BAD_CONST_NAME %s:%d %s %s" format(fname, i, idf, word) println()
                        "# %s" format(line) println()
                        res = false
                    }
                }
                else if (word == "abstract" ||
                         word == "class" ||
                         word == "cover" ||
                         word == "enum" ||
                         word == "interface") {
                    if (upperCamelCase matches(idf) == null) {
                        "#BadClassName %s:%d %s %s" format(fname, i, idf, word) println()
                        "# %s" format(line) println()
                        res = false
                    }
                }
                else {
                    if (lowerCamelCase matches(idf) == null) {
                        "#badIdentifier %s:%d %s %s" format(fname, i, idf, word) println()
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
