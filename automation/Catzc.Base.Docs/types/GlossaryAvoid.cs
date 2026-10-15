// catzc:
//   path: automation/Catzc.Base.Docs/types/GlossaryAvoid.cs
//   module: Catzc.Base.Docs

// The phrase is stored lower-cased and its replacement is required, so a violation can always name the fix.
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8),
// [ADR-REPO-VOCAB#5](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab5)
// [comment:1](/docs/references/automation/catzc-base-docs/types/GlossaryAvoid.cs.md#comment1)

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
