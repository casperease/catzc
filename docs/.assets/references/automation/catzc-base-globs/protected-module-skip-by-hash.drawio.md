# docs/.assets/references/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.md

`Skip a module only if its folded hash matches its last green: the diagram described`

```text
A 1588 x 752 diagram, read left to right and top to bottom through three bands.
Glyphs: 4 code units (1 in a catzc module frame), 3 private helpers, 1 C# type, 1 gate, 2 stores; 7 flow edges, 2 store-access lines; 8 markers.
Sidebar: lens badge (SRC) and Supports chips; no minimaps.
```

This describes what the [diagram](protected-module-skip-by-hash.drawio.png) draws from the source of the `Catzc.Base.Globs` module and the
two `Catzc.Base.QualityGates` helpers that call it. The module's reference article embeds it and gives the responsibility in prose.

## At a glance

Before a test run of cats starts its workers, it decides per module whether that module's tests can be skipped. It folds the module's
globset hashes into one identity and asks whether that identity equals the one recorded after the module's last green run in this session.
Only an exact match skips. The identity it asked with is held as pending, and after the workers return, a module that came back green has
that pending identity promoted into the session map. In a pipeline every one of these steps asks `Test-IsRunningInPipeline` first and does
nothing, so a pipeline never skips a module.

## Walkthrough

1. **`Select-ProtectedTestFile`** is the protection decision of a test run (ADR-REPO-PROTGLOB#9). It asks `Test-IsRunningInPipeline` before
   anything else, then, for each module that owns test files in the run, composes the identity and asks the gate. It drops the files of
   every module the gate protects and returns the rest as candidates for promotion.
2. **`Test-IsRunningInPipeline`** is the one pipeline detection of cats (ADR-FLOW-CD-DETECT#1), in `Catzc.Internal.Loader`.
   `Select-ProtectedTestFile` asks it first, and in a pipeline returns every file, so nothing below runs. `Test-GlobSetProtection` and
   `Protect-GlobSet` ask it too (answering false and recording nothing in a pipeline). Those two calls are not drawn, because on this path
   the first check already decided.
3. **`Get-ModuleProtectionIdentity`** folds `set-name|set-hash` lines, sorted by name, into one hash. The sets are the module's own derived
   set, its declared dependency closure from `dependencies.yml`, the reserved infrastructure sets and the runner's set. A module with
   integrity tests, an unconstrained module or an infrastructure unit also folds in the whole `repository` set.
4. **`Get-GlobSetHash`** computes one globset's durable hash from the tracked bytes of its member files (ADR-FLOW-CD-GLOBS#5), so an
   uncommitted edit inside the set changes it.
5. **`DurableHash`** is the C# type behind both hashes: `HashFile` hashes a file with every carriage return stripped, and `HashFold` hashes
   the folded lines.
6. **`Test-GlobSetProtection`** compares the identity with the one stored under the run's key in `protectedGlobSets`. On an exact match the
   module is skipped. Otherwise it stores the identity in `pendingGlobProtections` and the module runs.
7. **`Protect-TestedModule`** runs after the workers. It promotes each candidate that produced at least one result row and no failed row,
   and promotes nothing when a failure cannot be attributed to a module.
8. **`Protect-GlobSet`** moves the pending identity, computed before the tests ran, into `protectedGlobSets` (ADR-REPO-PROTGLOB#4), so an
   edit made while the tests ran is never protected.

## Reading path

Start at marker 1 on `Select-ProtectedTestFile`, top left of the QUERY band. Its first edge runs left, out of the band, into
`Test-IsRunningInPipeline` inside the `Catzc.Internal.Loader` frame on the same row. Then follow the top row right through
`Get-ModuleProtectionIdentity` and `Get-GlobSetHash` to the `DurableHash` C# type; a second edge leaves `Get-ModuleProtectionIdentity`
downward and runs under the row into `DurableHash`. From `Select-ProtectedTestFile` an edge drops to the `Test-GlobSetProtection` gate, and
from the gate a plain store-access line (no arrowhead) drops into the SESSION MAP band onto the frame holding the two stores. In the RECORD
band, follow `Protect-TestedModule` right to `Protect-GlobSet`, whose store-access line rises into the same frame.

## Glyphs

| Glyph                          | Kind           | Band                      | Marker |
| ------------------------------ | -------------- | ------------------------- | ------ |
| `Select-ProtectedTestFile`     | private helper | QUERY                     | 1      |
| `Test-IsRunningInPipeline`     | code unit      | none (left, module frame) | 2      |
| `Get-ModuleProtectionIdentity` | private helper | QUERY                     | 3      |
| `Get-GlobSetHash`              | code unit      | QUERY                     | 4      |
| `DurableHash`                  | C# type        | QUERY                     | 5      |
| `Test-GlobSetProtection`       | gate           | QUERY                     | 6      |
| `pendingGlobProtections`       | store          | SESSION MAP               | —      |
| `protectedGlobSets`            | store          | SESSION MAP               | —      |
| `Protect-TestedModule`         | private helper | RECORD                    | 7      |
| `Protect-GlobSet`              | code unit      | RECORD                    | 8      |

`Test-IsRunningInPipeline` sits inside a catzc module frame labelled `Catzc.Internal.Loader`, left of the QUERY band, level with
`Select-ProtectedTestFile`. The two stores sit side by side inside one unlabelled frame. Private helpers have a darker fill than the code
units. `DurableHash` carries a `C#` tag on its top-right corner.

## Edges

Flow edges mean "calls". Store-access lines (no arrowhead) mean a read or write of the session map. Each is backed by a call site in the
source.

| From                           | To                             | Kind         | Call site                                                        |
| ------------------------------ | ------------------------------ | ------------ | ---------------------------------------------------------------- |
| `Select-ProtectedTestFile`     | `Test-IsRunningInPipeline`     | flow         | `private/Select-ProtectedTestFile.ps1` (QualityGates)            |
| `Select-ProtectedTestFile`     | `Get-ModuleProtectionIdentity` | flow         | `private/Select-ProtectedTestFile.ps1` (QualityGates)            |
| `Get-ModuleProtectionIdentity` | `Get-GlobSetHash`              | flow         | `private/Get-ModuleProtectionIdentity.ps1` (QualityGates)        |
| `Get-GlobSetHash`              | `DurableHash`                  | flow         | `Get-GlobSetHash.ps1`                                            |
| `Get-ModuleProtectionIdentity` | `DurableHash`                  | flow         | `private/Get-ModuleProtectionIdentity.ps1`, routed under the row |
| `Select-ProtectedTestFile`     | `Test-GlobSetProtection`       | flow         | `private/Select-ProtectedTestFile.ps1` (QualityGates)            |
| `Test-GlobSetProtection`       | the stores' frame              | store access | `Test-GlobSetProtection.ps1`                                     |
| `Protect-TestedModule`         | `Protect-GlobSet`              | flow         | `private/Protect-TestedModule.ps1` (QualityGates)                |
| `Protect-GlobSet`              | the stores' frame              | store access | `Protect-GlobSet.ps1`                                            |

The two store-access lines end on the SESSION MAP frame, not on a single store.

## Legend

The legend panel spans the bottom of the drawing area in four columns:

| Swatch                    | Phrase                         |
| ------------------------- | ------------------------------ |
| slate rounded box         | code unit                      |
| dark slate rounded box    | private helper                 |
| slate box with a `C#` tag | C# type                        |
| plain line, no arrowhead  | store access (reads or writes) |
| rhombus, thick rim        | gate                           |
| slate cylinder            | store                          |
| arrow                     | flow: calls                    |
| numbered light disc       | marker: a Walkthrough step     |

## Sidebar

A lens badge reading `SRC · source lens`. Below it is a Supports panel listing ADR-REPO-PROTGLOB#4 and #9, ADR-FLOW-CD-GLOBS#5 and #9,
ADR-FLOW-CD-DETECT#1, ADR-PWSH-CACHE#4 and ADR-DSGN-ASPECT: the rules the drawn code cites. Source-lens slides carry no minimaps.

## Where the code and the ADR differ

- ADR-REPO-PROTGLOB promotes every unit that produced no failed row; the code also requires the unit to have produced at least one row.
- ADR-REPO-PROTGLOB gives a run's key as `test-automation|L0-L1|Logic`; the code appends the run's rule filter as a fourth part, so the
  default key ends in a trailing `|`.
