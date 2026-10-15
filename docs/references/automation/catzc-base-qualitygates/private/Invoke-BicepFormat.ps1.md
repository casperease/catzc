# docs/references/automation/catzc-base-qualitygates/private/Invoke-BicepFormat.ps1.md

`automation/Catzc.Base.QualityGates/private/Invoke-BicepFormat.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
One Format-Code engine adapter ([ADR-PRIN-CONFIG#2](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config2)).
The Bicep CLI is the one at the tools.yml pin (Install-Bicep), never whichever bicep is first on PATH; a missing or
off-pin CLI throws, naming Install-Bicep.

The CLI starts slowly, so it runs once for all the files: each is copied into a temporary folder, `bicep format
--pattern` formats the copies in one process, and each copy is compared byte for byte with its file, so -DryRun
never touches the file; without -DryRun a changed copy replaces it. The copies sit outside the repository, so the
formatter sees no bicepconfig.json there; the repository has none, and one that sets formatting options would be
listed in the engine's `settings:` in languages.yml and passed here first.
```
