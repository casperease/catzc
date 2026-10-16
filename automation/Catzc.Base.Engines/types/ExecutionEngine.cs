/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Engines/types/ExecutionEngine.cs
    folder: types
    name: execution-engine
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.Engines
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-engines/types/ExecutionEngine.cs.md
    test: automation/Catzc.Base.Engines/tests/types/ExecutionEngine.Tests.ps1
    cites:
      - ADR-AUTO-ENGINE
      - ADR-AUTO-FAILFAST#7
      - ADR-AUTO-TYPES#8
---
*/

using System;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.Engines;

public sealed class ExecutionEngine
{
    public const string LocateByPsHome = "ps-home";
    public const string LocateByTool = "tool";

    // The engine's name, as config keys and fixture columns spell it (pwsh, bash, zsh).
    public string Name { get; }

    // The executable's name without extension (pwsh, bash, zsh).
    public string Command { get; }

    // How the executable is located: LocateByPsHome or LocateByTool.
    public string Locate { get; }

    // The tools.yml key the executable is located through, when Locate is LocateByTool; null otherwise.
    public string ToolKey { get; }

    // The script file extensions the engine runs, the first being its script extension (.ps1, .sh).
    public IReadOnlyList<string> ScriptExtensions { get; }

    // The first line of a script meant to run directly (Unix), or null when the engine's scripts never run that way.
    public string Shebang { get; }

    // The arguments that start the engine with no profile and no prompt.
    public IReadOnlyList<string> NonInteractiveArguments { get; }

    // The flag that makes the next argument the command text to run (-Command, -c).
    public string CommandFlag { get; }

    // The statement that turns the engine's strict mode on.
    public string StrictMode { get; }

    public string TimeSafeguard { get; }

    // True when the engine's scripts must have LF line endings to run.
    public bool RequiresLf { get; }

    // True when the engine's scripts must carry the executable bit to run directly on Unix.
    public bool RequiresExecutableBit { get; }

    // The repository-root script that loads the engine's entry points into a session (importer.ps1, importer.sh).
    public string ImporterEntry { get; }

    public string CommandPrefix { get; }

    private readonly Func<string, string> quote;
    private readonly string sourceFormat;

    internal ExecutionEngine(string name, string command, string locate, string toolKey, string[] scriptExtensions, string shebang,
        string[] nonInteractiveArguments, string commandFlag, string strictMode, string timeSafeguard, bool requiresLf,
        bool requiresExecutableBit, string importerEntry, string commandPrefix, Func<string, string> quote, string sourceFormat)
    {
        Name = name;
        Command = command;
        Locate = locate;
        ToolKey = toolKey;
        ScriptExtensions = Array.AsReadOnly(scriptExtensions);
        Shebang = shebang;
        NonInteractiveArguments = Array.AsReadOnly(nonInteractiveArguments);
        CommandFlag = commandFlag;
        StrictMode = strictMode;
        TimeSafeguard = timeSafeguard;
        RequiresLf = requiresLf;
        RequiresExecutableBit = requiresExecutableBit;
        ImporterEntry = importerEntry;
        CommandPrefix = commandPrefix;
        this.quote = quote;
        this.sourceFormat = sourceFormat;
    }

    // The executable's file name on the given platform (pwsh.exe on Windows, pwsh elsewhere).
    public string ExecutableFileName(bool windows)
    {
        return windows ? Command + ".exe" : Command;
    }

    public string Quote(string text)
    {
        if (text == null) { throw new ArgumentNullException(nameof(text)); }
        return quote(text);
    }

    // The statement that loads an entry script into the session with its output discarded.
    public string SourceEntry(string entry)
    {
        if (string.IsNullOrWhiteSpace(entry)) { throw new ArgumentException("SourceEntry needs the entry script's path", nameof(entry)); }
        return string.Format(CultureInfo.InvariantCulture, sourceFormat, Quote(entry));
    }

    public string[] StartArguments(string entry, string command)
    {
        if (string.IsNullOrWhiteSpace(command)) { throw new ArgumentException("StartArguments needs a command", nameof(command)); }
        List<string> arguments = new List<string>(NonInteractiveArguments);
        arguments.Add(CommandFlag);
        arguments.Add(SourceEntry(entry) + "; " + CommandPrefix + command);
        return arguments.ToArray();
    }

    public override string ToString()
    {
        return Name;
    }
}
