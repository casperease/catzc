/*
---
catzc:
  immutable:
    with_body_sha: aaef48ebee91
  edges:
    docs: "[BclHostBinding.cs.md](../../../docs/references/pwsh/catzc-base-languages/types/BclHostBinding.cs.md)"
    cites:
      - ADR-BCL-TYPES-BCLREFERENCESET
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Base.Languages;

[Catzc.Base.Objects.ConsoleDisplay("file", "host")]
public sealed class BclHostBinding : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "file", "host", "reason" };
    private static readonly Regex File = new Regex(@"^[A-Za-z][A-Za-z0-9.]*/types/[A-Za-z][A-Za-z0-9]*\.cs$");
    private static readonly Regex Host = new Regex(@"^[a-z][a-z0-9-]*$");

    // '<module>/types/<Type>.cs', relative to the modules folder.
    public string file { get; }

    public string host { get; }

    public string reason { get; }

    private BclHostBinding(string file, string host, string reason)
    {
        this.file = file;
        this.host = host;
        this.reason = reason;
    }

    // Reads one row; adds every problem to errors, prefixed with the row's place, and returns null when the row is invalid.
    public static BclHostBinding FromRow(object row, string place, List<string> errors)
    {
        IDictionary map = row as IDictionary;
        if (map == null)
        {
            errors.Add(place + " must be a map of file, host and reason");
            return null;
        }

        int before = errors.Count;
        foreach (object k in map.Keys)
        {
            string key = Convert.ToString(k, CultureInfo.InvariantCulture);
            if (Array.IndexOf(AllowedKeys, key) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: unknown key '{1}' (allowed: {2})", place, key, string.Join(", ", AllowedKeys)));
            }
        }

        string file = Read(map, "file");
        string host = Read(map, "host");
        string reason = Read(map, "reason");
        if (file == null || !File.IsMatch(file))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: invalid file '{1}' (a type source relative to the modules folder, e.g. 'Catzc.Base.Widgets/types/Gadget.cs')", place, file));
        }
        if (host == null || !Host.IsMatch(host))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: invalid host '{1}' (an engine name, e.g. 'pwsh')", place, host));
        }
        if (string.IsNullOrWhiteSpace(reason))
        {
            errors.Add(place + ": a host binding needs its reason");
        }

        return errors.Count == before ? new BclHostBinding(file, host, reason.Trim()) : null;
    }

    private static string Read(IDictionary map, string key)
    {
        return map.Contains(key) && map[key] is string value ? value : null;
    }
}
