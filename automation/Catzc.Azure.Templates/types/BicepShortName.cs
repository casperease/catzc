// A template's `short_name` — the 2-5 char, lowercase-alnum Azure id segment every resource name is built
// from (docs/adr/azure/naming-standard.md, Rule ADR-NAMING:2). A template carries TWO identifiers: its readable,
// kebab-case on-disk FOLDER name and this short_name; only the short_name is ever Azure-facing.
//
// The short_name is DERIVED from the folder name by default — lowercase, keep only [a-z0-9] (hyphens and any
// other punctuation dropped), take the first 5 characters ("discovery" -> "disco"). A template MAY override it
// with an explicit `short_name` in its optional options.yml
// (Read-BicepTemplateOptions). This type makes the two identifiers, the derivation, and the format validation
// ONE construction-time invariant, so no caller re-implements the rule and a malformed name cannot exist.
//
// A plain domain type (docs/adr/automation/native-csharp-types.md, Rule ADR-TYPES:9) — Get-BicepTemplates
// constructs one per template and pins its .value as the short_name; it does not mirror a YAML file, so it
// keeps default validation and derivation logic here rather than a loose dictionary.

using System;
using System.Text;

namespace Catzc.Azure.Templates;

public sealed class BicepShortName
{
    // The maximum short_name length. Keeping this at 5 keeps the worst-case tight (storage) name at 23/24
    // with a byte to spare (docs/adr/azure/naming-standard.md, "Length budget").
    public const int MaxLength = 5;

    // The template's on-disk folder name (the readable, kebab-case identifier). Always present.
    public string folder     { get; }

    // The resolved short_name (the Azure id segment). Always a valid 2-MaxLength lowercase-alnum value.
    public string value      { get; }

    // True when `value` came from an options.yml override; false when derived from the folder name.
    public bool   overridden { get; }

    private BicepShortName(string folder, string value, bool overridden)
    {
        this.folder     = folder;
        this.value      = value;
        this.overridden = overridden;
    }

    // Resolve a template's short_name from its folder name and an optional options.yml override.
    //   overrideValue null/empty -> derive from the folder name;
    //   otherwise                -> validate and take the override.
    // Throws (naming the template) when the override is malformed, or when the folder derives a value that
    // cannot be a valid short_name (fewer than 2 [a-z0-9] chars, or a leading digit) and no override is given.
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

    // The derivation: lowercase, keep only [a-z0-9] (drop hyphens and any other punctuation), take the first
    // MaxLength characters. Pure and total — an empty/all-punctuation folder yields "" (which IsValid rejects
    // at Resolve, prompting an override).
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

    // A well-formed short_name: 2-MaxLength chars, a leading letter then lowercase-alnum. Mirrors the
    // options.yml schema regex ^[a-z][a-z0-9]{1,4}$ (Read-BicepTemplateOptions) and naming-standard Rule ADR-NAMING:6.
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
