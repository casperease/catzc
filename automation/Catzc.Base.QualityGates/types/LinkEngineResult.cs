/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/LinkEngineResult.cs
    kind: csharp-type
    module: Catzc.Base.QualityGates
---
*/

// The engine never writes: Format-Links writes Changed, and Test-Links only reports Findings.
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/LinkEngineResult.cs.md#comment1)

using System.Collections.Generic;

namespace Catzc.Base.QualityGates;

public sealed class LinkEngineResult
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public IReadOnlyList<LinkFinding> Findings { get; }
    public IReadOnlyDictionary<string, string> Changed { get; }
    public int FileCount { get; }

    public LinkEngineResult(IReadOnlyList<LinkFinding> findings, IReadOnlyDictionary<string, string> changed, int fileCount)
    {
        Findings = findings;
        Changed = changed;
        FileCount = fileCount;
    }
}
