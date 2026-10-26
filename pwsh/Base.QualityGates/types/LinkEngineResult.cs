/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/types/LinkEngineResult.cs.md"
  header: "generated"
---
*/

using System.Collections.Generic;

namespace Catzc.Base.QualityGates;

// One run's findings in file/line order, and the aligned text of each file it would change.
public sealed class LinkEngineResult
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public IReadOnlyList<LinkFinding> Findings { get; }
    public IReadOnlyDictionary<string, string> Changed { get; }
    public int FileCount { get; }
    // The relations the walk recognised, empty when the caller asked for none.
    public IReadOnlyList<LinkEdge> Edges { get; }

    public LinkEngineResult(IReadOnlyList<LinkFinding> findings, IReadOnlyDictionary<string, string> changed, int fileCount,
        IReadOnlyList<LinkEdge> edges)
    {
        Findings = findings;
        Changed = changed;
        FileCount = fileCount;
        Edges = edges ?? new List<LinkEdge>();
    }
}
