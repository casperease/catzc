# pwsh/Catzc.Base.Globs/Get-ModuleGlobSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the DERIVED globsets — the live/tests aspect sets per module folder, one set per internal .psm1 module, the reserved infra
umbrellas, and the 'module-leftovers' catch-all.

### description

Derived sets are never written in globs.yml: the folder (or file) is the registration. Every module folder the resolver (Get-CatzcModule)
finds in the code track partitions into live/tests aspect sets ([ADR-DSGN-ASPECT](../../../adr/design/module-aspects.md)), named by the
readme-kebab convention plus the aspect (Catzc.Base.Globs -> 'catzc-base-globs-live' and 'catzc-base-globs-tests') — 'live' the module's
shippable surface (functions, private helpers, types, configs), 'tests' its verification harness, plus its Go, Python and Bash test folders
`<root>/tests/<kebab>/` of each language root when they exist
([ADR-AUTO-GO-ONEGOROOT](../../../adr/automation/go/go-test-artifacts.md#rule-adr-auto-go-onegoroot),
[ADR-AUTO-PY-ONEPYTHONROOT](../../../adr/automation/python/python-test-artifacts.md#rule-adr-auto-py-onepythonroot),
[ADR-AUTO-BASH-ONEBASHROOT](../../../adr/automation/bash/bash-test-artifacts.md#rule-adr-auto-bash-onebashroot)); the two are disjoint and cover the folder. The
whole-module set is their union (a test-only change never re-keys live). Every internal shared module `pwsh/.internal/<Name>.psm1` derives a
single-file set (no tests aspect) by the same kebab convention (Catzc.Internal.Bootstrap -> 'catzc-internal-bootstrap'). The reserved names
cover the dot-prefixed infrastructure every module's test results also depend on: 'internal', 'vendor', 'compiled', 'scriptanalyzer'.
Derived sets bound the scope of protection and blast radius
([ADR-REPO-PROTGLOB-DERIVEDMODULEGLOBSETS](../../../adr/repository/protected-globs.md#rule-adr-repo-protglob-derivedmoduleglobsets)). A declared globset may not shadow a derived
name; the collision throws here, naming both sides.

The derived sets are repository-relative globs over the source tree's module folders (git-tracked paths), so it stops with a named error in
build mode (Assert-SourceTree, [ADR-DSGN-RUNMODE](../../../adr/design/run-modes.md)).

### parameter `Name`

A module folder name ('Catzc.Base.Globs'), an internal module name ('Catzc.Internal.Bootstrap'), the kebab form of either
('catzc-base-globs', 'catzc-internal-bootstrap'), or a reserved infra name ('internal', 'vendor', 'compiled', 'scriptanalyzer'). Omit for
every derived set.

### example 1

```powershell
Get-ModuleGlobSet -Name Catzc.Base.Globs
```

### example 2

```powershell
(Get-ModuleGlobSet -Name compiled).Matches('pwsh/.compiled/Catzc.Types.abc12345.dll')
```

## comment:1

Above `foreach ($reservedName in [Catzc.Base.Globs.GlobsConfig]::ReservedNames) {`, written with `#`.

```text
The reserved umbrellas are cross-cutting check surfaces, not independent modules: 'internal' overlaps
every catzc-internal-* single-file set, 'vendor'/'compiled'/'scriptanalyzer' cover whole dot-folders.
They are loose-filesets ([ADR-FLOW-CD-GLOBS-EVERYSETHASLAYER](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs-everysethaslayer),
overlap-exempt), not the 'module' layer whose sets are the
pairwise-disjoint per-folder modules
([ADR-FLOW-CD-GLOBS-NOOVERLAPWITHINLAYER](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs-nooverlapwithinlayer)).
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
[ADR-AUTO-GO-ONEGOROOT](/docs/adr/automation/go/go-test-artifacts.md#rule-adr-auto-go-onegoroot),
[ADR-AUTO-PY-ONEPYTHONROOT](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py-onepythonroot),
[ADR-AUTO-BASH-ONEBASHROOT](/docs/adr/automation/bash/bash-test-artifacts.md#rule-adr-auto-bash-onebashroot)) are part of its tests
aspect: a change to them re-keys the module they verify,
never its live aspect.
```

## comment:4

Above `foreach ($module in $codeModules.Where({ $_.shape -ceq 'file' })) {`, written with `#`.

```text
The internal shared modules: one single-file set per pwsh/.internal/<Name>.psm1 — the file is
the registration, exactly as the folder is for a module. The whole-folder 'internal' scope above
remains the protection dependency; these carry the per-module identity.
```

## comment:5

Above `if ('module-leftovers' -in $declaredNames) {`, written with `#`.

```text
The module layer's catch-all: every tracked file under pwsh/ that no per-folder module owns and
that is not dot-folder infrastructure (the reserved umbrellas' loose-fileset territory). It exists so
the module layer covers module-space and a stray file cannot go unmapped — it should be empty in a
clean tree, but stuff can pop up (a file dropped at pwsh/'s root, a folder not yet a module). Its
OWN excludes are every module folder plus the four dot-folders, so it stays disjoint from every module
set ([ADR-FLOW-CD-GLOBS-NOOVERLAPWITHINLAYER](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs-nooverlapwithinlayer)). Derived, module-layer,
never declared; a declared set may not shadow it.
```

## comment:6

Above `$leftoverExcludes = @($moduleFolderGlobs) + @($reserved.Values)`, written with `#`.

```text
Ordinal-sorted so the scan program (the marker body) is byte-identical on every machine, independent of
directory-enumeration and hashtable order.
```
