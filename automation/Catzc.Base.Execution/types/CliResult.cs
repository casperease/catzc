/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/types/CliResult.cs
    kind: type
    language: csharp
    filekind: cs
    track: automation
    module: Catzc.Base.Execution
    relatives:
      page: docs/references/automation/catzc-base-execution/types/CliResult.cs.md
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.Execution;

public sealed class CliResult
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // Captured stdout, with trailing CR/LF trimmed.
    public string Output { get; }

    // Captured stderr, with trailing CR/LF trimmed.
    public string Errors { get; }

    // stdout then stderr, non-empty parts joined by a newline — the combined transcript for logging.
    public string Full { get; }

    // The process exit code.
    public int ExitCode { get; }

    // Output split into lines — the line-oriented view for callers that parse output row by row.
    public string[] Raw { get; }

    public byte[] Bytes { get; }

    public CliResult(byte[] stdout, string stderr, int exitCode) : this(string.Empty, stderr, exitCode)
    {
        Bytes = stdout ?? Array.Empty<byte>();
    }

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
