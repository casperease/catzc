---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md
    kind: comment-page
    body_sha: efd41089d13f
    adrs:
      - ADR-AUTO-BASH#2
      - ADR-AUTO-GO#2
      - ADR-AUTO-PY#2
      - ADR-FLOW-CD-GLOBS#10
      - ADR-FLOW-CD-GLOBS#7
---

# automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `foreach ($reservedName in [Catzc.Base.Globs.GlobsConfig]::ReservedNames) {`, written with `#`.

```text
The reserved umbrellas are cross-cutting check surfaces, not independent modules: 'internal' overlaps
every catzc-internal-* single-file set, 'vendor'/'compiled'/'scriptanalyzer' cover whole dot-folders.
They are loose-filesets ([ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7),
overlap-exempt), not the 'module' layer whose sets are the
pairwise-disjoint per-folder modules
([ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)).
```

## comment:2

Above `$aspectList = [System.Collections.Generic.List[Catzc.Base.Globs.Aspect]]::new()`, written with `#`.

```text
The aspect convention ([ADR-DSGN-ASPECT](/docs/adr/design/module-aspects.md)): each module folder partitions into
disjoint, exhaustive aspect sets
(live/tests by default) from the 'aspects' variant. The whole-module set is the union of its aspects
(a shipped module = 1 live + 1 tests, isolated: a test-only change never re-keys live). Compiled per
unit root by AspectPartition.
```

## comment:3

Above `$goRoot = (Get-Config -Config go).ResolveRoot((Get-RepositoryRoot))`, written with `#`.

```text
A module's Go, Python and Bash test folders (<root>/tests/<kebab>/ of each language root,
[ADR-AUTO-GO#2](/docs/adr/automation/go/go-test-artifacts.md#rule-adr-auto-go2),
[ADR-AUTO-PY#2](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py2),
[ADR-AUTO-BASH#2](/docs/adr/automation/bash/bash-test-artifacts.md#rule-adr-auto-bash2)) are part of its tests
aspect: a change to them re-keys the module they verify,
never its live aspect.
```

## comment:4

Above `$internalRoot = [System.IO.Path]::Combine($automationRoot, '.internal')`, written with `#`.

```text
The internal shared modules: one single-file set per automation/.internal/<Name>.psm1 — the file is
the registration, exactly as the folder is for a module. The whole-folder 'internal' scope above
remains the protection dependency; these carry the per-module identity.
```

## comment:5

Above `if ('module-leftovers' -in $declaredNames) {`, written with `#`.

```text
The module layer's catch-all: every tracked file under automation/ that no per-folder module owns and
that is not dot-folder infrastructure (the reserved umbrellas' loose-fileset territory). It exists so
the module layer covers module-space and a stray file cannot go unmapped — it should be empty in a
clean tree, but stuff can pop up (a file dropped at automation/'s root, a folder not yet a module). Its
OWN excludes are every module folder plus the four dot-folders, so it stays disjoint from every module
set ([ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)). Derived, module-layer,
never declared; a declared set may not shadow it.
```

## comment:6

Above `$leftoverExcludes = @($moduleFolderGlobs) + @($reserved.Values)`, written with `#`.

```text
Ordinal-sorted so the scan program (the marker body) is byte-identical on every machine, independent of
directory-enumeration and hashtable order.
```
