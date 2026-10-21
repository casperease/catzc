/*
---
catzc:
  immutable:
    with_body_sha: "797e336add66"
  edges:
    test: pwsh/Catzc.Base.Reports/tests/types/IsolationRunResult.Tests.ps1
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-BCL-TYPES-NATIVETYPEDMODEL
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.Reports;

// Rests on [ADR-BCL-TYPES-NATIVETYPEDMODEL](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-nativetypedmodel) and [ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder).
[Catzc.Base.Objects.ConsoleDisplay(nameof(Isolation), nameof(Total), nameof(Failed), nameof(Sandbox))]
public sealed class IsolationRunResult
{
    private static readonly string[] Isolations = { "Process", "InProcess" };

    // Process or InProcess.
    public string Isolation { get; }

    // The profile the module set came from; null when the run named its modules, the default.
    public string ModuleProfile { get; }

    public string Sandbox { get; }

    // The modules copied into the sandbox, the closure included.
    public IReadOnlyList<string> Modules { get; }

    public int Total { get; }

    public int Failed { get; }

    public bool Success => Failed == 0;

    // The kept sandbox's results file; null when the sandbox is removed, the default.
    public string ResultsPath { get; }

    public IsolationRunResult(string isolation, string sandbox, IEnumerable<string> modules, int total, int failed, string moduleProfile = null,
        string resultsPath = null)
    {
        if (Array.IndexOf(Isolations, isolation) < 0)
        {
            throw new ArgumentException("isolation run result: the isolation is Process or InProcess, not '" + isolation + "'", nameof(isolation));
        }
        if (string.IsNullOrEmpty(sandbox))
        {
            throw new ArgumentException("isolation run result: the sandbox is required", nameof(sandbox));
        }
        // Failed is not bounded: a Process run with no results file counts the child's exit code, which may exceed Total or be negative.
        if (total < 0)
        {
            throw new ArgumentException("isolation run result: the total is never negative", nameof(total));
        }
        Isolation = isolation;
        Sandbox = sandbox;
        Modules = new List<string>(modules ?? Array.Empty<string>()).AsReadOnly();
        Total = total;
        Failed = failed;
        ModuleProfile = string.IsNullOrEmpty(moduleProfile) ? null : moduleProfile;
        ResultsPath = string.IsNullOrEmpty(resultsPath) ? null : resultsPath;
    }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);
}
