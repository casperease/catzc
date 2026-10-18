# pwsh/Catzc.Base.Files/types/InputStamp.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static string Compute(string[] paths, string filter, string[]...`, written with `//`.

```text
A path under the root is named relative to it with '/' separators, a path outside it in full; a file's content is hashed with its
carriage returns removed, so a clone, a snapshot, a CRLF checkout and a touch all stamp the same. An exclude is a wildcard
(* and ?, a backtick escapes the next character) matched against the full path with '/' separators, ignoring case.
```
