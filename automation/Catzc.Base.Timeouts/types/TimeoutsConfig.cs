// The time safeguards (configs/timeouts.yml) — how long a call may run before it is stopped. Registered in
// Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Timeouts.TimeoutsConfig), so Get-Config -Config timeouts
// returns this typed record; Get-TimeoutSeconds resolves a limit from it. Mirrors the YAML keys verbatim
// ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//
// Constructing an instance validates the file, collecting every violation into one ArgumentException:
//   - only the known keys ('default_seconds', 'executables') — an unknown key (a typo) fails fast at load;
//   - 'default_seconds' is required and a positive whole number;
//   - 'executables', when present, maps a bare executable name (no directory, no extension) to a positive whole
//     number. There is no "no limit" value: every call runs inside a safeguard.

using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;

namespace Catzc.Base.Timeouts;

public sealed class TimeoutsConfig : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "default_seconds", "executables" };

    // The limit, in seconds, for any call without a more specific entry.
    public int default_seconds { get; }

    // Per-executable limits in seconds, keyed by the bare executable name (case-insensitive). Empty when the file
    // declares none.
    public IReadOnlyDictionary<string, int> executables { get; }

    public TimeoutsConfig(IDictionary d)
    {
        List<string> errors = new List<string>();
        if (d != null)
        {
            foreach (object k in d.Keys)
            {
                string key = k == null ? null : k.ToString();
                if (Array.IndexOf(AllowedKeys, key) < 0)
                {
                    errors.Add(string.Format("unknown key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
                }
            }
        }

        if (d == null || !d.Contains("default_seconds"))
        {
            errors.Add("missing required key 'default_seconds' (the limit, in seconds, for any call)");
        }
        else
        {
            int? seconds = PositiveSeconds(d["default_seconds"]);
            if (seconds == null)
            {
                errors.Add(string.Format("invalid default_seconds '{0}' (must be a positive whole number)", d["default_seconds"]));
            }
            else { default_seconds = seconds.Value; }
        }

        Dictionary<string, int> perExecutable = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
        if (d != null && d.Contains("executables") && d["executables"] != null)
        {
            IDictionary map = d["executables"] as IDictionary;
            if (map == null)
            {
                errors.Add("invalid executables (must be a map of executable name to seconds)");
            }
            else
            {
                foreach (DictionaryEntry entry in map)
                {
                    string name = entry.Key == null ? "" : entry.Key.ToString();
                    if (name.Length == 0 || name.IndexOfAny(new[] { '/', '\\', '.' }) >= 0)
                    {
                        errors.Add(string.Format("invalid executables key '{0}' (a bare executable name: no directory, no extension)", name));
                        continue;
                    }

                    int? seconds = PositiveSeconds(entry.Value);
                    if (seconds == null)
                    {
                        errors.Add(string.Format("invalid executables.{0} '{1}' (must be a positive whole number)", name, entry.Value));
                        continue;
                    }

                    perExecutable[name] = seconds.Value;
                }
            }
        }
        executables = perExecutable;

        if (errors.Count > 0)
        {
            throw new ArgumentException("timeouts configuration validation failed:\n" + string.Join("\n", errors));
        }
    }

    // The limit for an executable: its own entry when it has one, otherwise default_seconds. The name may carry a
    // directory and an extension (`C:\tools\dotnet.exe`); only the bare name is looked up.
    public int SecondsFor(string executable)
    {
        string name = string.IsNullOrWhiteSpace(executable) ? "" : Path.GetFileNameWithoutExtension(executable.Trim());
        int seconds;
        return name.Length > 0 && executables.TryGetValue(name, out seconds) ? seconds : default_seconds;
    }

    private static int? PositiveSeconds(object value)
    {
        if (value is int || value is long || value is short || value is byte)
        {
            long seconds = Convert.ToInt64(value);
            return seconds > 0 && seconds <= int.MaxValue ? (int)seconds : (int?)null;
        }

        return null;
    }
}
