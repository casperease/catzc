---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md
    kind: comment-page
    body_sha: "47dbc5774f08"
    adrs:
      - ADR-AUTO-BASH#2
      - ADR-AUTO-GO#2
      - ADR-AUTO-PY#2
      - ADR-FLOW-CD-GLOBS#10
      - ADR-FLOW-CD-GLOBS#7
      - ADR-REPO-PROTGLOB#7
---

# automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Derived sets are never written in globs.yml: the folder (or file) is the registration. Every non-dot
module folder under automation/ partitions into live/tests aspect sets
([ADR-DSGN-ASPECT](/docs/adr/design/module-aspects.md)), named by the
readme-kebab convention plus the aspect (Catzc.Base.Globs -> 'catzc-base-globs-live' and
'catzc-base-globs-tests') — 'live' the module's shippable surface (functions, private helpers, types,
configs), 'tests' its verification harness, plus its Go, Python and Bash test folders <root>/tests/<kebab>/ of
each language root when they exist ([ADR-AUTO-GO#2](/docs/adr/automation/go/go-test-artifacts.md#rule-adr-auto-go2),
[ADR-AUTO-PY#2](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py2),
[ADR-AUTO-BASH#2](/docs/adr/automation/bash/bash-test-artifacts.md#rule-adr-auto-bash2)); the two are disjoint and
cover the folder. The whole-module
set is their union (a test-only change never re-keys live). Every internal
shared module automation/.internal/<Name>.psm1 derives a single-file set (no tests aspect) by the same
kebab convention (Catzc.Internal.Bootstrap -> 'catzc-internal-bootstrap').
The reserved names cover the dot-prefixed infrastructure every module's test results also depend on:
'internal', 'vendor', 'compiled', 'scriptanalyzer'. Derived sets bound the scope of protection and blast radius
([ADR-REPO-PROTGLOB#7](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob7)). A declared globset may not
shadow a derived name; the collision throws here, naming
both sides.

The derived sets are repository-relative globs over the source tree's module folders (git-tracked
paths), so it stops with a named error in build mode (Assert-SourceTree,
[ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)).
```

## comment:2

Section `.PARAMETER Name` of the comment-based help.

```text
A module folder name ('Catzc.Base.Globs'), an internal module name ('Catzc.Internal.Bootstrap'), the
kebab form of either ('catzc-base-globs', 'catzc-internal-bootstrap'), or a reserved infra name
('internal', 'vendor', 'compiled', 'scriptanalyzer'). Omit for every derived set.
```

## comment:3

Above `foreach ($reservedName in [Catzc.Base.Globs.GlobsConfig]::ReservedNames) {`.

```text
The reserved umbrellas are cross-cutting check surfaces, not independent modules: 'internal' overlaps
every catzc-internal-* single-file set, 'vendor'/'compiled'/'scriptanalyzer' cover whole dot-folders.
They are loose-filesets ([ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7),
overlap-exempt), not the 'module' layer whose sets are the
pairwise-disjoint per-folder modules
([ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)).
```

## comment:4

Above `$aspectList = [System.Collections.Generic.List[Catzc.Base.Globs.Aspect]]::new()`.

```text
The aspect convention ([ADR-DSGN-ASPECT](/docs/adr/design/module-aspects.md)): each module folder partitions into
disjoint, exhaustive aspect sets
(live/tests by default) from the 'aspects' variant. The whole-module set is the union of its aspects
(a shipped module = 1 live + 1 tests, isolated: a test-only change never re-keys live). Compiled per
unit root by AspectPartition.
```

## comment:5

Above `$goRoot = (Get-Config -Config go).ResolveRoot((Get-RepositoryRoot))`.

```text
A module's Go, Python and Bash test folders (<root>/tests/<kebab>/ of each language root,
[ADR-AUTO-GO#2](/docs/adr/automation/go/go-test-artifacts.md#rule-adr-auto-go2),
[ADR-AUTO-PY#2](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py2),
[ADR-AUTO-BASH#2](/docs/adr/automation/bash/bash-test-artifacts.md#rule-adr-auto-bash2)) are part of its tests
aspect: a change to them re-keys the module they verify,
never its live aspect.
```

## comment:6

Above `$internalRoot = [System.IO.Path]::Combine($automationRoot, '.internal')`.

```text
The internal shared modules: one single-file set per automation/.internal/<Name>.psm1 — the file is
the registration, exactly as the folder is for a module. The whole-folder 'internal' scope above
remains the protection dependency; these carry the per-module identity.
```

## comment:7

Above `if ('module-leftovers' -in $declaredNames) {`.

```text
The module layer's catch-all: every tracked file under automation/ that no per-folder module owns and
that is not dot-folder infrastructure (the reserved umbrellas' loose-fileset territory). It exists so
the module layer covers module-space and a stray file cannot go unmapped — it should be empty in a
clean tree, but stuff can pop up (a file dropped at automation/'s root, a folder not yet a module). Its
OWN excludes are every module folder plus the four dot-folders, so it stays disjoint from every module
set ([ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)). Derived, module-layer,
never declared; a declared set may not shadow it.
```

## comment:8

Above `$leftoverExcludes = @($moduleFolderGlobs) + @($reserved.Values)`.

```text
Ordinal-sorted so the scan program (the marker body) is byte-identical on every machine, independent of
directory-enumeration and hashtable order.
```

## comment:9

Above `foreach ($reservedName in [Catzc.Base.Globs.GlobsConfig]::ReservedNames) {`.

```text
The reserved umbrellas are cross-cutting check surfaces, not independent modules: 'internal' overlaps
every catzc-internal-* single-file set, 'vendor'/'compiled'/'scriptanalyzer' cover whole dot-folders.
They are loose-filesets ([ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7),
overlap-exempt), not the 'module' layer whose sets are the
pairwise-disjoint per-folder modules
([ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)).
```

## comment:10

Above `$aspectList = [System.Collections.Generic.List[Catzc.Base.Globs.Aspect]]::new()`.

```text
The aspect convention ([ADR-DSGN-ASPECT](/docs/adr/design/module-aspects.md)): each module folder partitions into
disjoint, exhaustive aspect sets
(live/tests by default) from the 'aspects' variant. The whole-module set is the union of its aspects
(a shipped module = 1 live + 1 tests, isolated: a test-only change never re-keys live). Compiled per
unit root by AspectPartition.
```

## comment:11

Above `$goRoot = (Get-Config -Config go).ResolveRoot((Get-RepositoryRoot))`.

```text
A module's Go, Python and Bash test folders (<root>/tests/<kebab>/ of each language root,
[ADR-AUTO-GO#2](/docs/adr/automation/go/go-test-artifacts.md#rule-adr-auto-go2),
[ADR-AUTO-PY#2](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py2),
[ADR-AUTO-BASH#2](/docs/adr/automation/bash/bash-test-artifacts.md#rule-adr-auto-bash2)) are part of its tests
aspect: a change to them re-keys the module they verify,
never its live aspect.
```

## comment:12

Above `$internalRoot = [System.IO.Path]::Combine($automationRoot, '.internal')`.

```text
The internal shared modules: one single-file set per automation/.internal/<Name>.psm1 — the file is
the registration, exactly as the folder is for a module. The whole-folder 'internal' scope above
remains the protection dependency; these carry the per-module identity.
```

## comment:13

Above `if ('module-leftovers' -in $declaredNames) {`.

```text
The module layer's catch-all: every tracked file under automation/ that no per-folder module owns and
that is not dot-folder infrastructure (the reserved umbrellas' loose-fileset territory). It exists so
the module layer covers module-space and a stray file cannot go unmapped — it should be empty in a
clean tree, but stuff can pop up (a file dropped at automation/'s root, a folder not yet a module). Its
OWN excludes are every module folder plus the four dot-folders, so it stays disjoint from every module
set ([ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)). Derived, module-layer,
never declared; a declared set may not shadow it.
```

## comment:14

Above `$leftoverExcludes = @($moduleFolderGlobs) + @($reserved.Values)`.

```text
Ordinal-sorted so the scan program (the marker body) is byte-identical on every machine, independent of
directory-enumeration and hashtable order.
```
