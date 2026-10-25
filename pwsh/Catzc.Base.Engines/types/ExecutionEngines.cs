/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-engines/types/ExecutionEngines.cs.md"
  warning: "Generated Header"
---
*/

using System;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.Engines;

// The closed set of engines: every per-engine list in the code derives from Names, so adding an engine is one edit here.
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
        commandPrefix: "",
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
        commandPrefix: "cats ",
        quote: text => "'" + text.Replace("'", "'\\''") + "'",
        sourceFormat: "source {0} >/dev/null 2>&1");

    // Shares bash's POSIX quoting and its importer entry, so a third shell costs no second entry script.
    public static readonly ExecutionEngine Zsh = new ExecutionEngine(
        name: "zsh",
        command: "zsh",
        locate: ExecutionEngine.LocateByTool,
        toolKey: "zsh",
        scriptExtensions: new[] { ".zsh" },
        shebang: "#!/usr/bin/env zsh",
        nonInteractiveArguments: new[] { "-f" },
        commandFlag: "-c",
        strictMode: "setopt ERR_EXIT NO_UNSET PIPE_FAIL",
        timeSafeguard: "timeout",
        requiresLf: true,
        requiresExecutableBit: true,
        importerEntry: "importer.sh",
        commandPrefix: "cats ",
        quote: text => "'" + text.Replace("'", "'\\''") + "'",
        sourceFormat: "source {0} >/dev/null 2>&1");

    // Every engine, pwsh first.
    public static readonly IReadOnlyList<ExecutionEngine> All = Array.AsReadOnly(new[] { Pwsh, Bash, Zsh });

    // Every engine's name, in the order of All.
    public static readonly IReadOnlyList<string> Names = Array.AsReadOnly(new[] { Pwsh.Name, Bash.Name, Zsh.Name });

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
