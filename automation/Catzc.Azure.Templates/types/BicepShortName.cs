/*
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/types/BicepShortName.cs
    kind: csharp-type
    language: csharp
    track: automation
    module: Catzc.Azure.Templates
    relatives:
      page: docs/references/automation/catzc-azure-templates/types/BicepShortName.cs.md
      test: automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1
    adrs:
      - ADR-AUTO-TYPES#9
      - ADR-AZ-NAMING
---
*/

using System;
using System.Text;

namespace Catzc.Azure.Templates;

public sealed class BicepShortName
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

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
