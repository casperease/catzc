# pwsh/Catzc.Base.Drs/private/Get-DrsDanglingCodeViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$pattern = "(?<![\w-])$($Adrs.CodeForm.Cited)(?![\w#-]|:\d)"`, written with `#`.

```text
A code named in prose is a citation like a link: one that names no registered rule, record or domain dangles. Fenced blocks are
examples, so they are left out, and a code followed by '#' or ':<n>' is another form the code-language check owns.
```

## comment:2

Above `$fence = $null`, written with `#`.

```text
A fence closes only on a bare run of its own character at least as long as the one that opened it, so a four-tick fence can hold
a three-tick example whole.
```
