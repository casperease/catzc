// The result of checking one contract asset against the repository
// ([ADR-REPO-CONTRACT#4](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract4),
// [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)), as Get-ContractCheckResults returns it.
// A result type, not a config mirror, so the properties are PascalCase
// ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//   Asset     the ContractAsset checked
//   Passed    true when the check found nothing; derived from Findings, never set apart from them
//   Findings  one precise, human-readable message per way the repository breaks the asset, in the order found; empty
//             when it passed
// Construction rejects a missing asset and a blank finding; no findings at all (null or empty) is a pass.

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
