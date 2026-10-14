// One of the repository's execution engines — the shells its own code runs under
// ([ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)). Everything that differs between the engines is declared
// here, once, so no caller restates a flag, a quote rule, or a file name: how the engine's executable is named and
// located, which script files it runs, how it is started non-interactively, how it loads an entry script and runs a
// command, its strict mode, its time safeguard, the line endings and executable bit its scripts need, and its importer
// entry. The two instances live in ExecutionEngines; this type has no public constructor, so no caller invents a third.
//
// A model type, so its properties are PascalCase
// ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

using System;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.Engines;

public sealed class ExecutionEngine
{
    // How the engine's executable is found: beside the running PowerShell ($PSHOME), or through its tools.yml entry
    // (the existence check, Resolve-ToolExecutable).
    public const string LocateByPsHome = "ps-home";
    public const string LocateByTool = "tool";

    // The engine's name, as config keys and fixture columns spell it (pwsh, bash).
    public string Name { get; }

    // The executable's name without extension (pwsh, bash).
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

    // How a call is bounded in time in this engine (ADR-AUTO-FAILFAST#7).
    public string TimeSafeguard { get; }

    // True when the engine's scripts must have LF line endings to run.
    public bool RequiresLf { get; }

    // True when the engine's scripts must carry the executable bit to run directly on Unix.
    public bool RequiresExecutableBit { get; }

    // The repository-root script that loads the engine's entry points into a session (importer.ps1, importer.sh).
    public string ImporterEntry { get; }

    private readonly Func<string, string> quote;
    private readonly string sourceFormat;

    internal ExecutionEngine(string name, string command, string locate, string toolKey, string[] scriptExtensions, string shebang,
        string[] nonInteractiveArguments, string commandFlag, string strictMode, string timeSafeguard, bool requiresLf,
        bool requiresExecutableBit, string importerEntry, Func<string, string> quote, string sourceFormat)
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
        this.quote = quote;
        this.sourceFormat = sourceFormat;
    }

    // The executable's file name on the given platform (pwsh.exe on Windows, pwsh elsewhere).
    public string ExecutableFileName(bool windows)
    {
        return windows ? Command + ".exe" : Command;
    }

    // The text as one literal string in the engine's own quoting: single quotes, with an embedded single quote written
    // the engine's way ('' in pwsh, '\'' in bash).
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

    // The arguments (after the executable) that start the engine non-interactively, load the entry script, and run the
    // command: the non-interactive arguments, the command flag, then one command text "<source the entry>; <command>".
    public string[] StartArguments(string entry, string command)
    {
        if (string.IsNullOrWhiteSpace(command)) { throw new ArgumentException("StartArguments needs a command", nameof(command)); }
        List<string> arguments = new List<string>(NonInteractiveArguments);
        arguments.Add(CommandFlag);
        arguments.Add(SourceEntry(entry) + "; " + command);
        return arguments.ToArray();
    }

    public override string ToString()
    {
        return Name;
    }
}
