// The captured result of running an external command: stdout and stderr kept separate, plus convenience
// views derived from them. The constructor owns the derivation, so the result can never be in an
// inconsistent state (the views always agree with Output/Errors).

using System;
using System.Collections.Generic;

namespace Catzc.Base.Execution;

public sealed class CliResult
{
    // Captured stdout, with trailing CR/LF trimmed.
    public string   Output   { get; }

    // Captured stderr, with trailing CR/LF trimmed.
    public string   Errors   { get; }

    // stdout then stderr, non-empty parts joined by a newline — the combined transcript for logging.
    public string   Full     { get; }

    // The process exit code.
    public int      ExitCode { get; }

    // Output split into lines — the line-oriented view for callers that parse output row by row.
    public string[] Raw      { get; }

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
