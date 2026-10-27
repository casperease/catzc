using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Tooling.Claude;

public sealed class EditorClaimsConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The configs every session's next import reads, so one session at a time edits them.
    public static IReadOnlyList<string> DefaultSharedConfigs { get; } = Array.AsReadOnly(new[] { "timeouts", "dependencies" });

    private static readonly string[] AllowedKeys = { "shared_configs" };

    private static readonly Regex ConfigName = new Regex("^[a-z0-9]+(-[a-z0-9]+)*$", RegexOptions.CultureInvariant);

    // The global names of the configs Lock-SharedConfig claims for one editor at a time, as Get-Config names them.
    public IReadOnlyList<string> shared_configs { get; }

    public EditorClaimsConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        IReadOnlyList<string> sharedValue = DefaultSharedConfigs;

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

            if (raw.Contains("shared_configs") && raw["shared_configs"] != null)
            {
                sharedValue = ReadNames(raw["shared_configs"], errors);
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("editor-claims configuration validation failed:\n" + string.Join("\n", errors));
        }

        shared_configs = sharedValue;
    }

    private static IReadOnlyList<string> ReadNames(object value, List<string> errors)
    {
        IList list = value as IList;
        if (list == null || value is string)
        {
            errors.Add("shared_configs must be a list of config names");
            return DefaultSharedConfigs;
        }
        List<string> names = new List<string>();
        foreach (object item in list)
        {
            string name = item as string;
            if (name == null || !ConfigName.IsMatch(name))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "shared_configs entry '{0}' is not a config name (lower-case words joined by '-')", item));
                continue;
            }
            if (names.Contains(name))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "shared_configs names '{0}' twice", name));
                continue;
            }
            names.Add(name);
        }
        return names.AsReadOnly();
    }
}
