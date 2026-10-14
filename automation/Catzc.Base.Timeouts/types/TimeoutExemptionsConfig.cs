// The time-safeguard exemptions (configs/timeout-exemptions.yml) — work, identified by an immutable managed GUID, that
// may run past its normal limit while it is being tuned. Registered in Catzc.Base.Config/configs/configs.yml (type:
// Catzc.Base.Timeouts.TimeoutExemptionsConfig), so Get-Config -Config timeout-exemptions returns this typed record;
// Get-TimeoutExemption resolves a budget against it. Mirrors the YAML keys verbatim
// ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//
// An exemption never removes the limit ("ceil all"): an exempt budget runs up to its scope's ceiling instead —
// ceiling.<devbox|pipeline>.<bash|pwsh>, whose sensible defaults are declared here, once
// ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)).
// Each `exempt` entry names its budgets as exactly one of
//   single: <guid>                         one budget, or
//   range: { from: <guid>, to: <guid> }    every GUID from..to inclusive — a block of minted GUIDs that share a
//                                          leading group, ordered as written (canonical form, ordinal), the same
//                                          ordering as Test-IsGuidInRange;
// an optional scope { environment: devbox | pipeline, shell: bash | pwsh } (an omitted axis covers both values),
// and a non-empty reason.
//
// Constructing an instance validates the file, collecting every violation into one ArgumentException:
//   - only known keys at every level; every ceiling a positive whole number;
//   - each entry: exactly one of single | range, canonical GUIDs that are not the all-zeros GUID, from <= to, a
//     known scope, a non-empty reason;
//   - no two entries overlap: a GUID matches at most one entry in any (environment, shell) cell.
// Whether each GUID is a registered, live budget is the integrity test's job (the managed-GUID registry lives in
// another module).

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Timeouts;

public sealed class TimeoutExemptionsConfig : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "ceiling", "exempt" };
    private static readonly string[] EntryKeys = { "single", "range", "scope", "reason" };
    private static readonly string[] RangeKeys = { "from", "to" };
    private static readonly string[] ScopeKeys = { "environment", "shell" };
    private static readonly string[] Environments = { "devbox", "pipeline" };
    private static readonly string[] Shells = { "bash", "pwsh" };
    private static readonly Regex CanonicalGuid = new Regex(
        "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", RegexOptions.CultureInvariant);
    // The all-zeros GUID is a denied registry value, so it is built at runtime, never written as a literal.
    private static readonly string ZeroGuid = Guid.Empty.ToString("D");

    // The sensible defaults: an exempt budget may run up to ten minutes on a devbox and an hour in a pipeline.
    private static readonly Dictionary<string, int> Defaults = new Dictionary<string, int>(StringComparer.Ordinal)
    {
        { "devbox.bash", 600 },
        { "devbox.pwsh", 600 },
        { "pipeline.bash", 3600 },
        { "pipeline.pwsh", 3600 },
    };

    private readonly Dictionary<string, int> resolved = new Dictionary<string, int>(Defaults, StringComparer.Ordinal);
    private readonly List<Hashtable> entries = new List<Hashtable>();

    // The resolved ceilings, defaults filled in: ceiling[devbox|pipeline][bash|pwsh]. Resolve through CeilingFor.
    public IDictionary ceiling { get; }

    // The exemptions in file order, each normalized: from and to (equal for a single), environments and shells
    // (the scope, expanded), reason, and kind (single | range).
    public IReadOnlyList<Hashtable> exempt { get { return entries; } }

    public TimeoutExemptionsConfig(IDictionary d)
    {
        List<string> errors = new List<string>();
        CheckKeys(d, AllowedKeys, "", errors);

        if (d != null && d.Contains("ceiling") && d["ceiling"] != null)
        {
            ReadCeiling(d["ceiling"], errors);
        }

        if (d != null && d.Contains("exempt") && d["exempt"] != null)
        {
            IList list = d["exempt"] as IList;
            if (list == null || d["exempt"] is string)
            {
                errors.Add("invalid exempt (must be a list of exemptions)");
            }
            else
            {
                for (int i = 0; i < list.Count; i++)
                {
                    Hashtable entry = ReadEntry(list[i], "exempt[" + i + "]", errors);
                    if (entry != null) { entries.Add(entry); }
                }
                CheckOverlaps(errors);
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("timeout-exemptions configuration validation failed:\n" + string.Join("\n", errors));
        }

        Hashtable view = new Hashtable(StringComparer.OrdinalIgnoreCase);
        foreach (string environment in Environments)
        {
            Hashtable byShell = new Hashtable(StringComparer.OrdinalIgnoreCase);
            foreach (string shell in Shells) { byShell[shell] = resolved[environment + "." + shell]; }
            view[environment] = byShell;
        }
        ceiling = view;
    }

    // The ceiling an exempt budget runs up to in an environment and shell (case-insensitive).
    public int CeilingFor(string environment, string shell)
    {
        return resolved[Axis(environment, Environments, "environment") + "." + Axis(shell, Shells, "shell")];
    }

    // The exemption that covers a budget GUID in an environment and shell, or null when it is not exempt there.
    public Hashtable Find(string budget, string environment, string shell)
    {
        Guid parsed;
        if (!Guid.TryParse(budget, out parsed))
        {
            throw new ArgumentException(string.Format("budget '{0}' is not a GUID", budget));
        }
        string value = parsed.ToString("D");
        string env = Axis(environment, Environments, "environment");
        string sh = Axis(shell, Shells, "shell");
        foreach (Hashtable entry in entries)
        {
            if (Covers(entry, env, sh) &&
                string.CompareOrdinal(value, (string)entry["from"]) >= 0 && string.CompareOrdinal(value, (string)entry["to"]) <= 0)
            {
                return entry;
            }
        }
        return null;
    }

    private void ReadCeiling(object value, List<string> errors)
    {
        IDictionary byEnvironment = value as IDictionary;
        if (byEnvironment == null)
        {
            errors.Add("invalid ceiling (must be a map of devbox | pipeline)");
            return;
        }
        CheckKeys(byEnvironment, Environments, "ceiling.", errors);
        foreach (string environment in Environments)
        {
            if (!byEnvironment.Contains(environment) || byEnvironment[environment] == null) { continue; }
            IDictionary byShell = byEnvironment[environment] as IDictionary;
            if (byShell == null)
            {
                errors.Add(string.Format("invalid ceiling.{0} (must be a map of bash | pwsh)", environment));
                continue;
            }
            CheckKeys(byShell, Shells, "ceiling." + environment + ".", errors);
            foreach (string shell in Shells)
            {
                if (!byShell.Contains(shell) || byShell[shell] == null) { continue; }
                int? seconds = PositiveSeconds(byShell[shell]);
                if (seconds == null)
                {
                    errors.Add(string.Format("invalid ceiling.{0}.{1} '{2}' (must be a positive whole number)", environment, shell, byShell[shell]));
                    continue;
                }
                resolved[environment + "." + shell] = seconds.Value;
            }
        }
    }

    private static Hashtable ReadEntry(object value, string path, List<string> errors)
    {
        IDictionary d = value as IDictionary;
        if (d == null)
        {
            errors.Add(string.Format("invalid {0} (must be a map with single | range, reason and an optional scope)", path));
            return null;
        }
        int before = errors.Count;
        CheckKeys(d, EntryKeys, path + ".", errors);

        bool hasSingle = d.Contains("single") && d["single"] != null;
        bool hasRange = d.Contains("range") && d["range"] != null;
        string from = null;
        string to = null;
        if (hasSingle == hasRange)
        {
            errors.Add(string.Format("invalid {0}: needs exactly one of single | range", path));
        }
        else if (hasSingle)
        {
            from = to = ReadGuid(d["single"], path + ".single", errors);
        }
        else
        {
            IDictionary range = d["range"] as IDictionary;
            if (range == null)
            {
                errors.Add(string.Format("invalid {0}.range (must be a map of from, to)", path));
            }
            else
            {
                CheckKeys(range, RangeKeys, path + ".range.", errors);
                from = ReadGuid(range.Contains("from") ? range["from"] : null, path + ".range.from", errors);
                to = ReadGuid(range.Contains("to") ? range["to"] : null, path + ".range.to", errors);
                if (from != null && to != null && string.CompareOrdinal(from, to) > 0)
                {
                    errors.Add(string.Format("invalid {0}.range: from '{1}' is after to '{2}'", path, from, to));
                }
            }
        }

        List<string> environments = new List<string>(Environments);
        List<string> shells = new List<string>(Shells);
        if (d.Contains("scope") && d["scope"] != null)
        {
            IDictionary scope = d["scope"] as IDictionary;
            if (scope == null)
            {
                errors.Add(string.Format("invalid {0}.scope (must be a map of environment, shell)", path));
            }
            else
            {
                CheckKeys(scope, ScopeKeys, path + ".scope.", errors);
                ReadScopeAxis(scope, "environment", Environments, environments, path, errors);
                ReadScopeAxis(scope, "shell", Shells, shells, path, errors);
            }
        }

        string reason = d.Contains("reason") && d["reason"] is string ? ((string)d["reason"]).Trim() : "";
        if (reason.Length == 0)
        {
            errors.Add(string.Format("invalid {0}: needs a non-empty reason (why the budget is exempt while it is tuned)", path));
        }

        if (errors.Count > before) { return null; }
        return new Hashtable(StringComparer.OrdinalIgnoreCase)
        {
            { "kind", hasSingle ? "single" : "range" },
            { "from", from },
            { "to", to },
            { "environments", environments.ToArray() },
            { "shells", shells.ToArray() },
            { "reason", reason },
        };
    }

    private static void ReadScopeAxis(IDictionary scope, string axis, string[] allowed, List<string> into, string path, List<string> errors)
    {
        if (!scope.Contains(axis) || scope[axis] == null) { return; }
        string value = scope[axis] as string;
        string normalized = value == null ? null : value.Trim().ToLowerInvariant();
        if (normalized == null || Array.IndexOf(allowed, normalized) < 0)
        {
            errors.Add(string.Format("invalid {0}.scope.{1} '{2}' (allowed: {3})", path, axis, scope[axis], string.Join(", ", allowed)));
            return;
        }
        into.Clear();
        into.Add(normalized);
    }

    private static string ReadGuid(object value, string path, List<string> errors)
    {
        string text = value as string;
        if (text == null || !CanonicalGuid.IsMatch(text))
        {
            errors.Add(string.Format("invalid {0} '{1}' (must be a canonical GUID: lowercase, hyphenated)", path, value));
            return null;
        }
        if (text == ZeroGuid)
        {
            errors.Add(string.Format("invalid {0}: the all-zeros GUID is never a budget", path));
            return null;
        }
        return text;
    }

    private void CheckOverlaps(List<string> errors)
    {
        for (int i = 0; i < entries.Count; i++)
        {
            for (int j = i + 1; j < entries.Count; j++)
            {
                Hashtable a = entries[i];
                Hashtable b = entries[j];
                bool sharesCell = Intersects((string[])a["environments"], (string[])b["environments"]) &&
                    Intersects((string[])a["shells"], (string[])b["shells"]);
                bool sharesGuid = string.CompareOrdinal((string)a["from"], (string)b["to"]) <= 0 &&
                    string.CompareOrdinal((string)b["from"], (string)a["to"]) <= 0;
                if (sharesCell && sharesGuid)
                {
                    errors.Add(string.Format(
                        "overlapping exemptions: exempt[{0}] ({1}..{2}) and exempt[{3}] ({4}..{5}) cover the same GUID in the same scope",
                        i, a["from"], a["to"], j, b["from"], b["to"]));
                }
            }
        }
    }

    private static bool Covers(Hashtable entry, string environment, string shell)
    {
        return Array.IndexOf((string[])entry["environments"], environment) >= 0 && Array.IndexOf((string[])entry["shells"], shell) >= 0;
    }

    private static bool Intersects(string[] a, string[] b)
    {
        foreach (string value in a) { if (Array.IndexOf(b, value) >= 0) { return true; } }
        return false;
    }

    private static void CheckKeys(IDictionary d, string[] allowed, string prefix, List<string> errors)
    {
        if (d == null) { return; }
        foreach (object k in d.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(allowed, key) < 0)
            {
                errors.Add(string.Format("unknown key '{0}{1}' (allowed: {2})", prefix, key, string.Join(", ", allowed)));
            }
        }
    }

    private static string Axis(string value, string[] allowed, string axis)
    {
        string normalized = value == null ? "" : value.Trim().ToLowerInvariant();
        if (Array.IndexOf(allowed, normalized) < 0)
        {
            throw new ArgumentException(string.Format("unknown {0} '{1}' (allowed: {2})", axis, value, string.Join(", ", allowed)));
        }
        return normalized;
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
