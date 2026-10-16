/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/types/FileKindsConfig.cs
    kind: type
    language: csharp
    filekind: cs
    track: automation
    module: Catzc.Base.Globs
    relatives:
      page: docs/references/automation/catzc-base-globs/types/FileKindsConfig.cs.md
      test: automation/Catzc.Base.Globs/tests/types/FileKindsConfig.Tests.ps1
    adrs:
      - ADR-CONF-LOADING#4
      - ADR-REPO-FILEMETA#2
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;

namespace Catzc.Base.Globs;

public sealed class FileKindsConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The kind of a file no entry selects.
    public const string DefaultKind = "other";

    static readonly Regex Name = new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$", RegexOptions.Compiled);

    // Every kind in precedence order: the first whose globs, or whose subkinds' globs, match a path names it.
    public IReadOnlyList<FileKindEntry> kinds { get; }

    public FileKindsConfig(IDictionary raw)
    {
        if (raw == null) { throw new ArgumentException("file-kinds config: the configuration must be a mapping"); }
        foreach (object key in raw.Keys)
        {
            string name = Convert.ToString(key, CultureInfo.InvariantCulture);
            if (name != "kinds") { throw new ArgumentException("file-kinds config: unknown key '" + name + "' (allowed: kinds)"); }
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
    }

    static FileKindEntry Parse(string kind, IDictionary entry)
    {
        string where = "file-kinds config: kind '" + kind + "'";
        if (entry == null) { throw new ArgumentException(where + " must be a map with a definition and globs"); }
        foreach (object key in entry.Keys)
        {
            string name = Convert.ToString(key, CultureInfo.InvariantCulture);
            if (name != "definition" && name != "files" && name != "subkinds")
            {
                throw new ArgumentException(where + ": unknown key '" + name + "' (allowed: definition, files, subkinds)");
            }
        }
        string definition = Definition(where, entry);
        List<string> files = Files(where, entry, required: false);
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
                    if (name != "definition" && name != "files")
                    {
                        throw new ArgumentException(subWhere + ": unknown key '" + name + "' (allowed: definition, files)");
                    }
                }
                subkinds.Add(new FileKindEntry(kind, subkind, Definition(subWhere, subEntry), Files(subWhere, subEntry, required: true), new FileKindEntry[0]));
            }
        }
        if (files.Count == 0 && subkinds.Count == 0) { throw new ArgumentException(where + " needs globs in 'files', or subkinds that have them"); }
        return new FileKindEntry(kind, null, definition, files, subkinds);
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

    // The kind and subkind of a repository-relative path, or the default kind with no subkind.
    public FileKindMatch Resolve(string path)
    {
        foreach (FileKindEntry kind in kinds)
        {
            foreach (FileKindEntry sub in kind.subkinds)
            {
                if (sub.Matches(path)) { return new FileKindMatch(sub.kind, sub.subkind, sub.definition); }
            }
            if (kind.Matches(path)) { return new FileKindMatch(kind.kind, null, kind.definition); }
        }
        return new FileKindMatch(DefaultKind, null, null);
    }
}
