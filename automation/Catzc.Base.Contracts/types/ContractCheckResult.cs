/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/types/ContractCheckResult.cs
    kind: csharp-type
    module: Catzc.Base.Contracts
    relatives:
      page: docs/references/automation/catzc-base-contracts/types/ContractCheckResult.cs.md
      test: automation/Catzc.Base.Contracts/tests/types/ContractCheckResult.Tests.ps1
    adrs:
      - ADR-AUTO-TYPES#8
      - ADR-REPO-CONTRACT#{4,6}
---
*/

using System;
using System.Collections.Generic;
using System.Linq;

namespace Catzc.Base.Contracts;

[Catzc.Base.Objects.ConsoleDisplay(nameof(Passed), nameof(Asset), nameof(Findings))]
public sealed class ContractCheckResult
{
    public ContractAsset Asset { get; }
    public bool Passed { get; }
    public IReadOnlyList<string> Findings { get; }

    public ContractCheckResult(ContractAsset asset, IEnumerable<string> findings)
    {
        Asset = asset ?? throw new ArgumentNullException(nameof(asset), "contract check result: the asset is required");
        string[] list = (findings ?? Enumerable.Empty<string>()).ToArray();
        if (list.Any(string.IsNullOrWhiteSpace))
        {
            throw new ArgumentException(string.Format("contract check result '{0}': a finding is an empty message", asset.AssetPath));
        }
        Findings = list;
        Passed = list.Length == 0;
    }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);
}
