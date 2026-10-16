/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.Docs/types/GlossaryAvoid.cs
    folder: types
    name: glossary-avoid
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-docs/types/GlossaryAvoid.cs.md
    cites:
      - ADR-AUTO-TYPES#8
      - ADR-REPO-VOCAB#5
---
*/

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
