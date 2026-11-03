# pwsh/Base.Overlay/tests/Consumer.L2.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `foreach ($step in @(@('init', '-q'), @('add', '-A'), @('update-index',...`, written with `#`.

```text
A consumer is a git checkout, so the fixture is one: the gates that list tracked files read its index.
The bash module's script carries its executable bit in the index, as git stores a consumer's script.
```

## comment:2

Above `'.gitignore'                                    =...`, written with `#`.

```text
A repository ignores its output folder: the install's first import writes the writers' memo under it before the fixture adds its files.
A consumer keeps its generated banner files out of git (a banner carries no body hash), as catzc's own .gitignore does.
```
