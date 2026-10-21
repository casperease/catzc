/*
---
catzc:
  immutable:
    with_body_sha: ac0e38a55d82
  edges:
    test: pwsh/Catzc.Base.Globs/tests/types/FileKindsConfig.Tests.ps1
    docs: "[FileKindsConfig.cs.md](docs/references/pwsh/catzc-base-globs/types/FileKindsConfig.cs.md)"
    cites:
      - ADR-CONF-LOADING-CSHARPCONFIGTYPE
      - ADR-REPO-FILEMETA-METAKIND
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;

namespace Catzc.Base.Globs;

// Rests on [ADR-CONF-LOADING-CSHARPCONFIGTYPE](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading-csharpconfigtype) and [ADR-REPO-FILEMETA-METAKIND](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta-metakind).
public sealed class FileKindsConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The kind of a file no entry selects.
    public const string DefaultKind = "other";

    static readonly Regex Name = new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$", RegexOptions.Compiled);

    // A kind is mostly shadowed when an earlier kind takes more than this share of the files its globs match.
    public const int ShadowedPercent = 50;

    // Every kind in precedence order: the first whose globs, or whose subkinds' globs, match a path names it.
    public IReadOnlyList<FileKindEntry> kinds { get; }

    // The intended overlaps, [earlier, later] pairs; none by default.
    public IReadOnlyList<FileKindOverlap> overlaps { get; }

    public FileKindsConfig(IDictionary raw)
    {
        if (raw == null) { throw new ArgumentException("file-kinds config: the configuration must be a mapping"); }
        foreach (object key in raw.Keys)
        {
            string name = Convert.ToString(key, CultureInfo.InvariantCulture);
            if (name != "kinds" && name != "overlaps") { throw new ArgumentException("file-kinds config: unknown key '" + name + "' (allowed: kinds, overlaps)"); }
        }
        var list = new List<FileKindEntry>();
        if (raw.Contains("kinds") && raw["kinds"] != null)
        {
            if (!(raw["kinds"] is IDictionary map)) { throw new ArgumentException("file-kinds config: kinds must be a map of kind to its entry"); }
            foreach (DictionaryEntry entry in map)
            {
                string kind = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
                if (kind == null || !Name.IsMatch(kind) || kind == DefaultKind)
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "file-kinds config: kind '{0}' must be lowercase words joined by '-', and not '{1}'", kind, DefaultKind));
                }
                list.Add(Parse(kind, entry.Value as IDictionary));
            }
        }
        kinds = list;
        overlaps = Overlaps(raw, list);
    }

    static List<FileKindOverlap> Overlaps(IDictionary raw, List<FileKindEntry> kinds)
    {
        var pairs = new List<FileKindOverlap>();
        if (!raw.Contains("overlaps") || raw["overlaps"] == null) { return pairs; }
        if (!(raw["overlaps"] is IEnumerable items) || raw["overlaps"] is string)
        {
            throw new ArgumentException("file-kinds config: overlaps must be a list of [earlier, later] kind pairs");
        }
        var order = kinds.Select(kind => kind.role).ToList();
        foreach (object item in items)
        {
            var pair = new List<string>();
            if (item is IEnumerable parts && !(item is string))
            {
                foreach (object part in parts) { pair.Add(Convert.ToString(part, CultureInfo.InvariantCulture)); }
            }
            if (pair.Count != 2)
            {
                throw new ArgumentException("file-kinds config: an overlap is a pair [earlier, later] of kind names");
            }
            int earlier = order.IndexOf(pair[0]);
            int later = order.IndexOf(pair[1]);
            if (earlier < 0 || later < 0)
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                    "file-kinds config: overlap [{0}, {1}] names a kind the registry does not declare", pair[0], pair[1]));
            }
            if (earlier >= later)
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                    "file-kinds config: overlap [{0}, {1}] is not in precedence order: '{0}' must be declared before '{1}'", pair[0], pair[1]));
            }
            if (pairs.Any(existing => existing.Earlier == pair[0] && existing.Later == pair[1]))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "file-kinds config: overlap [{0}, {1}] is listed twice", pair[0], pair[1]));
            }
            pairs.Add(new FileKindOverlap(pair[0], pair[1]));
        }
        return pairs;
    }

    // The classes that are mostly shadowed over these paths by a kind the overlaps do not pair them with: one record per hiding kind.
    public IReadOnlyList<FileKindShadow> Shadowing(IEnumerable<string> paths)
    {
        var findings = new List<FileKindShadow>();
        var resolved = (paths ?? Enumerable.Empty<string>()).Distinct(StringComparer.Ordinal)
            .Select(path => new KeyValuePair<string, string>(path, Resolve(path).Class)).ToList();
        foreach (FileKindEntry kind in kinds)
        {
            foreach (FileKindEntry sub in kind.subkinds) { Shadow(sub, resolved, findings); }
            Shadow(kind, resolved, findings);
        }
        return findings;
    }

    void Shadow(FileKindEntry entry, List<KeyValuePair<string, string>> resolved, List<FileKindShadow> findings)
    {
        string own = entry.subkind == null ? entry.role : entry.role + "/" + entry.subkind;
        var takers = new Dictionary<string, int>(StringComparer.Ordinal);
        int matched = 0;
        int taken = 0;
        foreach (KeyValuePair<string, string> file in resolved)
        {
            if (!entry.Matches(file.Key)) { continue; }
            matched++;
            string named = file.Value;
            if (named == own || (entry.subkind == null && named.StartsWith(own + "/", StringComparison.Ordinal))) { continue; }
            taken++;
            string by = named.Split('/')[0];
            takers[by] = takers.TryGetValue(by, out int count) ? count + 1 : 1;
        }
        if (matched == 0 || taken * 100 <= matched * ShadowedPercent) { return; }
        foreach (KeyValuePair<string, int> taker in takers.OrderByDescending(pair => pair.Value).ThenBy(pair => pair.Key, StringComparer.Ordinal))
        {
            if (!overlaps.Any(pair => pair.Earlier == taker.Key && pair.Later == entry.role))
            {
                findings.Add(new FileKindShadow(own, taker.Key, taker.Value, matched));
            }
        }
    }

    static FileKindEntry Parse(string kind, IDictionary entry)
    {
        string where = "file-kinds config: kind '" + kind + "'";
        if (entry == null) { throw new ArgumentException(where + " must be a map with a definition and globs"); }
        foreach (object key in entry.Keys)
        {
            string name = Convert.ToString(key, CultureInfo.InvariantCulture);
            if (name != "definition" && name != "files" && name != "subkinds" && name != "git")
            {
                throw new ArgumentException(where + ": unknown key '" + name + "' (allowed: definition, files, subkinds, git)");
            }
        }
        string definition = Definition(where, entry);
        List<string> files = Files(where, entry, required: false);
        Git(where, entry, out List<string> gitAttributes, out string gitWhy);
        var subkinds = new List<FileKindEntry>();
        if (entry.Contains("subkinds") && entry["subkinds"] != null)
        {
            if (!(entry["subkinds"] is IDictionary subs)) { throw new ArgumentException(where + ": subkinds must be a map of subkind to its entry"); }
            foreach (DictionaryEntry sub in subs)
            {
                string subkind = Convert.ToString(sub.Key, CultureInfo.InvariantCulture);
                string subWhere = where + " subkind '" + subkind + "'";
                if (subkind == null || !Name.IsMatch(subkind)) { throw new ArgumentException(subWhere + " must be lowercase words joined by '-'"); }
                if (!(sub.Value is IDictionary subEntry)) { throw new ArgumentException(subWhere + " must be a map with a definition and globs"); }
                foreach (object key in subEntry.Keys)
                {
                    string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                    if (name != "definition" && name != "files" && name != "git")
                    {
                        throw new ArgumentException(subWhere + ": unknown key '" + name + "' (allowed: definition, files, git)");
                    }
                }
                Git(subWhere, subEntry, out List<string> subAttributes, out string subWhy);
                subkinds.Add(new FileKindEntry(kind, subkind, Definition(subWhere, subEntry), Files(subWhere, subEntry, required: true), new FileKindEntry[0], subAttributes, subWhy));
            }
        }
        if (files.Count == 0 && subkinds.Count == 0) { throw new ArgumentException(where + " needs globs in 'files', or subkinds that have them"); }
        return new FileKindEntry(kind, null, definition, files, subkinds, gitAttributes, gitWhy);
    }

    // The git attributes the kind's files get in the generated .gitattributes, and why: both or neither.
    static void Git(string where, IDictionary entry, out List<string> attributes, out string why)
    {
        attributes = new List<string>();
        why = null;
        if (!entry.Contains("git") || entry["git"] == null) { return; }
        if (!(entry["git"] is IDictionary git)) { throw new ArgumentException(where + ": git must be a map of attributes and why"); }
        foreach (object key in git.Keys)
        {
            string name = Convert.ToString(key, CultureInfo.InvariantCulture);
            if (name != "attributes" && name != "why") { throw new ArgumentException(where + ": unknown git key '" + name + "' (allowed: attributes, why)"); }
        }
        if (git.Contains("attributes") && git["attributes"] is IEnumerable items && !(git["attributes"] is string))
        {
            foreach (object item in items) { attributes.Add(Convert.ToString(item, CultureInfo.InvariantCulture)); }
        }
        if (attributes.Count == 0) { throw new ArgumentException(where + ": git needs at least one attribute"); }
        if (attributes.Any(a => string.IsNullOrWhiteSpace(a) || a.Any(char.IsWhiteSpace)))
        {
            throw new ArgumentException(where + ": a git attribute is one token without whitespace, such as catzc-fixture or eol=lf");
        }
        why = git.Contains("why") ? Convert.ToString(git["why"], CultureInfo.InvariantCulture) : null;
        if (string.IsNullOrWhiteSpace(why)) { throw new ArgumentException(where + ": git needs a why, one sentence that says what the attributes do for these files"); }
        why = why.Trim();
    }

    static string Definition(string where, IDictionary entry)
    {
        string definition = entry.Contains("definition") ? Convert.ToString(entry["definition"], CultureInfo.InvariantCulture) : null;
        if (string.IsNullOrWhiteSpace(definition)) { throw new ArgumentException(where + " needs a definition, one sentence that says what the kind is"); }
        return definition.Trim();
    }

    static List<string> Files(string where, IDictionary entry, bool required)
    {
        var globs = new List<string>();
        if (entry.Contains("files") && entry["files"] != null)
        {
            if (entry["files"] is string single) { globs.Add(single); }
            else if (entry["files"] is IEnumerable items) { foreach (object item in items) { globs.Add(Convert.ToString(item, CultureInfo.InvariantCulture)); } }
        }
        if (globs.Any(string.IsNullOrWhiteSpace)) { throw new ArgumentException(where + ": a glob in 'files' is empty"); }
        if (required && globs.Count == 0) { throw new ArgumentException(where + " needs at least one glob in 'files'"); }
        return globs;
    }

    // The role and subkind of a repository-relative path, or the default kind's role with no subkind.
    public FileKindMatch Resolve(string path)
    {
        foreach (FileKindEntry kind in kinds)
        {
            foreach (FileKindEntry sub in kind.subkinds)
            {
                if (sub.Matches(path)) { return new FileKindMatch(sub.role, sub.subkind, sub.definition); }
            }
            if (kind.Matches(path)) { return new FileKindMatch(kind.role, null, kind.definition); }
        }
        return new FileKindMatch(DefaultKind, null, null);
    }
}
