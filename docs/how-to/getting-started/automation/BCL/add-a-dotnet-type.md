# Add a C# type

Some logic is better as a native .NET type than as PowerShell — a process runner, or a validated data record that replaces a loose
hashtable. Drop a `.cs` file in a module's `types/` folder and the importer compiles and loads it before any function runs. The full design
is in [native-csharp-types](../../../../adr/automation/BCL/native-csharp-types.md); this is the how-to.

## Steps

1. Create `automation/<Module>/types/<TypeName>.cs`.
2. Name the file for the **bare type** it declares, and give it a file-scoped **`namespace <Module>;`** matching the module — `Format-Types`
   writes and repairs this line from the file's `types/` folder, so you rarely type it by hand. The fully-qualified name is
   `<Module>.<TypeName>`.
3. Restart the session and re-run the importer. A loaded assembly cannot be hot-swapped, so editing a type requires a fresh PowerShell
   session.
4. Add a test that the type resolves and behaves.

## The convention

- **One type per file**, filename = type name (the analogue of one-function-per-file). The loader identifies the type from the filename — it
  does not parse the body — so a dotted filename, or a missing, mismatched, or block-scoped namespace, is rejected. The namespace must be
  the file-scoped form `namespace <Module>;` matching the module (folder-derived by `Format-Types`, gated by `Test-Types`).
- `types/CliRunner.cs` in `Catzc.Base.Execution` becomes `Catzc.Base.Execution.CliRunner`. FQN collisions across modules are therefore
  impossible.
- **BCL only.** Types compile against the shared framework with `Add-Type`; there is no mechanism to add NuGet references.
- Use **PascalCase** property names — _except_ on a type that mirrors a `configs/<name>.yml` file, where the properties match the snake_case
  YAML keys (see [native-csharp-types rule ADR-TYPES:8](../../../../adr/automation/BCL/native-csharp-types.md)).

## Example: a plain result type

This is `automation/Catzc.Base.Execution/types/CliResult.cs` — the object `Invoke-Executable -PassThru` returns. Note the file-scoped
`namespace Catzc.Base.Execution;` matching the module, and the filename matching the class.

```csharp
using System;
using System.Collections.Generic;

namespace Catzc.Base.Execution;

public sealed class CliResult
{
    public string   Output   { get; }   // stdout, trailing CR/LF trimmed
    public string   Errors   { get; }   // stderr, trailing CR/LF trimmed
    public string   Full     { get; }   // stdout then stderr, newline-joined
    public int      ExitCode { get; }
    public string[] Raw      { get; }   // Output split into lines

    public CliResult(string stdout, string stderr, int exitCode)
    {
        Output = (stdout ?? string.Empty).TrimEnd('\r', '\n');
        Errors = (stderr ?? string.Empty).TrimEnd('\r', '\n');
        ExitCode = exitCode;

        var parts = new List<string>();
        if (Output.Length > 0) { parts.Add(Output); }
        if (Errors.Length > 0) { parts.Add(Errors); }
        Full = string.Join(Environment.NewLine, parts);
        Raw = Output.Split(Environment.NewLine);
    }
}
```

## Example: a config-mirroring record

A data record backed by a YAML/dictionary shape can inherit the shared base `Catzc.Base.Objects.DictionaryRecord`, which gives it a
dictionary view (`Contains`, the `[key]` indexer, `Keys`, `ToHashtable()`) and protected extraction helpers (`Req` / `OptStr` / `StrArr`).
Because that is a cross-module reference, the owning module must declare `Catzc.Base.Objects` in `dependencies.yml` (see
[Add a module](../add-a-module.md#declaring-dependencies)). Properties match the snake_case config keys they mirror.

## How compilation and caching work

- Every module's `types/*.cs` compile into **one** assembly for the whole repository, committed at
  `automation/.compiled/Catzc.Types.<hash>.dll`. The hash is derived from every type's source, so a fresh checkout and CI load the committed
  DLL **without** invoking the Roslyn compiler — only an author who edits a source pays the sub-second recompile, once.
- Because types share one assembly, a type in any module may reference a type in any other — but the reference is governed by the module
  dependency graph, checked by `Get-CSharpTypeDependency` + `Assert-ModuleDependency` in the L2 suite.
- Editing a `.cs` re-keys the assembly. If you edit a type in a live session, the loader detects the drift on the next import and throws
  **"restart PowerShell"** — the loaded copy cannot be replaced in place.

## Rebuild from source

```powershell
. ./importer.ps1 -ClearCompiledTypes    # delete the compiled DLLs first, then recompile from source
```

Use this to verify a clean rebuild, or after editing a type when you want the committed assembly regenerated. The post-import janitor prunes
superseded `Catzc.Types.<hash>.dll` files so the committed `.compiled/` folder stays a clean one-in/one-out diff when a type changes.

## Verify

```powershell
. ./importer.ps1
[Catzc.Base.Execution.CliResult]::new('hi', '', 0).Output   # -> hi
```

If the type does not resolve, check the filename equals the bare type name and the source declares the file-scoped `namespace <Module>;`
matching its folder — run `Format-Types` to repair the line.
