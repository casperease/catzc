# pwsh/Catzc.Base.QualityGates/Repair-IdiomaticNames.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Moves each misnamed folder and file on disk to the name its language's idiom gives it, and lists every tracked file that names the old path.

### description

The repair half of the quality gate Test-IdiomaticNames
([ADR-AUTO-IDIOM-HELDBYGATE](../../../drs/automation/idiomatic-names.md#rule-adr-auto-idiom-heldbygate)): the gate reports a folder or a
file whose name breaks its language's case, and this moves it to the rendering the languages config gives
(LanguagesConfig.MisnamedPathRenames). Files move first and folders deepest first, so no move invalidates another; each move goes through a
temporary name, so a case-only rename lands on a case-insensitive file system. It edits no file's text: each result lists the tracked files
whose text names the old path, for one-file-at-a-time edits, and git records the moves when the user commits them.

### parameter `DryRun`

Return the planned moves and the files that name each old path, and move nothing
([ADR-PWSH-DRYRUN](../../../drs/automation/pwsh/prefer-dryrun-over-shouldprocess.md)).

### outputs

`[pscustomobject]` { Kind, Path, Target, Language, NamedBy, Moved }, one per move, in the order they run.

### example 1

```powershell
Repair-IdiomaticNames -DryRun
```
