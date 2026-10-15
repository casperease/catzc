/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/types/VariantsConfig.cs
    kind: type
    module: Catzc.Base.Variants
    adrs:
      - ADR-AUTO-TYPES#8
      - ADR-DSGN-ASPECT
      - ADR-DSGN-TRACK
      - ADR-DSGN-TRACK#1
      - ADR-DSGN-TRACK#2
      - ADR-REPO-VARIANT
---
*/

// Every key is optional and an unknown key throws, so a typo fails fast at load; an absent key is null.
// [comment:1](/docs/references/automation/catzc-base-variants/types/VariantsConfig.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Variants;

public sealed class VariantsConfig : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "ado_naming", "git_workspace", "have_customers", "aspects", "tracks" };
    private static readonly string[] AllowedTrackKeys = { "root", "class", "languages" };
    private static readonly Regex CustomerName = new Regex("^[a-z][a-z0-9]+$");
    private static readonly Regex AspectName = new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$");
    private static readonly Regex TrackName = new Regex("^\\.?[a-z][a-z0-9]*(-[a-z0-9]+)*$");
    private static readonly Regex RootFolder = new Regex("^[A-Za-z0-9._-]+$");

    // Azure resource-name component order: 'standard' or 'classic'. Null when unset.
    public string ado_naming { get; }

    // How changes reach main: 'main-direct' or 'main-via-pr'. Null when unset.
    public string git_workspace { get; }

    // Null when unset; Get-EnabledCustomers is its single interpreter.
    // [comment:2](/docs/references/automation/catzc-base-variants/types/VariantsConfig.cs.md#comment2)
    public object have_customers { get; }

    // Per-track ordered aspect classifications. Null when unset.
    public IReadOnlyDictionary<string, IReadOnlyList<VariantAspect>> aspects { get; }

    // The repository's tracks, in declared order. Null when unset.
    public IReadOnlyList<VariantTrack> tracks { get; }

    public VariantsConfig(IDictionary d)
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

        if (Has(d, "ado_naming"))
        {
            string value = Text(d["ado_naming"]);
            if (value == "standard" || value == "classic") { ado_naming = value; }
            else { errors.Add(string.Format("invalid ado_naming '{0}' (valid: standard, classic)", value)); }
        }

        if (Has(d, "git_workspace"))
        {
            string value = Text(d["git_workspace"]);
            if (value == "main-direct" || value == "main-via-pr") { git_workspace = value; }
            else { errors.Add(string.Format("invalid git_workspace '{0}' (valid: main-direct, main-via-pr)", value)); }
        }

        if (Has(d, "have_customers")) { have_customers = ReadCustomers(d["have_customers"], errors); }

        if (Has(d, "aspects")) { aspects = ReadAspects(d["aspects"], errors); }

        if (Has(d, "tracks")) { tracks = ReadTracks(d["tracks"], errors); }

        if (errors.Count > 0)
        {
            throw new ArgumentException("variants configuration validation failed:\n" + string.Join("\n", errors));
        }
    }

    private static bool Has(IDictionary d, string key) => d != null && d.Contains(key);

    private static string Text(object value) => value == null ? "" : value.ToString();

    // A YAML value as a list: a sequence is itself, null is empty, and a scalar or mapping is a one-item list.
    private static List<object> Items(object value)
    {
        List<object> items = new List<object>();
        if (value == null) { return items; }
        IList list = value as IList;
        if (list == null) { items.Add(value); return items; }
        foreach (object item in list) { items.Add(item); }
        return items;
    }

    private static object ReadCustomers(object value, List<string> errors)
    {
        if (value is bool) { return value; }
        string text = value as string;
        if (text != null)
        {
            if (text == "all") { return text; }
            errors.Add(string.Format("invalid have_customers '{0}' (a string must be 'all'; use a list for specific customers)", text));
            return null;
        }
        IEnumerable seq = value as IEnumerable;
        if (seq == null || value is IDictionary)
        {
            errors.Add(string.Format("invalid have_customers '{0}' (must be false, 'all', or a list of customer names)", Text(value)));
            return null;
        }
        List<string> names = new List<string>();
        foreach (object item in seq)
        {
            string name = Text(item);
            if (!CustomerName.IsMatch(name))
            {
                errors.Add(string.Format("invalid have_customers customer name '{0}' (must be 2+ lowercase alphanumeric chars, leading letter)", name));
            }
            else if (names.Contains(name))
            {
                errors.Add(string.Format("duplicate have_customers customer name '{0}'", name));
            }
            else { names.Add(name); }
        }
        return names.ToArray();
    }

    private static IReadOnlyDictionary<string, IReadOnlyList<VariantAspect>> ReadAspects(object value, List<string> errors)
    {
        IDictionary tracks = value as IDictionary;
        if (tracks == null)
        {
            errors.Add("invalid aspects (must be a map of track -> ordered [ {name: [patterns]}, … ])");
            return null;
        }
        if (tracks.Count == 0)
        {
            errors.Add("aspects must define at least one track convention");
            return null;
        }

        Dictionary<string, IReadOnlyList<VariantAspect>> result = new Dictionary<string, IReadOnlyList<VariantAspect>>(StringComparer.Ordinal);
        foreach (object trackKey in tracks.Keys)
        {
            string track = Text(trackKey);
            List<object> items = Items(tracks[trackKey]);
            if (items.Count == 0)
            {
                errors.Add(string.Format("aspects['{0}'] must list at least one aspect (the last is the '**' catch-all)", track));
                continue;
            }

            List<VariantAspect> aspects = new List<VariantAspect>();
            HashSet<string> seen = new HashSet<string>(StringComparer.Ordinal);
            for (int i = 0; i < items.Count; i++)
            {
                IDictionary item = items[i] as IDictionary;
                if (item == null || item.Count != 1)
                {
                    errors.Add(string.Format("aspects['{0}'][{1}] must be a single-key mapping {{name: [patterns]}}", track, i));
                    continue;
                }
                object nameKey = null;
                foreach (object k in item.Keys) { nameKey = k; }
                string name = Text(nameKey);
                if (!AspectName.IsMatch(name))
                {
                    errors.Add(string.Format("aspects['{0}']: invalid aspect name '{1}' (kebab-case)", track, name));
                }
                else if (!seen.Add(name))
                {
                    errors.Add(string.Format("aspects['{0}']: duplicate aspect '{1}'", track, name));
                }

                List<string> patterns = new List<string>();
                foreach (object p in Items(item[nameKey])) { patterns.Add(Text(p)); }
                if (patterns.Count == 0 || patterns.Exists(string.IsNullOrWhiteSpace))
                {
                    errors.Add(string.Format("aspects['{0}'].{1} needs at least one non-empty pattern", track, name));
                }
                bool isLast = i == items.Count - 1;
                if (isLast && (patterns.Count != 1 || patterns[0] != "**"))
                {
                    errors.Add(string.Format("aspects['{0}']: the last aspect ('{1}') must be the '**' catch-all remainder", track, name));
                }
                else if (!isLast && patterns.Contains("**"))
                {
                    errors.Add(string.Format("aspects['{0}'].{1} uses the bare '**' catch-all but is not last — only the final aspect is the remainder", track, name));
                }
                aspects.Add(new VariantAspect(name, patterns.ToArray()));
            }
            result[track] = aspects;
        }
        return result;
    }

    private static IReadOnlyList<VariantTrack> ReadTracks(object value, List<string> errors)
    {
        IDictionary map = value as IDictionary;
        if (map == null)
        {
            errors.Add("invalid tracks (must be a map of track -> { root, class, languages })");
            return null;
        }
        if (map.Count == 0)
        {
            errors.Add("tracks must declare at least one track");
            return null;
        }

        List<VariantTrack> result = new List<VariantTrack>();
        Dictionary<string, string> rootOwner = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        foreach (object nameKey in map.Keys)
        {
            string name = Text(nameKey);
            if (!TrackName.IsMatch(name))
            {
                errors.Add(string.Format("tracks: invalid track name '{0}' (kebab-case, optionally dot-prefixed)", name));
            }
            IDictionary entry = map[nameKey] as IDictionary;
            if (entry == null)
            {
                errors.Add(string.Format("tracks['{0}'] must be a mapping {{ root, class, languages }}", name));
                continue;
            }
            foreach (object k in entry.Keys)
            {
                string key = Text(k);
                if (Array.IndexOf(AllowedTrackKeys, key) < 0)
                {
                    errors.Add(string.Format("tracks['{0}']: unknown key '{1}' (allowed: {2})", name, key, string.Join(", ", AllowedTrackKeys)));
                }
            }

            string root = Has(entry, "root") ? Text(entry["root"]) : "";
            if (string.IsNullOrWhiteSpace(root))
            {
                errors.Add(string.Format("tracks['{0}'] needs a non-empty root folder", name));
            }
            else if (!RootFolder.IsMatch(root) || root == "." || root == "..")
            {
                errors.Add(string.Format("tracks['{0}']: invalid root '{1}' (one root folder segment, e.g. automation or .github)", name, root));
            }
            else if (string.Equals(root, "out", StringComparison.OrdinalIgnoreCase))
            {
                errors.Add(string.Format("tracks['{0}']: root 'out' is gitignored output, never a track (ADR-DSGN-TRACK#1)", name));
            }
            else if (rootOwner.ContainsKey(root))
            {
                errors.Add(string.Format("tracks['{0}']: root '{1}' is already the root of track '{2}' (a root carries one track)", name, root, rootOwner[root]));
            }
            else { rootOwner[root] = name; }

            string trackClass = Has(entry, "class") ? Text(entry["class"]) : "";
            if (Array.IndexOf(VariantTrack.Classes, trackClass) < 0)
            {
                errors.Add(string.Format("tracks['{0}']: invalid class '{1}' (valid: {2})", name, trackClass, string.Join(", ", VariantTrack.Classes)));
            }

            List<string> languages = new List<string>();
            foreach (object item in Items(Has(entry, "languages") ? entry["languages"] : null))
            {
                string language = Text(item);
                if (!AspectName.IsMatch(language))
                {
                    errors.Add(string.Format("tracks['{0}']: invalid language name '{1}' (kebab-case)", name, language));
                }
                else if (languages.Contains(language))
                {
                    errors.Add(string.Format("tracks['{0}']: duplicate language '{1}'", name, language));
                }
                else { languages.Add(language); }
            }

            result.Add(new VariantTrack(name, root, trackClass, languages.ToArray()));
        }
        return result;
    }
}
