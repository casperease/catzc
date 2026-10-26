# pwsh/Base.QualityGates/Assert-IdiomaticNames.ps1

The throwing form of the naming check: it asserts that every tracked file and the folders that hold it are named in the idiom of the file's
language, and throws when one is not.

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
