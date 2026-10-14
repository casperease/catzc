// One avoided phrasing of a glossary concept (a configs/glossary.yml `avoid:` entry): the phrase that must not
// appear in prose within the source's scope, and what to say instead. Mirrors the YAML entry (snake_case keys,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)). The phrase is stored lower-cased — matching is
// case-insensitive and word-bounded — and the
// phrase and its replacement are both required, so a violation can always name the fix. See
// [ADR-REPO-VOCAB#5](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab5).

using System;
using System.Collections;

namespace Catzc.Base.Docs;

public sealed class GlossaryAvoid : Catzc.Base.Objects.DictionaryRecord
{
    // The avoided phrasing, lower-cased with its whitespace collapsed. Required.
    public string phrase { get; }

    // The replacement wording a violation message recommends. Required.
    public string say { get; }

    public GlossaryAvoid(IDictionary d)
    {
        if (d == null) { throw new ArgumentException("an avoid entry must be a mapping with 'phrase' and 'say'"); }
        phrase = string.Join(" ", Req(d, "phrase").Trim().ToLowerInvariant().Split((char[])null, StringSplitOptions.RemoveEmptyEntries));
        say = Req(d, "say").Trim();

        foreach (object k in d.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (key != "phrase" && key != "say")
            {
                throw new ArgumentException(string.Format("avoid '{0}': unknown key '{1}' (allowed: phrase, say)", phrase, key));
            }
        }
    }
}
