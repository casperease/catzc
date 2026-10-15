// One of the repository's execution engines — the shells its own code runs under.
// [ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md),
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)
// [comment:1](/docs/references/automation/catzc-base-engines/types/ExecutionEngine.cs.md#comment1)

using System;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.Engines;

public sealed class ExecutionEngine
{
    // How the engine's executable is found: beside the running PowerShell ($PSHOME), or through its tools.yml entry (the existence...
    // [comment:2](/docs/references/automation/catzc-base-engines/types/ExecutionEngine.cs.md#comment2)
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

    // How a call is bounded in time in this engine.
    // [ADR-AUTO-FAILFAST#7](/docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast7)
    // [comment:3](/docs/references/automation/catzc-base-engines/types/ExecutionEngine.cs.md#comment3)
    public string TimeSafeguard { get; }

    // True when the engine's scripts must have LF line endings to run.
    public bool RequiresLf { get; }

    // True when the engine's scripts must carry the executable bit to run directly on Unix.
    public bool RequiresExecutableBit { get; }

    // The repository-root script that loads the engine's entry points into a session (importer.ps1, importer.sh).
    public string ImporterEntry { get; }

    // What goes before a catzc command in this engine: nothing in pwsh, where the commands are native; "cats " in bash and zsh, the...
    // [comment:4](/docs/references/automation/catzc-base-engines/types/ExecutionEngine.cs.md#comment4)
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

    // The text as one literal string in the engine's own quoting: single quotes, with an embedded single quote written the engine's way...
    // [comment:5](/docs/references/automation/catzc-base-engines/types/ExecutionEngine.cs.md#comment5)
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

    // The arguments (after the executable) that start the engine non-interactively, load the entry script, and run the catzc command:...
    // [comment:6](/docs/references/automation/catzc-base-engines/types/ExecutionEngine.cs.md#comment6)
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
