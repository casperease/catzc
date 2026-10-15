/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/FileMetaConfig.cs
    kind: csharp-type
    module: Catzc.Base.QualityGates
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/types/FileMetaConfig.cs.md
      test: automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1
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

namespace Catzc.Base.QualityGates;

public sealed class FileMetaConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public const string DefaultClass = "other";

    static readonly System.Text.RegularExpressions.Regex ClassName =
        new System.Text.RegularExpressions.Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$");

    public IReadOnlyList<FileMetaKind> kinds { get; }

    // The file classes in precedence order, each { class, files }: the one place file-meta names globs.
    public IReadOnlyList<KeyValuePair<string, IReadOnlyList<string>>> classes { get; }

    readonly List<KeyValuePair<string, List<Catzc.Base.Globs.GlobPattern>>> classPatterns = new List<KeyValuePair<string, List<Catzc.Base.Globs.GlobPattern>>>();

    public FileMetaConfig(IDictionary raw)
    {
        var list = new List<FileMetaKind>();
        var classList = new List<KeyValuePair<string, IReadOnlyList<string>>>();
        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (name != "kinds" && name != "classes")
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "file-meta config: unknown key '{0}' (allowed: classes, kinds)", name));
                }
            }
            if (raw.Contains("classes") && raw["classes"] != null)
            {
                if (!(raw["classes"] is IEnumerable entries) || raw["classes"] is string)
                {
                    throw new ArgumentException("file-meta config: classes must be a list of { class, files } entries");
                }
                foreach (object entry in entries)
                {
                    if (!(entry is IDictionary map) || !map.Contains("class") || !map.Contains("files"))
                    {
                        throw new ArgumentException("file-meta config: classes entries need 'class' and 'files'");
                    }
                    string className = Convert.ToString(map["class"], CultureInfo.InvariantCulture);
                    if (className == null || !ClassName.IsMatch(className) || className == DefaultClass)
                    {
                        throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                            "file-meta config: class '{0}' must be lowercase words joined by '-', and not '{1}'", className, DefaultClass));
                    }
                    if (classList.Any(c => c.Key == className))
                    {
                        throw new ArgumentException("file-meta config: class '" + className + "' is listed twice");
                    }
                    var globs = new List<string>();
                    if (map["files"] is string single) { globs.Add(single); }
                    else if (map["files"] is IEnumerable items) { foreach (object item in items) { globs.Add(Convert.ToString(item, CultureInfo.InvariantCulture)); } }
                    if (globs.Count == 0 || globs.Any(string.IsNullOrWhiteSpace))
                    {
                        throw new ArgumentException("file-meta config: class '" + className + "' needs at least one glob in 'files'");
                    }
                    classList.Add(new KeyValuePair<string, IReadOnlyList<string>>(className, globs));
                    classPatterns.Add(new KeyValuePair<string, List<Catzc.Base.Globs.GlobPattern>>(className,
                        globs.Select(glob => new Catzc.Base.Globs.GlobPattern(glob)).ToList()));
                }
            }
            if (raw.Contains("kinds") && raw["kinds"] != null)
            {
                if (!(raw["kinds"] is IDictionary map))
                {
                    throw new ArgumentException("file-meta config: kinds must be a map of kind id to its entry");
                }
                foreach (DictionaryEntry entry in map)
                {
                    string id = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
                    if (entry.Value != null && !(entry.Value is IDictionary))
                    {
                        throw new ArgumentException("file-meta config: kind '" + id + "' must be a map (or empty to take every default)");
                    }
                    list.Add(new FileMetaKind(id, entry.Value as IDictionary));
                }
            }
        }

        // A derived key belongs to one imprint kind, so two kinds never write the same key.
        var owner = new Dictionary<string, string>(StringComparer.Ordinal);
        foreach (FileMetaKind kind in list.Where(k => k.direction == FileMetaDirection.Imprint))
        {
            foreach (string key in kind.keys)
            {
                if (owner.TryGetValue(key, out string first))
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "file-meta config: derived key '{0}' is owned by both '{1}' and '{2}'", key, first, kind.id));
                }
                owner[key] = kind.id;
            }
        }
        kinds = list;
        classes = classList;
        foreach (FileMetaKind kind in list) { kind.registry = this; }
    }

    // The class of a repository-relative path: the first class whose globs match it, or 'other'.
    public string ClassOf(string path)
    {
        foreach (var entry in classPatterns)
        {
            if (entry.Value.Any(pattern => pattern.Matches(path))) { return entry.Key; }
        }
        return DefaultClass;
    }

    // True when the kind applies to the file, by the file's class and its language (null when no language claims it).
    public bool Selects(FileMetaKind kind, string path, string language) => kind != null && kind.Selects(ClassOf(path), language);

    // True when any imprint kind applies to the file: the file is in the meta scope.
    public bool SelectsAny(string path, string language)
    {
        string fileClass = ClassOf(path);
        return Imprint().Any(kind => kind.Selects(fileClass, language));
    }

    // The imprint kinds in registry order: the order their facts are written.
    public IReadOnlyList<FileMetaKind> Imprint() => kinds.Where(k => k.direction == FileMetaDirection.Imprint).ToList();

    // The gather kinds that feed one config.
    public IReadOnlyList<FileMetaKind> GatherFor(string config) =>
        kinds.Where(k => k.direction == FileMetaDirection.Gather && string.Equals(k.target, config, StringComparison.Ordinal)).ToList();
}
