# pwsh/Catzc.Base.QualityGates/Assert-IdiomaticNames.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Asserts every tracked file and the folders that hold it are named in the idiom of the file's language; throws when one is not.

### description

The throwing counterpart of Test-IdiomaticNames; both judge the tracked files through one check (LanguagesConfig.MisnamedPaths), so they can
never disagree ([ADR-AUTO-IDIOM-HELDBYGATE](../../../drs/automation/idiomatic-names.md#rule-adr-auto-idiom-heldbygate)). The error names the
count and lists every misnamed folder and file. Succeeds silently — the absence of an error is the output. Needs the source tree
(Assert-SourceTree).

### example 1

```powershell
Assert-IdiomaticNames
```
