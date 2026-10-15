// The outcome of one link-engine run (LinkEngine.Run): every finding in file/line order, the aligned text of each file the aligner would...
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
