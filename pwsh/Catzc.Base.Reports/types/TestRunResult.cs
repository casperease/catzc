/*
---
catzc:
  immutable:
    with_body_sha: "720b5c1bee75"
  edges:
    test: pwsh/Catzc.Base.Reports/tests/types/TestRunResult.Tests.ps1
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-BCL-TYPES-NATIVETYPEDMODEL
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.Reports;

// Rests on [ADR-BCL-TYPES-NATIVETYPEDMODEL](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-nativetypedmodel) and [ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder).
[Catzc.Base.Objects.ConsoleDisplay(nameof(Result), nameof(PassedCount), nameof(FailedCount), nameof(DurationSeconds))]
public sealed class TestRunResult
{
    private static readonly string[] Results = { "Passed", "Failed" };

    // Passed or Failed.
    public string Result { get; }

    public int TotalCount => Rows.Count;

    public int PassedCount { get; }

    public int FailedCount { get; }

    public int SkippedCount { get; }

    public int NotRunCount { get; }

    public double DurationSeconds { get; }

    // One row per test in the run's order; empty when nothing ran, the default.
    public IReadOnlyList<object> Rows { get; }

    public string RunDirectory { get; }

    // The shards the run scheduled; empty when nothing ran, the default.
    public IReadOnlyList<object> Shards { get; }

    // The modules whose tests were skipped as protected; empty by default.
    public IReadOnlyList<string> ProtectedModules { get; }

    // The tests an opt-out tag left out of the run; empty when the run names no opt-out tag, the default.
    public IReadOnlyList<object> ExcludedTests { get; }

    public TestRunResult(string result, int passedCount, int failedCount, int skippedCount, int notRunCount, double durationSeconds,
        string runDirectory, IEnumerable<object> rows = null, IEnumerable<object> shards = null, IEnumerable<string> protectedModules = null,
        IEnumerable<object> excludedTests = null)
    {
        if (Array.IndexOf(Results, result) < 0)
        {
            throw new ArgumentException("test run result: the result is Passed or Failed, not '" + result + "'", nameof(result));
        }
        if (passedCount < 0 || failedCount < 0 || skippedCount < 0 || notRunCount < 0)
        {
            throw new ArgumentException("test run result: a count is never negative");
        }
        Result = result;
        PassedCount = passedCount;
        FailedCount = failedCount;
        SkippedCount = skippedCount;
        NotRunCount = notRunCount;
        DurationSeconds = durationSeconds;
        RunDirectory = runDirectory ?? "";
        Rows = new List<object>(rows ?? Array.Empty<object>()).AsReadOnly();
        Shards = new List<object>(shards ?? Array.Empty<object>()).AsReadOnly();
        ProtectedModules = new List<string>(protectedModules ?? Array.Empty<string>()).AsReadOnly();
        ExcludedTests = new List<object>(excludedTests ?? Array.Empty<object>()).AsReadOnly();
    }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);
}
