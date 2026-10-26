# pwsh/Catzc.Base.Git/tests/Push-Topic.Flow.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'The git topic flow over a scratch server'`, written with `#`.

```text
A scratch server and clones are made and driven with real git (clone, rebase, push, rev-parse), so the point of the
file is the launch: L2.
```

## comment:2

Above `$script:nowhere = Join-Path $TestDrive 'not-a-repository'`, written with `#`.

```text
Every flow command names its clone; a git call that fell back to the loaded repository would land here and
fail.
```
