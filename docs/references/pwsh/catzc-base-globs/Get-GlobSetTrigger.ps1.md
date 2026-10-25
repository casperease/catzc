# pwsh/Catzc.Base.Globs/Get-GlobSetTrigger.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Projects a globset's scan program into vendor-native pipeline path filters — the no-start trigger.

### description

The pipeline trigger: project the set's flattened scan program
([FDR-CD-GLOBS-TRACKEDFILESONLY](../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-trackedfilesonly)/8) straight into the vendor's
own `paths` filter, so the trigger fires — or does not start at all — on the real files, with no committed hash to go stale across a squash
or concurrent merge.

Two dialects, from the one program:

- GitHub `on.*.paths`: the program in order, each '-' rule rendered as a '!' negation. GitHub paths are ordered and last-match-wins — the
  same evaluator as GlobSet.Matches — so this projection is EXACT.
- Azure DevOps `trigger.paths.include`/`exclude`: order-independent (union include minus union exclude). Each pattern is collapsed to its
  LAST select in the program, so a base exclude that a later compose include re-adds (e.g. '- `configuration/*/**`' then '+
  `configuration/apex/**`') nets to an include — the order-independent lists then reproduce the last-match-wins result. ADO's documented
  rule that a deeper include overrides a broader exclude carries the compose re-add. A set whose ADO projection cannot reproduce exact
  membership (a root-glob re-added over an equal-depth exclude) is caught by the superset integrity test, not here; this function only
  performs the mechanical projection.

It rests on [FDR-CD-GLOBS-NAMEDGLOBSETS](../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-namedglobsets) and
[FDR-CD-GLOBS-NATIVEPATHFILTER](../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-nativepathfilter).

### parameter `Name`

The declared globset to project.

### parameter `GlobSet`

A `[Catzc.Base.Globs.GlobSet]` to project instead (the path a derived set takes).

### outputs

`[pscustomobject]` { Name; GitHub = `[string[]]` ordered paths; AdoInclude = `[string[]]`; AdoExclude = `[string[]]` }.

### example 1

```powershell
Get-GlobSetTrigger -Name apex
```

### example 2

```powershell
(Get-GlobSetTrigger -Name automation).GitHub
```
