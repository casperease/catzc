using System;
using System.Text;

namespace Catzc.Azure.Templates;

// The template's only Azure-facing identifier (the folder name is not): the derivation and format rule live here, so a malformed name cannot exist.
public sealed class BicepShortName
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // Five keeps the worst-case tight storage name at 23 of 24 characters, one byte to spare.
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

    // A null or empty override derives from the folder; throws, naming the template, on a malformed override or an underivable folder with none.
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

    // Pure and total: an empty or all-punctuation folder yields "", which IsValid rejects at Resolve, prompting an override.
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

    // Mirrors the options.yml schema regex ^[a-z][a-z0-9]{1,4}$: a leading letter, then lowercase alphanumerics.
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
