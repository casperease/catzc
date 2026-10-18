# out/diagrams/wave-9/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md

`Verification: Skip a module only if its folded hash matches its last green (source lens, Catzc.Base.Globs)`

Every line below was re-read on 2026-10-15 after the comment export; none of the scout's numbers is reused. `condense-comments` may move
them again, so re-grep before landing. Paths are relative to `pwsh/` unless they start with `docs/`. `QG` is `Catzc.Base.QualityGates/`,
`Globs` is `Catzc.Base.Globs/`.

## Boxes

| #   | Claim (box)                                                                | Source (`file:line`)                                                  | Status    |
| --- | -------------------------------------------------------------------------- | --------------------------------------------------------------------- | --------- |
| B1  | `Select-ProtectedTestFile` is a private helper of QualityGates             | `QG/private/Select-ProtectedTestFile.ps1:23`                          | confirmed |
| B2  | `Test-IsRunningInPipeline` lives in `Catzc.Internal.Loader` (catzc module) | `.internal/Catzc.Internal.Loader.psm1:50`                             | confirmed |
| B3  | `Get-ModuleProtectionIdentity` is a private helper of QualityGates         | `QG/private/Get-ModuleProtectionIdentity.ps1:17`                      | confirmed |
| B4  | `Get-GlobSetHash` is public in Globs (code unit)                           | `Globs/Get-GlobSetHash.ps1:22`                                        | confirmed |
| B5  | `DurableHash` is a C# type (`HashFile`, `HashFold`)                        | `Globs/types/DurableHash.cs:13,17,33`                                 | confirmed |
| B6  | `Test-GlobSetProtection` is public in Globs and decides skip or run (gate) | `Globs/Test-GlobSetProtection.ps1:22,58-64`                           | confirmed |
| B7  | `pendingGlobProtections` is Globs `$script:` state (store)                 | `Globs/Test-GlobSetProtection.ps1:45`; `Globs/Protect-GlobSet.ps1:44` | confirmed |
| B8  | `protectedGlobSets` is Globs `$script:` state (store)                      | `Globs/Test-GlobSetProtection.ps1:44`; `Globs/Protect-GlobSet.ps1:43` | confirmed |
| B9  | `Protect-TestedModule` is a private helper of QualityGates                 | `QG/private/Protect-TestedModule.ps1:18`                              | confirmed |
| B10 | `Protect-GlobSet` is public in Globs (code unit)                           | `Globs/Protect-GlobSet.ps1:22`                                        | confirmed |

## Edges (flow: calls; E8 and E10 are store-access lines; E7 and E11 are true but no longer drawn)

| #   | Edge                                                        | Call site (`file:line`)                                                                     | Status    |
| --- | ----------------------------------------------------------- | ------------------------------------------------------------------------------------------- | --------- |
| E1  | `Select-ProtectedTestFile` → `Test-IsRunningInPipeline`     | `QG/private/Select-ProtectedTestFile.ps1:46` (returns every file, no candidates)            | confirmed |
| E2  | `Select-ProtectedTestFile` → `Get-ModuleProtectionIdentity` | `QG/private/Select-ProtectedTestFile.ps1:80-81` (per unit, shared `$hashCache`)             | confirmed |
| E3  | `Get-ModuleProtectionIdentity` → `Get-GlobSetHash`          | `QG/private/Get-ModuleProtectionIdentity.ps1:42,51`                                         | confirmed |
| E4  | `Get-GlobSetHash` → `DurableHash`                           | `Globs/Get-GlobSetHash.ps1:53` (`HashFile`), `:60` (`HashFold`)                             | confirmed |
| E5  | `Get-ModuleProtectionIdentity` → `DurableHash`              | `QG/private/Get-ModuleProtectionIdentity.ps1:53,141` (`HashFold`)                           | confirmed |
| E6  | `Select-ProtectedTestFile` → `Test-GlobSetProtection`       | `QG/private/Select-ProtectedTestFile.ps1:82` (`-Hash $identity`)                            | confirmed |
| E7  | `Test-GlobSetProtection` → `Test-IsRunningInPipeline`       | `Globs/Test-GlobSetProtection.ps1:36-37` (returns `$false`)                                 | confirmed |
| E8  | `Test-GlobSetProtection` → session map                      | reads `protectedGlobSets` `:58` (`-ceq`); writes `pendingGlobProtections` `:63`             | confirmed |
| E9  | `Protect-TestedModule` → `Protect-GlobSet`                  | `QG/private/Protect-TestedModule.ps1:65` (no `-Hash`)                                       | confirmed |
| E10 | `Protect-GlobSet` → session map                             | reads pending `Globs/Protect-GlobSet.ps1:50`; writes protected `:59`; removes pending `:60` | confirmed |
| E11 | `Protect-GlobSet` → `Test-IsRunningInPipeline`              | `Globs/Protect-GlobSet.ps1:35-36` (returns)                                                 | confirmed |

## Bands, finding and title

| #   | Claim                                                                                                                                                                                                                                                      | Source (`file:line`)                                                                                                                                                                                                                                                             | Status       |
| --- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| C1  | QUERY runs before the workers, RECORD after them, both inside the run's `try`                                                                                                                                                                              | `QG/private/Invoke-TestRun.ps1:141` (`try`), `:188` (select), `:222` (workers), `:234` (protect)                                                                                                                                                                                 | confirmed    |
| C2  | The identity is a fold of `set-name\|set-hash` lines, ordinal by name, through `HashFold`                                                                                                                                                                  | `QG/private/Get-ModuleProtectionIdentity.ps1:135-141`                                                                                                                                                                                                                            | confirmed    |
| C3  | The fold covers the module's own set, its dependency closure, four infra sets, the runner's                                                                                                                                                                | `QG/private/Get-ModuleProtectionIdentity.ps1:61-65,74,97-124`                                                                                                                                                                                                                    | confirmed    |
| C4  | The fold widens to `repository` for integrity tests, unconstrained modules and infra units                                                                                                                                                                 | `QG/private/Get-ModuleProtectionIdentity.ps1:67-72,91-95,128-130`                                                                                                                                                                                                                | confirmed    |
| C5  | Skip only when the stored identity equals the current one (case-sensitive)                                                                                                                                                                                 | `Globs/Test-GlobSetProtection.ps1:58`                                                                                                                                                                                                                                            | confirmed    |
| C6  | "Last green": promotion stores the pre-run pending identity, only after the workers return                                                                                                                                                                 | `Globs/Protect-GlobSet.ps1:50-59`; `QG/private/Invoke-TestRun.ps1:222,234`                                                                                                                                                                                                       | confirmed    |
| C7  | A unit is promoted only when it has at least one row and no failed row                                                                                                                                                                                     | `QG/private/Protect-TestedModule.ps1:63-64`                                                                                                                                                                                                                                      | contradicted |
| C8  | A failed row without a file, or a failed shard with no failed row, promotes nothing                                                                                                                                                                        | `QG/private/Protect-TestedModule.ps1:52-55,58-61`                                                                                                                                                                                                                                | confirmed    |
| C9  | "In this session": the map is `$script:` module state, never a file                                                                                                                                                                                        | `Globs/Test-GlobSetProtection.ps1:40-45`; `docs/adr/repository/protected-globs.md:92-96`                                                                                                                                                                                         | confirmed    |
| C10 | In a pipeline the Test-Automation path returns before any identity is computed                                                                                                                                                                             | `QG/private/Select-ProtectedTestFile.ps1:46-54` before `:80`                                                                                                                                                                                                                     | confirmed    |
| C11 | The key is `<test>\|<globset>`; the test part is `<entry>\|L<min>-L<max>\|<category>\|<rules>`                                                                                                                                                             | `Globs/Test-GlobSetProtection.ps1:48`; `QG/private/Invoke-TestRun.ps1:89,187`                                                                                                                                                                                                    | contradicted |
| C12 | Supports: ADR-REPO-PROTGLOB-PROTECTIONKEY, ADR-REPO-PROTGLOB-ORCHESTRATORDECIDES; ADR-FLOW-CD-GLOBS-DURABLESHAIDENTITY, ADR-FLOW-CD-GLOBS-CHANGECOMPUTEDFROMGIT; ADR-FLOW-CD-DETECT-NODIRECTVARIABLECHECK; ADR-DSGN-ASPECT; ADR-PWSH-CACHE-STRICTSAFEPROBE | `QG/private/Select-ProtectedTestFile.ps1:3`; `Globs/Protect-GlobSet.ps1:16`; `Globs/types/DurableHash.cs:2`; `Globs/Get-GlobSetHash.ps1:4,7`; `.internal/Catzc.Internal.Loader.psm1:56`; `QG/private/Get-ModuleProtectionIdentity.ps1:46`; `Globs/Test-GlobSetProtection.ps1:42` | confirmed    |

Counts: 33 claims, 31 confirmed, 2 contradicted, 0 ADR-only.

## Corrections

- The brief's sketch puts the pipeline check only in `Test-GlobSetProtection`. In the Test-Automation path `Select-ProtectedTestFile` asks
  `Test-IsRunningInPipeline` first (`:46`) and returns every file before any identity is computed, so the check inside
  `Test-GlobSetProtection` never fires on this path. The change pass draws only that first call (E1), as a straight edge; E7 and E11 stay in
  this table and in the description's Walkthrough, but they are no longer drawn. That removes the bus that wrapped the left side.
- The change pass draws E8 and E10 as store-access lines with no arrowhead (STYLE.md, store access), and the legend's flow phrase is
  `flow: calls`. The self-named `Catzc.Internal.Loader` frame gives up its legend row to store access.
- The brief's sketch has `Protect-GlobSet` record into `$script:protectedGlobSets` only. It records the **pending** identity that
  `Test-GlobSetProtection` stored before the workers ran (`pendingGlobProtections`), so the slide draws both stores in one session-map
  frame. `Protect-TestedModule` passes no `-Hash`; the pending value is the only source on this path.
- Every scout line number had moved: `Test-GlobSetProtection.ps1:43,64` is now `:36,58,63`; `Protect-TestedModule.ps1:73` is `:65`;
  `Protect-GlobSet.ps1:60` is `:59`; `Get-GlobSetHash.ps1:59,66` is `:53,60`; `Get-ModuleProtectionIdentity.ps1:46,57,60,74` is
  `:42,51,53,141`. `Select-ProtectedTestFile.ps1:80-82` still holds.
- The title is 60 characters and drops the pipeline half of the finding; the slide carries it in the `Select-ProtectedTestFile` →
  `Test-IsRunningInPipeline` edge.

## Drift

- C7: `docs/adr/repository/protected-globs.md:156-157` says "every unit that produced no failed row is promoted"; the code also requires the
  unit to have produced at least one row (`Protect-TestedModule.ps1:64`).
- C11: `docs/adr/repository/protected-globs.md:159-160` gives the run key as `test-automation|L0-L1|Logic`; the code appends a fourth part,
  the `-Rule` list (`Invoke-TestRun.ps1:187`; default `@()` at `:69`), so the default key ends in `|` (the `Test-GlobSetProtection` example
  at `:20` shows the three-part form too).

## Cut

`Invoke-TestRun` (the caller of both helpers, `:188`, `:234`); `Invoke-TestAutomationWorkers` between the bands (`:222`);
`Get-TestFileModule` (grouping files by unit, `Select-ProtectedTestFile.ps1:70`); `Get-TestBlockTag` / `Get-TestRunFile` (integrity
detection, `:59-61`); `Get-TrackedFile`, `Get-ModuleGlobSet`, `Get-Config -Config dependencies`
(`Get-ModuleProtectionIdentity.ps1:38,48,78`); `Get-GlobSet` / `Get-GlobSetMember` (`Get-GlobSetHash.ps1:39,45-48`); the unused
`Get-GlobSetHash` fallbacks inside `Test-GlobSetProtection` (`:55`) and `Protect-GlobSet` (`:56`), which only run without `-Hash` and
without a pending value; `Clear-GlobSetProtection`. Each is one more box past the cap of 10.
