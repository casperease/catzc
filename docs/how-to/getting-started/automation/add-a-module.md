# Add a module

A module is just a folder. Create a non-dot directory under `automation/`, drop `.ps1` files in it, and the importer discovers it — no
registration, no manifest, no edit to any loader (see [open-closed-architecture](../../../adr/automation/open-closed-architecture.md)).

## Steps

1. Create `automation/<ModuleName>/`. The folder name **is** the module name. Follow the existing dotted PascalCase convention
   (`Catzc.<Area>.<Thing>`, e.g. `Catzc.Azure.Storage`).
2. Add public functions as `Verb-Noun.ps1` files at the module root (see [Add a function](powershell/add-a-function.md)).
3. Add the optional well-known subfolders only as needed (table below).
4. If the module calls functions or uses C# types from another module, declare that edge in
   `automation/Catzc.Base.ModuleSystem/configs/dependencies.yml`.
5. Re-run the importer (`. ./importer.ps1`) and run `Test-Automation`.

## The well-known subfolders

A module uses only these folder names — they are a contract tooling hardcodes (see
[conventional-folders](../../../adr/repository/conventional-folders.md)). Create one only when you need it.

| Folder     | Holds                                                           | Notes                                             |
| ---------- | --------------------------------------------------------------- | ------------------------------------------------- |
| _(root)_   | Public functions, one `Verb-Noun.ps1` each                      | Exported automatically                            |
| `private/` | Private helpers, same one-function-per-file rule                | Loaded into module scope, not exported            |
| `tests/`   | `Verb-Noun.Tests.ps1` Pester files; fixtures in `tests/assets/` | Discovered by `Test-Automation`                   |
| `configs/` | The module's own config — flat kebab-case `<name>.yml`          | Read via `Get-Config -Config <name>`              |
| `types/`   | C# sources autoloaded as .NET types                             | See [Add a C# type](BCL/add-a-dotnet-type.md)     |
| `assets/`  | Shipped templates, scripts, schemas, starters                   | Referenced via `$PSScriptRoot`; not test fixtures |

A module with no private helpers has no `private/`; a module with no config has no `configs/`. The convention defines what each name means
**when present**, not that all must exist.

## Minimum viable module

```text
automation/Catzc.Azure.Storage/
  New-StorageContainers.ps1        # function New-StorageContainers
  Get-StorageAccount.ps1           # function Get-StorageAccount
  private/
    Resolve-StorageEndpoint.ps1    # helper, callable from the public functions
  tests/
    New-StorageContainers.Tests.ps1
    Get-StorageAccount.Tests.ps1
```

That is the whole setup. The bootstrap module generates the `.psd1` manifest from the filenames at import; you never write or maintain one.

## Declaring dependencies

The repository shares one global, collision-free function namespace — two modules cannot export the same function name, and the import fails
loudly if they try. Allowed **module-to-module** dependencies are declared as a directed acyclic graph in
`automation/Catzc.Base.ModuleSystem/configs/dependencies.yml`:

```yaml
modules:
  Catzc.Base.Asserts: []
  Catzc.Base.Repository: [Catzc.Base.Asserts]
  Catzc.Azure: [Catzc.Base.Asserts, Catzc.Base.Repository]
  # add your module and the modules it is allowed to call:
  Catzc.Azure.Storage: [Catzc.Base.Asserts, Catzc.Base.Repository, Catzc.Azure]
```

`Assert-ModuleDependency` (run in the L2 suite) fails the build if your module calls into a module it does not declare, or if the
declarations form a cycle. The same graph governs cross-module C# type references (see
[native-csharp-types](../../../adr/automation/BCL/native-csharp-types.md)). A module that is **not** listed is unconstrained; once you list
it, it is policed — so list it.

## Module config (optional)

If the module needs its own settings, drop `automation/<Module>/configs/<name>.yml` and read it anywhere with `Get-Config -Config <name>` —
one reader, cached per session, owner-scoped validation. To validate the shape, add a private `Assert-<TitleCase(name)>Config` function in
the module; `Get-Config` runs it automatically on load (see [module-config-loading](../../../adr/configuration/module-config-loading.md)).
Keep keys `snake_case`.

## Verify

```powershell
. ./importer.ps1
Get-Command -Module Catzc.Azure.Storage      # your public functions are listed
Test-Automation -Modules Catzc.Azure.Storage # run just this module's tests
```

If a function does not appear, check the file name matches the function name and the file is at the module root (not in `private/`).
Non-conforming files are silently skipped — that is by design (see
[zero-ceremony-poka-yoke](../../../adr/automation/zero-ceremony-poka-yoke.md)).
