/*
---
catzc:
  immutable:
    with_body_sha: "4043f4c2d701"
  edges:
    test: pwsh/Catzc.Base.Docs/tests/types/GlossaryConfig.Tests.ps1
    docs: "[GlossaryConfig.cs.md](../../../docs/references/pwsh/catzc-base-docs/types/GlossaryConfig.cs.md)"
    cites:
      - ADR-AZ-CUSTOMER-REFERENCENOTVALIDATEDONLOAD
      - ADR-REPO-VOCAB
---
*/

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Docs;

public sealed class GlossaryConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The source's parameters, every key defaulted.
    public GlossaryOptions options { get; }

    // The source's concepts, in source order.
    public IReadOnlyList<GlossaryConcept> concepts { get; }

    public GlossaryConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException("glossary config validation failed:\nthe glossary must be a mapping"); }

        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (key != "options" && key != "concepts")
            {
                errors.Add(string.Format("unknown top-level key '{0}' (allowed: options, concepts)", key));
            }
        }

        CollectUrls(raw, "", errors);

        object optionsRaw = raw.Contains("options") ? raw["options"] : null;
        if (optionsRaw != null && !(optionsRaw is IDictionary)) { errors.Add("'options' must be a mapping"); }
        try { options = new GlossaryOptions(optionsRaw as IDictionary); }
        catch (ArgumentException ex) { errors.Add(ex.Message); }

        List<GlossaryConcept> list = new List<GlossaryConcept>();
        IDictionary conceptMap = raw.Contains("concepts") ? raw["concepts"] as IDictionary : null;
        if (conceptMap == null || conceptMap.Count == 0)
        {
            errors.Add("the glossary requires a non-empty 'concepts' map keyed by term");
        }
        else
        {
            foreach (object k in conceptMap.Keys)
            {
                try { list.Add(new GlossaryConcept(k == null ? null : k.ToString(), conceptMap[k] as IDictionary)); }
                catch (ArgumentException ex) { errors.Add(ex.Message); }
            }
        }
        concepts = list;

        Dictionary<string, string> keyOwner = new Dictionary<string, string>(StringComparer.Ordinal);
        HashSet<string> terms = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        foreach (GlossaryConcept c in list) { terms.Add(c.term); }
        foreach (GlossaryConcept c in list)
        {
            if (keyOwner.ContainsKey(c.key))
            {
                errors.Add(string.Format("concept '{0}': key '{1}' duplicates concept '{2}'", c.term, c.key, keyOwner[c.key]));
            }
            else { keyOwner[c.key] = c.term; }

            foreach (GlossaryAvoid a in c.avoid)
            {
                if (terms.Contains(a.phrase))
                {
                    errors.Add(string.Format("concept '{0}': avoided phrase '{1}' is itself a defined term", c.term, a.phrase));
                }
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("glossary config validation failed:\n" + string.Join("\n", errors));
        }
    }

    // Every string value (and map key) in the source, walked recursively; one containing '://' is a URL.
    private static void CollectUrls(object node, string path, List<string> errors)
    {
        IDictionary map = node as IDictionary;
        if (map != null)
        {
            foreach (object k in map.Keys)
            {
                string key = k == null ? "" : k.ToString();
                string here = path.Length == 0 ? key : path + "." + key;
                if (key.Contains("://")) { errors.Add(string.Format("{0}: a glossary stays in the repository — no URLs", here)); }
                CollectUrls(map[k], here, errors);
            }
            return;
        }
        string text = node as string;
        if (text != null)
        {
            if (text.Contains("://")) { errors.Add(string.Format("{0}: a glossary stays in the repository — no URLs ('{1}')", path, text)); }
            return;
        }
        IEnumerable seq = node as IEnumerable;
        if (seq != null)
        {
            int i = 0;
            foreach (object item in seq) { CollectUrls(item, string.Format("{0}[{1}]", path, i++), errors); }
        }
    }
}
