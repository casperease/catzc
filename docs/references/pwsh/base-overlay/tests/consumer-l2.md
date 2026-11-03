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

Above `'Test-JavaScriptTypes'`, written with `#`.

```text
The rendered jsconfig.json names the node types under .typescript/node_modules, a per-machine install a consumer root lacks:
the vendored type packages (task-user-runs-and-commits, step 3) take their place.
```
