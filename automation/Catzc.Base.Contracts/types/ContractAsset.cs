// Construction rejects any path that is not relative and '/'-separated, or that has a '.', '..' or empty segment.
// [ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2),
// [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6),
// [ADR-REPO-CONTRACT#7](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract7),
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8),
// [ADR-AUTO-PATH#1](/docs/adr/automation/path-representation.md#rule-adr-auto-path1),
// [ADR-AUTO-PATH#2](/docs/adr/automation/path-representation.md#rule-adr-auto-path2)
// [comment:1](/docs/references/automation/catzc-base-contracts/types/ContractAsset.cs.md#comment1)

using System;
using System.Text.RegularExpressions;

namespace Catzc.Base.Contracts;

[Catzc.Base.Objects.ConsoleDisplay(nameof(AssetPath), nameof(Kind), nameof(Direction), nameof(Target))]
public sealed class ContractAsset
{
    private static readonly Regex Version3 = new Regex("^[0-9]+\\.[0-9]+\\.[0-9]+$");

    public string Unit { get; }
    public string Version { get; }
    public string Module { get; }
    public string Path { get; }
    public string AssetPath { get; }
    public ContractAssetKind Kind { get; }
    public string Target { get; }
    public ContractDirection Direction { get; }
    public bool IsDirectionOverridden { get; }

    public ContractAsset(string unit, string version, string module, string path, ContractAssetKind kind, string target,
        ContractDirection direction, bool isDirectionOverridden)
    {
        Unit = Segment("unit", unit);
        Module = Segment("module", module);
        if (version == null || !Version3.IsMatch(version))
        {
            throw new ArgumentException(string.Format("contract asset: version '{0}' is not <major>.<minor>.<patch>", version));
        }
        Version = version;
        Path = Relative("path", path);
        AssetPath = string.Format("contracts/{0}/{1}/{2}/{3}", Unit, Version, Module, Path);
        Kind = kind;
        if (kind == ContractAssetKind.Sample)
        {
            // PowerShell binds $null to a string parameter as "", so an empty target is no target too.
            if (!string.IsNullOrEmpty(target))
            {
                throw new ArgumentException(string.Format("contract asset '{0}': a sample payload constrains no file, so it has no target", AssetPath));
            }
        }
        else
        {
            Target = Relative("target", target);
        }
        Direction = direction;
        IsDirectionOverridden = isDirectionOverridden;
    }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static string Segment(string what, string value)
    {
        string checkedValue = Relative(what, value);
        if (checkedValue.Contains('/'))
        {
            throw new ArgumentException(string.Format("contract asset: {0} '{1}' must be one folder name", what, value));
        }
        return checkedValue;
    }

    // A path in communication form: relative, '/'-separated, every segment non-empty and neither '.' nor '..'.
    private static string Relative(string what, string value)
    {
        if (string.IsNullOrEmpty(value) || value.Contains('\\') || value.StartsWith("/", StringComparison.Ordinal) || value.Contains(':'))
        {
            throw new ArgumentException(string.Format("contract asset: {0} '{1}' is not a relative '/'-separated path", what, value));
        }
        foreach (string segment in value.Split('/'))
        {
            if (segment.Length == 0 || segment == "." || segment == "..")
            {
                throw new ArgumentException(string.Format("contract asset: {0} '{1}' has an empty, '.' or '..' segment", what, value));
            }
        }
        return value;
    }
}
