// The repository's execution engines — exactly two, pwsh and bash, declared once
// ([ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)). Every list of engines in the codebase — config keys
// per shell, per-engine fixture columns, an engine argument's allowed values — is Names, so adding or changing an
// engine is one edit here.

using System;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.Engines;

public static class ExecutionEngines
{
    // PowerShell 7: the engine every module runs under, located beside the running PowerShell.
    public static readonly ExecutionEngine Pwsh = new ExecutionEngine(
        name: "pwsh",
        command: "pwsh",
        locate: ExecutionEngine.LocateByPsHome,
        toolKey: null,
        scriptExtensions: new[] { ".ps1", ".psm1" },
        shebang: null,
        nonInteractiveArguments: new[] { "-NoProfile", "-NonInteractive" },
        commandFlag: "-Command",
        strictMode: "Set-StrictMode -Version Latest",
        timeSafeguard: "Invoke-WithTimeout",
        requiresLf: false,
        requiresExecutableBit: false,
        importerEntry: "importer.ps1",
        quote: text => "'" + text.Replace("'", "''") + "'",
        sourceFormat: ". {0} *> $null");

    // Bash: the second engine, Git Bash on Windows and the system bash elsewhere, located through its tools.yml entry.
    public static readonly ExecutionEngine Bash = new ExecutionEngine(
        name: "bash",
        command: "bash",
        locate: ExecutionEngine.LocateByTool,
        toolKey: "bash",
        scriptExtensions: new[] { ".sh" },
        shebang: "#!/usr/bin/env bash",
        nonInteractiveArguments: new[] { "--noprofile", "--norc" },
        commandFlag: "-c",
        strictMode: "set -euo pipefail",
        timeSafeguard: "timeout",
        requiresLf: true,
        requiresExecutableBit: true,
        importerEntry: "importer.sh",
        quote: text => "'" + text.Replace("'", "'\\''") + "'",
        sourceFormat: "source {0} >/dev/null 2>&1");

    // Every engine, pwsh first.
    public static readonly IReadOnlyList<ExecutionEngine> All = Array.AsReadOnly(new[] { Pwsh, Bash });

    // Every engine's name, in the order of All.
    public static readonly IReadOnlyList<string> Names = Array.AsReadOnly(new[] { Pwsh.Name, Bash.Name });

    // The engine of that name; throws, naming the engines, for any other name.
    public static ExecutionEngine Get(string name)
    {
        foreach (ExecutionEngine engine in All)
        {
            if (string.Equals(engine.Name, name, StringComparison.Ordinal)) { return engine; }
        }
        throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
            "'{0}' is not an execution engine (one of: {1})", name, string.Join(", ", Names)));
    }
}
