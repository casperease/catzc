# pwsh/Base.Globs/configs/file-kinds.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `kinds:`, written with `#`.

```text
The one definition of what a file is, by role. A kind names the role and never the language, track or module, which are keys of their own
in a file's head. Kinds are checked in the order written: the first whose globs, or whose subkinds' globs, match a path names it, and a
file no entry selects is `other`. A consumer extends this in a config fragment, which adds a kind (checked after these) or replaces the
globs of one.
```

## comment:2

Above `overlaps:`, written with `#`.

```text
The intended overlaps, [earlier, later]: the earlier kind takes most of the later kind's files on purpose, since the later one is the
catch-all of its tree; a kind mostly shadowed by a pair not listed here fails Test-FileKindReachability.
```
