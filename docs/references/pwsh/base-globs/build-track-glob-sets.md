# pwsh/Base.Globs/Build-TrackGlobSets.ps1

The generator of `track-sets.yml`: it derives the patterns of every globset that `globs.yml` declares for a whole track, so no one writes
them by hand ([FDR-GLOBS-TRACKSETDERIVED](../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-tracksetderived)). The help below describes
how.

## help

### synopsis

Writes track-sets.yml: the derived patterns of every globset that globs.yml declares for a whole track.

### description

A globset that names a `track` in globs.yml is derived from the track, not written by hand
([FDR-GLOBS-TRACKSETDERIVED](../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-tracksetderived)). The declarations are read from the
authored globs.yml alone, since the merged config needs the part this writes. For each such set, the track's members give the patterns: a
member folder is included as `<path>/**`, and a generated member is excluded. Under each of the track's places, every generated target of a
`rollable` or `untracked` writer is excluded, while a `snapshot` or `import-critical` one stays in the set, so a change to it still triggers
CI ([ADR-REPO-ROOTCFG-ONECLASSPERWRITER](../../../drs/repository/generated-root-configs.md#rule-adr-repo-rootcfg-oneclassperwriter)). Every
nested track whose own set starts a pipeline for it is excluded too, and a nested track without one keeps its files in the parent's set. A
set that names a track variants.yml does not declare throws. The file is written with its generated head through Write-FileIfChanged, so an
unchanged result leaves it untouched.

### parameter `DryRun`

Report what would change without writing.

### parameter `Silent`

Print no line when the file changes.

### parameter `PassThru`

Return the result object.

### outputs

`[pscustomobject]` With -PassThru: `Path` (track-sets.yml, repository-relative), `Changed` and `DryRun`.

### example 1

```powershell
Build-TrackGlobSets -DryRun -PassThru
```
