# pwsh/Base.Globs/Get-ModuleGlobSet.ps1

The resolver of the derived globsets: the folder, or the file, is the registration, so no set is written in `globs.yml`. The help below
lists what is derived, and the sections after it say why the derivation is shaped so.

## help

### synopsis

Returns the DERIVED globsets — the live/tests aspect sets per module folder, one set per internal .psm1 module, the reserved infra
umbrellas, and the 'module-leftovers' catch-all.

### description

Derived sets are never written in globs.yml: the folder (or file) is the registration. Every module folder the resolver (Get-CatzcModule)
finds in the code track partitions into live/tests aspect sets ([DDR-ASPECT](../../../drs/design/module-aspects.md)), named by the
readme-kebab convention plus the aspect (Catzc.Base.Globs -> 'catzc-base-globs-live' and 'catzc-base-globs-tests') — 'live' the module's
shippable surface (functions, private helpers, types, configs), 'tests' its verification harness, plus its Go, Python and Bash test folders
`<root>/tests/<kebab>/` of each language root when they exist
([ADR-AUTO-GO-GOTESTMODULE](../../../drs/automation/go/go-test-artifacts.md#rule-adr-auto-go-gotestmodule),
[ADR-AUTO-PY-PYTESTFOLDER](../../../drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-pytestfolder),
[ADR-AUTO-BASH-BASHTESTFOLDER][r1]); the two are disjoint and cover the folder. The whole-module set is their union (a test-only change
never re-keys live). Every internal shared module `pwsh/.internal/<Name>.psm1` derives a single-file set (no tests aspect) by the same kebab
convention (Catzc.Internal.Bootstrap -> 'catzc-internal-bootstrap'). The reserved names cover the dot-prefixed infrastructure every module's
test results also depend on: 'internal', 'vendor', 'compiled', 'scriptanalyzer'. Derived sets bound the scope of protection and blast radius
([ADR-REPO-PROTGLOB-DERIVEDMODULEGLOBSETS](../../../drs/repository/protected-globs.md#rule-adr-repo-protglob-derivedmoduleglobsets)). A
declared globset may not shadow a derived name; the collision throws here, naming both sides.

The derived sets are repository-relative globs over the source tree's module folders (git-tracked paths), so it stops with a named error in
build mode (Assert-SourceTree, [DDR-RUNMODE](../../../drs/design/run-modes.md)).

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

## The code track

The code track is the one whose place is the catzc modules folder. Its first place is the root every module and infra folder sits under.

## Module aspects

Each module folder partitions into disjoint, exhaustive aspect sets, `live` and `tests` by default, from the `aspects` variant
([DDR-ASPECT](../../../drs/design/module-aspects.md)). The whole-module set is the union of its aspects: a shipped module is one `live` plus
one `tests`, isolated, so a test-only change never re-keys `live`. `AspectPartition` compiles them per unit root.

A module's Go, Python and Bash test folders (`<root>/tests/<kebab>/` of each language root,
[ADR-AUTO-GO-GOTESTMODULE](../../../drs/automation/go/go-test-artifacts.md#rule-adr-auto-go-gotestmodule),
[ADR-AUTO-PY-PYTESTFOLDER](../../../drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-pytestfolder),
[ADR-AUTO-BASH-BASHTESTFOLDER][r1]) are part of its `tests` aspect: a change to them re-keys the module they verify, never its `live`
aspect. Each language's folder is named from the module's folder, which drops the namespace, in that language's folder case.

## Internal shared modules

Each internal shared module gets one single-file set per `pwsh/.internal/<Name>.psm1`: the file is the registration, exactly as the folder
is for a module. The `internal` set over the whole folder remains the protection dependency, and these sets carry the per-module identity.

## Reserved umbrellas

The reserved umbrellas are cross-cutting check surfaces, not independent modules: `internal` overlaps every `catzc-internal-*` single-file
set, and `vendor`, `compiled` and `scriptanalyzer` cover whole dot-folders. They are loose filesets, overlap-exempt
([FDR-GLOBS-EVERYSETHASLAYER](../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-everysethaslayer)), and not the `module` layer, whose
sets are the pairwise-disjoint per-folder modules
([FDR-GLOBS-NOOVERLAPWITHINLAYER](../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-nooverlapwithinlayer)).

The reserved sets of the code track are units too
([DDR-ASPECT-ISAGLOBSET](../../../drs/design/module-aspects.md#rule-ddr-aspect-isaglobset)): their root `.psm1` files are the code they run,
live beside the code convention, and the rest falls to tests. A single-file module keeps its own set, so the scope's sets leave its file
out.

## Other tracks

Every other laid-out track's folder modules partition by that track's convention. Its root holder is no unit, because the black-box tests it
holds already belong to the module they test (the code track's `tests` aspects).

## The module-leftovers catch-all

The module layer's catch-all holds every tracked file under `pwsh/` that no per-folder module owns and that is not dot-folder infrastructure
(the reserved umbrellas' loose-fileset territory). It exists so the module layer covers module-space and a stray file cannot go unmapped. It
should be empty in a clean tree, but a file can appear at the root of `pwsh/` or in a folder that is not yet a module. Its own excludes are
every module folder plus the four dot-folders, so it stays disjoint from every module set
([FDR-GLOBS-NOOVERLAPWITHINLAYER](../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-nooverlapwithinlayer)). It is derived, in the module
layer, never declared, and a declared set may not shadow it.

The excludes are sorted ordinally, so the scan program (the marker body) is byte-identical on every machine, independent of
directory-enumeration and hashtable order.

[r1]: ../../../drs/automation/bash/bash-test-artifacts.md#rule-adr-auto-bash-bashtestfolder
