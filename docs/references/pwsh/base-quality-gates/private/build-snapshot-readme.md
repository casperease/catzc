# pwsh/Base.QualityGates/private/Build-SnapshotReadme.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `$pwshEngine = [Catzc.Base.Engines.ExecutionEngines]::Pwsh`, written with `#`.

```text
The snapshot's workers import with -SkipJanitors, so the gitignored generated READMEs are written once here, as a
working tree has them, before any worker starts.
```
