// A template's `short_name` — the 2-5 char, lowercase-alnum Azure id segment every resource name is built from.
// [ADR-AZ-NAMING#2](/docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming2),
// [ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)
// [comment:1](/docs/references/automation/catzc-azure-templates/types/BicepShortName.cs.md#comment1)

using System;
using System.Text;

namespace Catzc.Azure.Templates;

public sealed class BicepShortName
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The maximum short_name length.
    // [ADR-AZ-NAMING](/docs/adr/azure/azure-naming-standard.md)
    // [comment:2](/docs/references/automation/catzc-azure-templates/types/BicepShortName.cs.md#comment2)
    public const int MaxLength = 5;

    // The template's on-disk folder name (the readable, kebab-case identifier). Always present.
    public string folder { get; }

    // The resolved short_name (the Azure id segment). Always a valid 2-MaxLength lowercase-alnum value.
    public string value { get; }

    // True when `value` came from an options.yml override; false when derived from the folder name.
    public bool overridden { get; }

    private BicepShortName(string folder, string value, bool overridden)
    {
        this.folder = folder;
        this.value = value;
        this.overridden = overridden;
    }

    // Resolve a template's short_name from its folder name and an optional options.yml override.
    // [comment:3](/docs/references/automation/catzc-azure-templates/types/BicepShortName.cs.md#comment3)
    public static BicepShortName Resolve(string folder, string overrideValue)
    {
        if (string.IsNullOrWhiteSpace(folder)) { throw new ArgumentException("BicepShortName requires a folder name"); }

        if (!string.IsNullOrEmpty(overrideValue))
        {
            if (!IsValid(overrideValue))
            {
                throw new ArgumentException(
                    $"Template '{folder}' has an invalid short_name override '{overrideValue}' in options.yml " +
                    $"(must be 2-{MaxLength} lowercase-alnum chars starting with a letter).");
            }
            return new BicepShortName(folder, overrideValue, true);
        }

        string derived = Derive(folder);
        if (!IsValid(derived))
        {
            throw new ArgumentException(
                $"Template '{folder}' derives an invalid short_name '{derived}' from its folder name " +
                $"(need at least 2 [a-z0-9] characters starting with a letter). " +
                $"Add an explicit short_name override in options.yml.");
        }
        return new BicepShortName(folder, derived, false);
    }

    // The derivation: lowercase, keep only [a-z0-9] (drop hyphens and any other punctuation), take the first MaxLength characters.
    // [comment:4](/docs/references/automation/catzc-azure-templates/types/BicepShortName.cs.md#comment4)
    public static string Derive(string folder)
    {
        if (folder == null) { throw new ArgumentException("BicepShortName.Derive requires a folder name"); }
        var sb = new StringBuilder(MaxLength);
        foreach (char c in folder.ToLowerInvariant())
        {
            if ((c >= 'a' && c <= 'z') || (c >= '0' && c <= '9'))
            {
                sb.Append(c);
                if (sb.Length == MaxLength) { break; }
            }
        }
        return sb.ToString();
    }

    // A well-formed short_name: 2-MaxLength chars, a leading letter then lowercase-alnum.
    // [ADR-AZ-NAMING#6](/docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming6)
    // [comment:5](/docs/references/automation/catzc-azure-templates/types/BicepShortName.cs.md#comment5)
    public static bool IsValid(string value)
    {
        if (string.IsNullOrEmpty(value)) { return false; }
        if (value.Length < 2 || value.Length > MaxLength) { return false; }
        char first = value[0];
        if (first < 'a' || first > 'z') { return false; }
        for (int i = 1; i < value.Length; i++)
        {
            char c = value[i];
            if (!((c >= 'a' && c <= 'z') || (c >= '0' && c <= '9'))) { return false; }
        }
        return true;
    }
}
