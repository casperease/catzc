/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-engines/types/ExecutionEngine.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.Engines;

// Every per-shell difference is declared here once and the constructor is internal, so no caller restates a flag or invents an engine.
public sealed class ExecutionEngine
{
    // Found beside the running PowerShell, so the engine needs no tool pin and cannot drift from the host that starts it.
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

    // The wrapper that bounds a call in this engine, so nothing it starts can wait forever.
    public string TimeSafeguard { get; }

    // True when the engine's scripts must have LF line endings to run.
    public bool RequiresLf { get; }

    // True when the engine's scripts must carry the executable bit to run directly on Unix.
    public bool RequiresExecutableBit { get; }

    // The repository-root script that loads the engine's entry points into a session (importer.ps1, importer.sh).
    public string ImporterEntry { get; }

    // Empty where the commands are native, the dispatcher elsewhere, so a command's text reads the same in every engine.
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

    // One literal in the engine's own quoting, so no text can split into extra arguments or end the string early.
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

    // Non-interactive by construction, so a start never waits on a prompt, and the command text is the same in every engine.
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
