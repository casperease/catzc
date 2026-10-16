/*
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Inspiration/types/InspirationConfig.cs
    folder: types
    name: inspiration-config
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Tooling.Inspiration
    moduletype: pwsh-folder
    catzc_bundle: full
    relatives:
      page: docs/references/automation/catzc-tooling-inspiration/types/InspirationConfig.cs.md
      test: automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#8
      - ADR-REPO-INSPIRE
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace Catzc.Tooling.Inspiration;

public sealed class InspirationConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "inspiration.yml is malformed:\n  - ";

    // The sensible default: the sibling 'eac' checkout in the workspace.
    public static IReadOnlyList<InspirationEntry> DefaultInspirations { get; } = Array.AsReadOnly(new[]
    {
        new InspirationEntry(0, new OrderedDictionary
        {
            { "id", "eac" },
            { "root", InspirationRoot.WorkspaceAnchor + "/eac" },
            { "description", "Sibling Go monorepo of the same project family. Ideas, not a reference implementation." },
            { "paths", new[] { "docs", "specs", "contracts", "go" } },
        }),
    });

    // The inspirations, in file order.
    public IReadOnlyList<InspirationEntry> inspirations { get; }

    public InspirationConfig(IDictionary raw)
    {
        if (raw == null) { inspirations = DefaultInspirations; return; }

        List<string> errors = new List<string>();
        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (key != "inspirations") { errors.Add(string.Format("unknown top-level key '{0}' (allowed: inspirations)", key)); }
        }

        List<InspirationEntry> list = new List<InspirationEntry>();
        object value = raw.Contains("inspirations") ? raw["inspirations"] : null;
        if (value == null)
        {
            list.AddRange(DefaultInspirations);
        }
        else if (value is string || value is IDictionary || !(value is IEnumerable))
        {
            errors.Add("'inspirations' is not a list of { id, root, description, paths } entries");
        }
        else
        {
            int index = 0;
            HashSet<string> seen = new HashSet<string>(StringComparer.Ordinal);
            foreach (object item in (IEnumerable)value)
            {
                try
                {
                    InspirationEntry entry = new InspirationEntry(index, item);
                    if (!seen.Add(entry.id)) { errors.Add(string.Format("entry {0} repeats the id '{1}'", index, entry.id)); }
                    list.Add(entry);
                }
                catch (ArgumentException ex) { errors.Add(ex.Message.Replace("\n", "\n  - ")); }
                index++;
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n  - ", errors)); }
        inspirations = list.AsReadOnly();
    }
}
