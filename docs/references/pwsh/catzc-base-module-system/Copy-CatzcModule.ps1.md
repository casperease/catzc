# pwsh/Base.ModuleSystem/Copy-CatzcModule.ps1

Copies a chosen subset of this repository's toolset, selected modules plus the extra files they own, into a destination that mirrors the
repository root. It exists so a test can run against a fresh temporary root, and so the toolset can be vendored as a package.

## help

### synopsis

Copies a deterministic subset of this repository's automation toolset into a destination, rooted like the repository root — for testing in a
tmp folder, or vendoring the toolset as a package.

### description

The source is always this repository (Get-RepositoryRoot). What to copy is chosen off the module resolver (Get-CatzcModule) and the profile
closure (Get-ModuleProfile):

```text
-ModuleNames      which modules to copy (the code track's modules and its infrastructure folders). Default: all
                  (the `full` profile).
-ExcludePackages  a global list of package names to drop. A package is a named group of extra file
                  artifacts a module owns (configs/files.yml) — e.g. the repository module's
                  'root_configs' and 'gitignore', or the types module's 'csproj'. Default: none.
```

Each selected module copies its folder plus each of its packages whose name is not excluded, to the SAME repository-root-relative path under
-Destination, so the destination becomes a new root mirroring ours. A source that is selected but absent from this tree (e.g. .compiled
before a first build) is skipped.

Conflict handling is a fast pre-scan (fast / faster / fastest):

- default full pre-scan; if any file it would write already exists, throw and list them — nothing is written (never clobbers).
- -EmptyDestination require the target to be empty (or absent); throw otherwise. The pristine-copy contract used by Pester against a fresh
  tmp directory.
- -Force skip the pre-scan and overwrite.

The copy is of the source tree (per-function files, tests/, root packages), so it stops with a named error in build mode (Assert-SourceTree,
[DDR-RUNMODE](../../../drs/design/run-modes.md)).

See [ADR-CONF-LOADING](../../../drs/configuration/module-config-loading.md) (files.yml),
[ADR-BCL-TYPES-NATIVETYPEDMODEL](../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-nativetypedmodel), and
[ADR-AUTO-PATH](../../../drs/automation/path-representation.md).

### parameter `Destination`

The target root the selected paths are mirrored into (created if missing).

### parameter `ModuleNames`

Module names to copy (modules + infrastructure folders). Default: all (Get-ModuleProfile -Name full).

### parameter `ModuleProfile`

A named module profile from configs/profiles.yml (minimal, azure, …), resolved to its dependency closure + infrastructure via
Get-ModuleProfile. Alternative to -ModuleNames.

### parameter `ExcludePackages`

Package names to drop (keys under any module's packages in files.yml). Default: none.

### parameter `EmptyDestination`

Require the destination to be empty; throw if it contains anything. Skips the per-file conflict scan.

### parameter `Force`

Skip the conflict pre-scan and overwrite existing files.

### parameter `DryRun`

Report what would be copied (and any conflicts) without writing anything.

### outputs

`[string[]]` The repository-root-relative source paths copied.

### example 1

```powershell
Copy-CatzcModule -Destination $tmp -ModuleNames Catzc.Base.Config -EmptyDestination
```

### example 2

```powershell
Copy-CatzcModule -Destination ./vendor/catzc -ExcludePackages gitignore -DryRun
```

## Sources

The copy list is repository-root-relative: each selected module's folder plus its packages' paths, minus the excluded packages. A module's
folder is the root the resolver gives it. An infrastructure folder (`.internal`, `.compiled`, `.vendor`) sits in the code track's first place.

## Bounded walks

Both file system walks are named and bounded
([ADR-PWSH-ENUM-ALWAYSBOUNDED](../../../drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded)):

- The emptiness probe is a one-level walk with nothing excluded and the vendor folder not pruned, so an entry of any kind, hidden and pruned
  names included, makes the target non-empty.
- The conflict pre-scan is a whole-tree walk of each source: every file the copy would write is checked for a conflict.
