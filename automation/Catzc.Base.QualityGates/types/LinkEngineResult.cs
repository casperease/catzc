// The outcome of one link-engine run (LinkEngine.Run): every finding in file/line order, the aligned text of each
// file the aligner would change (repository-relative path -> new text), and how many files were read. The engine
// does no writing — Format-Links writes Changed, Test-Links reports Findings.

using System.Collections.Generic;

namespace Catzc.Base.QualityGates;

public sealed class LinkEngineResult
{
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
