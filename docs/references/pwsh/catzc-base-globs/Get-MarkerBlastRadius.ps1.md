# pwsh/Base.Globs/Get-MarkerBlastRadius.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Answers "which areas-of-control do these changes touch?" — one row per matched globset.

### description

The blast-radius query (the third marker role,
[FDR-CD-GLOBS-NAMEDGLOBSETS](../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-namedglobsets)): maps changed files onto every globset
whose effective membership matches at least one of them — the declared registry (tracks, deployable-units, scopes; compose-aware) AND the
derived module sets ([ADR-REPO-PROTGLOB](../../../drs/repository/protected-globs.md)), so the answer covers both "which pipelines/units this
fires" (Pipeline) and "which tests verify it" (the derived module rows name the modules for Test-Automation -Modules; a declared row's
VerifyModules/VerifyLevel carry its configured verify scope — its test suite, run by name with Test-Automation -Suite).

### parameter `ChangedFile`

The changed files, repo-relative and '/'-separated (backslashes are normalized).

### parameter `Ref`

A git ref to diff the working tree against (`git diff --name-only <ref>`) instead of naming files — e.g. 'main' answers "what does my branch
touch".

### outputs

`[pscustomobject]` per matched set: Name, Layer, Pipeline, VerifyModules, VerifyLevel — declared sets first (registry order), then the
derived module sets, each set at most once.

### example 1

```powershell
Get-MarkerBlastRadius -ChangedFile 'infrastructure/modules/vnet.bicep'
```

### example 2

```powershell
Get-MarkerBlastRadius -Ref main
```

## comment:1

Above `foreach ($set in @(Get-GlobSet) + @(Get-ModuleGlobSet)) {`, written with `#`.

```text
Declared sets first (registry order), then the derived module sets — the same one-answer-per-set
shape either way.
```
