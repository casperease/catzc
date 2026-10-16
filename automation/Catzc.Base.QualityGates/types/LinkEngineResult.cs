/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/types/LinkEngineResult.cs
    folder: types
    name: link-engine-result
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-qualitygates/types/LinkEngineResult.cs.md
---
*/

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
