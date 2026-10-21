/*
---
catzc:
  immutable:
    with_body_sha: "6d9c3ac944d7"
  edges:
    test: pwsh/Catzc.Base.ModuleSystem/tests/types/ImporterConfig.Tests.ps1
    cites:
      - ADR-AUTO-IMPORTER-DECIDESMIX
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.ModuleSystem;

// Rests on [ADR-AUTO-IMPORTER-DECIDESMIX](/docs/drs/automation/importer.md#rule-adr-auto-importer-decidesmix).
public sealed class ImporterConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The value that leaves an axis to the importer: every present engine, or the executable languages of the loaded modules.
    public const string Auto = "auto";

    public static readonly IReadOnlyList<string> DefaultLanguages = Array.AsReadOnly(new[] { Auto });
    public static readonly IReadOnlyList<string> DefaultEngines = Array.AsReadOnly(new[] { Auto });

    private static readonly string[] AllowedKeys = { "languages", "engines" };

    // The languages the session loads: [auto], or the explicit language names.
    public IReadOnlyList<string> languages { get; }

    // The execution engines the session serves: [auto], or the explicit engine names.
    public IReadOnlyList<string> engines { get; }

    public ImporterConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        IReadOnlyList<string> languageValue = DefaultLanguages;
        IReadOnlyList<string> engineValue = DefaultEngines;

        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (Array.IndexOf(AllowedKeys, name) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown key '{0}' (allowed: {1})", name, string.Join(", ", AllowedKeys)));
                }
            }

            if (raw.Contains("languages") && raw["languages"] != null)
            {
                languageValue = ReadAxis("languages", raw["languages"], errors);
            }

            if (raw.Contains("engines") && raw["engines"] != null)
            {
                engineValue = ReadAxis("engines", raw["engines"], errors);
                foreach (string engine in engineValue)
                {
                    if (engine != Auto && !Contains(Catzc.Base.Engines.ExecutionEngines.Names, engine))
                    {
                        errors.Add(string.Format(CultureInfo.InvariantCulture, "engines entry '{0}' is not an execution engine (one of: {1})", engine,
                            string.Join(", ", Catzc.Base.Engines.ExecutionEngines.Names)));
                    }
                }
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("importer configuration validation failed:\n" + string.Join("\n", errors));
        }

        languages = languageValue;
        engines = engineValue;
    }

    // True when the axis is left to the importer.
    public static bool IsAuto(IReadOnlyList<string> axis)
    {
        return axis != null && axis.Count == 1 && axis[0] == Auto;
    }

    // An axis is the string auto, or a non-empty list of names that does not mix in auto.
    private static IReadOnlyList<string> ReadAxis(string key, object value, List<string> errors)
    {
        if (value is string text)
        {
            if (text == Auto) { return Array.AsReadOnly(new[] { Auto }); }
            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0} '{1}' must be auto or a list of names", key, text));
            return Array.Empty<string>();
        }

        IList list = value as IList;
        if (list == null || list.Count == 0)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0} must be auto or a non-empty list of names", key));
            return Array.Empty<string>();
        }

        List<string> names = new List<string>();
        foreach (object item in list)
        {
            string name = item as string;
            if (string.IsNullOrWhiteSpace(name))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "{0} entry '{1}' must be a name, not blank", key, item));
            }
            else if (name == Auto)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "{0} lists auto beside names; auto stands alone, as the value itself", key));
            }
            else if (names.Contains(name))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "{0} lists '{1}' twice", key, name));
            }
            else
            {
                names.Add(name);
            }
        }
        return names.AsReadOnly();
    }

    private static bool Contains(IReadOnlyList<string> items, string item)
    {
        foreach (string candidate in items)
        {
            if (string.Equals(candidate, item, StringComparison.Ordinal)) { return true; }
        }
        return false;
    }
}
