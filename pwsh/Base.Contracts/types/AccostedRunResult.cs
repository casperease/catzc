/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/types/AccostedRunResult.cs.md"
  header: "generated"
---
*/

namespace Catzc.Base.Contracts;

// One run's outcome under one engine: passed exactly when the engine exits 0.
public sealed class AccostedRunResult
{
    // The run's position in its file, from 1.
    public int Run { get; }

    public string Engine { get; }

    public bool Passed { get; }

    // The engine's exit code; null when the engine never started (not installed).
    public int? ExitCode { get; }

    // The run's command text, as the engine received it.
    public string Command { get; }

    // What the engine wrote, or why it never started.
    public string Output { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public AccostedRunResult(int run, string engine, int? exitCode, string command, string output)
    {
        Run = run;
        Engine = engine;
        ExitCode = exitCode;
        Passed = exitCode == 0;
        Command = command;
        Output = output ?? "";
    }
}
