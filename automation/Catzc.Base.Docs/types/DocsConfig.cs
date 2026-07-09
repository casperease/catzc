// The README copy-in registry (configs/readme.yml) and its validity rules: an optional 'patterns' list of
// glob-derived source conventions and an optional 'mappings' list of explicit folder->source entries, with at
// least one entry across the two. Constructing an instance validates the registry (throwing on the first
// malformed shape) and exposes the parsed patterns and mappings to the generator (Build-Readme, which expands
// the patterns against the filesystem via Get-ReadmeMappings). Registered as the `readme` config's type
// override in Catzc.Base.Config/configs/configs.yml. See docs/adr/configuration/module-config-loading.md and
// docs/adr/repository/generated-readmes.md.

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Docs;

public sealed class DocsConfig
{
    // Glob-derived source conventions, in registry order.
    public IReadOnlyList<DocPattern> patterns { get; }

    // Explicit folder->source README copy-ins, in registry order.
    public IReadOnlyList<DocMapping> mappings { get; }

    public DocsConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();

        patterns = ParsePatterns(raw, errors);
        mappings = ParseMappings(raw, errors);

        if (errors.Count == 0 && patterns.Count == 0 && mappings.Count == 0)
        {
            errors.Add("readme config requires at least one 'patterns' or 'mappings' entry");
        }
        if (errors.Count > 0)
        {
            throw new ArgumentException("readme config validation failed:\n" + string.Join("\n", errors));
        }
    }

    private static IReadOnlyList<DocPattern> ParsePatterns(IDictionary raw, List<string> errors)
    {
        List<DocPattern> list = new List<DocPattern>();
        object obj = (raw != null && raw.Contains("patterns")) ? raw["patterns"] : null;
        if (obj == null) { return list; }

        IEnumerable seq = obj as IEnumerable;
        if (seq == null || obj is string) { errors.Add("'patterns' must be a list"); return list; }

        foreach (object item in seq)
        {
            IDictionary entry = item as IDictionary;
            if (entry == null) { errors.Add("each 'patterns' entry must be a mapping"); continue; }
            try { list.Add(new DocPattern(entry)); }
            catch (ArgumentException ex) { errors.Add(ex.Message); }
        }
        return list;
    }

    private static IReadOnlyList<DocMapping> ParseMappings(IDictionary raw, List<string> errors)
    {
        List<DocMapping> list = new List<DocMapping>();
        HashSet<string> seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        object obj = (raw != null && raw.Contains("mappings")) ? raw["mappings"] : null;
        if (obj == null) { return list; }

        IEnumerable seq = obj as IEnumerable;
        if (seq == null || obj is string) { errors.Add("'mappings' must be a list"); return list; }

        foreach (object item in seq)
        {
            IDictionary entry = item as IDictionary;
            if (entry == null) { errors.Add("each 'mappings' entry must be a mapping"); continue; }

            DocMapping m;
            try { m = new DocMapping(entry); }
            catch (ArgumentException ex) { errors.Add(ex.Message); continue; }

            if (!seen.Add(m.folder)) { errors.Add(string.Format("duplicate target folder '{0}'", m.folder)); continue; }
            list.Add(m);
        }
        return list;
    }
}
