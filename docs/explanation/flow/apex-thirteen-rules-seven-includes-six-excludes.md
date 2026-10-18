# The apex unit flattens to 13 rules, 13 GitHub paths, and 7 Azure DevOps includes with 6 excludes

```text
The apex unit flattens to 13 rules, 13 GitHub paths, and 7 ADO includes with 6 excludes.

1   globs.yml                    apex: pipeline cd-apex, composes three bases, three own includes
2   GlobSet.ScanProgram()        composed programs first, own rules last, duplicates deduped
3   flattened scan program       13 rules: 4 foundation, 3 discovery, 3 expedition, 3 apex
4   Get-GlobSetTrigger           one pass over the program fills both dialects
5   .GitHub                      the 13 rules in order, each drop as a ! negation
6   .AdoInclude                  7 patterns whose last select is a select
7   .AdoExclude                  6 patterns whose last select is a drop
8   pipelines/cd-apex.yaml       trigger: and pr: declare the 7 includes and 6 excludes
9   Get-PipelineTrigger          reads the four path-filter lists back from the file
10  Test-AdoPipelineTriggerGlob  compares projection and file as sets; one issue per pipeline

Supports ADR-FLOW-CD-GLOBS-TRACKEDFILESONLY, ADR-FLOW-CD-GLOBS-NATIVEPATHFILTER and ADR-FLOW-CD-GLOBS-COMPOSESETS (implementation lens).
```

The `apex` deployable unit in cats composes three base units and adds three configuration folders of its own, which flattens into a program
of 13 rules. `Get-GlobSetTrigger` walks that program once: the GitHub list is the 13 rules in order, and the Azure DevOps lists collapse the
13 rules to 7 includes and 6 excludes because the same pattern is never selected twice. `pipelines/cd-apex.yaml` declares exactly those 13
patterns, and `Test-AdoPipelineTriggerGlob` is the quality gate that proves it.

![apex: 13 rules, 13 GitHub paths, 7 ADO includes and 6 excludes](.assets/apex-thirteen-rules-seven-includes-six-excludes/diagram.drawio.png)

The diagram is described element by element in
[its asset description](.assets/apex-thirteen-rules-seven-includes-six-excludes/diagram.drawio.md).

## Walkthrough

1. **globs.yml.** `apex` is a `deployable-unit` with `pipeline: cd-apex`. It composes `template-azure-subscription-foundation`,
   `template-azure-subscription-discovery` and `template-azure-workload-expedition`, and includes
   `infrastructure/templates/<template>/configuration/apex/**` for each of the three templates. The foundation base includes
   `infrastructure/templates/foundation/**` and `infrastructure/modules/**` and excludes the configuration root files and the configuration
   subfolders; discovery composes foundation, and expedition composes discovery.
2. **GlobSet.ScanProgram().** `GlobsConfig` resolves the compose references at load and hands each set its composed sets. `ScanProgram()`
   appends the composed sets' programs first, in compose order and recursively, then the set's own includes as selects and excludes as
   drops, last. Because discovery repeats foundation and expedition repeats both, the raw list carries the foundation rules three times;
   `DedupeKeepingLast` keeps the last occurrence of each identical rule. The program is built once and cached.
3. **Flattened scan program.** For `apex` the result is 13 rules: foundation's two selects and two drops, discovery's select and two drops,
   expedition's select and two drops, then apex's three selects, which re-add the `configuration/apex/**` slices the bases dropped. Over the
   tracked files it selects 32 members.
4. **Get-GlobSetTrigger.** `Get-GlobSetTrigger -Name apex` resolves the set and iterates `ScanProgram()` once. Each rule is appended to the
   GitHub list as it is, and an ordered map records each pattern's last select. `-GlobSet` takes a set object instead, the path a derived
   set and the gates use.
5. **.GitHub.** The 13 rules in order, a drop rendered as `!` before the pattern. GitHub evaluates its paths last-match-wins, so this list
   is the program itself.
6. **.AdoInclude.** The 7 patterns whose last select is a select: the four template and module globs and the three `configuration/apex/**`
   slices.
7. **.AdoExclude.** The 6 patterns whose last select is a drop: each template's `configuration/*.yml` and `configuration/*/**`. Azure DevOps
   keeps the deeper `configuration/apex/**` include over the broader `configuration/*/**` exclude.
8. **pipelines/cd-apex.yaml.** The root pipeline declares the 7 includes and 6 excludes under both `trigger.paths` and `pr.paths`, as the
   triggers are honoured only at the pipeline root.
9. **Get-PipelineTrigger.** The gate reads the file with `-Vendor Ado` and gets the four lists back: `TriggerInclude`, `TriggerExclude`,
   `PrInclude` and `PrExclude`; a missing section is an empty list.
10. **Test-AdoPipelineTriggerGlob.** For every pipeline-bound set, or the one named, the gate recomputes the projection with
    `Get-GlobSetTrigger -GlobSet`, resolves `pipelines/<pipeline>.yaml`, and compares each of the four lists with `Test-GlobListEqual` as a
    set, ordinally sorted, because Azure DevOps filters are order-independent. A missing file is one issue, a mismatch is one issue naming
    the filters that differ, and `Write-QualityGateReport` ends the gate. Today it reports 0 issues over 6 pipelines, and the L2 integrity
    test requires exactly that.

## Why it holds

- Membership is decided by the ordered scan program, last-match-wins, with the leaf set's includes as selects and its excludes as drops
  (ADR-FLOW-CD-GLOBS-TRACKEDFILESONLY).
- The native projection renders the flattened program into GitHub's ordered `!` dialect exactly, and into Azure DevOps' order-independent
  include and exclude lists by collapsing each pattern to its last select; the drift quality gate reports one issue per pipeline whose
  declared trigger no longer equals its projection (ADR-FLOW-CD-GLOBS-NATIVEPATHFILTER).
- A composing set's program is the composed programs first, deepest base first, each once, then its own rules last, so a unit re-adds a
  slice its base dropped; the flattened program is what the projection is computed from (ADR-FLOW-CD-GLOBS-COMPOSESETS).

## See also

- [Globset triggers](../../adr/flow/durable-sha-globs.md) — the decision this article explains.
- The other lenses on the same projection: [meta](one-program-two-vendor-dialects.md),
  [architecture](globs-projects-and-three-consumers-read.md), [operations](print-projection-then-drift-names-the-filter.md) and
  [governance](drift-is-gated-generation-is-adr-only.md).
- [The flow explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
