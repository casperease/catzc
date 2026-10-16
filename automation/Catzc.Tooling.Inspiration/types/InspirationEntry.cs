/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Inspiration/types/InspirationEntry.cs
    folder: types
    name: inspiration-entry
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Inspiration
    moduletype: pwsh-folder
    catzc_bundle: full
  edges:
    page: docs/references/automation/catzc-tooling-inspiration/types/InspirationEntry.cs.md
    cites:
      - ADR-AUTO-TYPES#8
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Tooling.Inspiration;

public sealed class InspirationEntry : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] Allowed = { "id", "root", "description", "paths" };
    private static readonly Regex Kebab = new Regex("^[a-z0-9]+(-[a-z0-9]+)*$");

    // The inspiration's id, unique in the file (e.g. 'eac').
    public string id { get; }

    // Where the inspiration lives, in communication form: '{workspace}/<folder>' or a repository-relative path.
    public string root { get; }

    // What the inspiration is, in one sentence.
    public string description { get; }

    // The folders inside the root worth reading, relative to it, in file order. Empty when the file names none.
    public string[] paths { get; }

    public InspirationEntry(int index, object raw)
    {
        IDictionary entry = raw as IDictionary;
        if (entry == null) { throw new ArgumentException(string.Format("entry {0} is not a mapping with id, root and description", index)); }

        List<string> errors = new List<string>();
        foreach (object k in entry.Keys)
        {
            string name = k == null ? null : k.ToString();
            if (Array.IndexOf(Allowed, name) < 0) { errors.Add(string.Format("entry {0} has unknown key '{1}' (allowed: {2})", index, name, string.Join(", ", Allowed))); }
        }

        id = OptStr(entry, "id");
        if (id == null) { errors.Add(string.Format("entry {0} has no 'id'", index)); }
        else if (!Kebab.IsMatch(id)) { errors.Add(string.Format("entry {0} id '{1}' is not kebab-case", index, id)); }

        string label = string.Format("entry {0} root", index);
        root = OptStr(entry, "root");
        if (root == null) { errors.Add(string.Format("entry {0} has no 'root'", index)); }
        else { errors.AddRange(InspirationRoot.Violations(label, root, true)); }

        description = OptStr(entry, "description");
        if (description == null) { errors.Add(string.Format("entry {0} has no 'description'", index)); }

        object rawPaths = entry.Contains("paths") ? entry["paths"] : null;
        if (rawPaths != null && !(rawPaths is string) && !(rawPaths is IList))
        {
            errors.Add(string.Format("entry {0} 'paths' is not a list", index));
            paths = new string[0];
        }
        else
        {
            paths = StrArr(entry, "paths");
            foreach (string path in paths)
            {
                errors.AddRange(InspirationRoot.Violations(string.Format("entry {0} path", index), path, false));
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
    }
}
