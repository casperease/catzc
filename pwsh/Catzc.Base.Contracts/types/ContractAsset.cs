/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/types/ContractAsset.cs.md"
  header: "generated"
---
*/

using System;
using System.Text.RegularExpressions;

namespace Catzc.Base.Contracts;

[Catzc.Base.Objects.ConsoleDisplay(nameof(AssetPath), nameof(Kind), nameof(Direction), nameof(Target))]
public sealed class ContractAsset
{
    private static readonly Regex Version3 = new Regex("^[0-9]+\\.[0-9]+\\.[0-9]+$");

    public string Root { get; }
    public string Version { get; }
    public string Group { get; }
    public string Path { get; }
    public string Key { get; }
    public string AssetPath { get; }
    public ContractAssetKind Kind { get; }
    public string Target { get; }
    public ContractDirection Direction { get; }

    // A group of "" (or null) is an asset directly in its version folder.
    public ContractAsset(string root, string version, string group, string path, ContractAssetKind kind, string target,
        ContractDirection direction)
    {
        Root = Segment("root", root);
        if (version == null || !Version3.IsMatch(version))
        {
            throw new ArgumentException(string.Format("contract asset: version '{0}' is not <major>.<minor>.<patch>", version));
        }
        Version = version;
        Group = string.IsNullOrEmpty(group) ? "" : Segment("group", group);
        Path = Segment("path", path);
        Key = Group.Length == 0 ? Path : string.Format("{0}/{1}", Group, Path);
        AssetPath = string.Format("contracts/{0}/{1}/{2}", Root, Version, Key);
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
    }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static string Segment(string what, string value)
    {
        string checkedValue = Relative(what, value);
        if (checkedValue.Contains('/'))
        {
            throw new ArgumentException(string.Format("contract asset: {0} '{1}' must be one folder or file name", what, value));
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
