/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/TerminologyTerm.cs
    kind: type
    module: Catzc.Base.QualityGates
    adrs:
      - ADR-AUTO-SPELL
      - ADR-AUTO-SPELL#5
      - ADR-AUTO-SPELL#8
---
*/

// An abbreviation carries its full-word expansion; the entries of the other categories do not.
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/TerminologyTerm.cs.md#comment1)

using System;
using System.Collections;

namespace Catzc.Base.QualityGates;

public sealed class TerminologyTerm : Catzc.Base.Objects.DictionaryRecord
{
    // The approved token, lower-cased as the spell-checker matches it. Required.
    public string term { get; }

    // One line: what the term is and why it is legitimate vocabulary. Required.
    public string meaning { get; }

    // Supplied by TerminologyConfig from the registry grouping, not read from the entry itself.
    // [comment:2](/docs/references/automation/catzc-base-qualitygates/types/TerminologyTerm.cs.md#comment2)
    public string category { get; }

    // The full word an abbreviation stands for. Required when category is 'abbreviation', else absent.
    public string expands_to { get; }

    public TerminologyTerm(IDictionary d, string category)
    {
        if (d == null) { throw new ArgumentException("TerminologyTerm requires a dictionary"); }
        term = Req(d, "term");
        meaning = Req(d, "meaning");
        this.category = category;
        expands_to = OptStr(d, "expands_to");

        if (category == "abbreviation" && expands_to == null)
        {
            throw new ArgumentException(string.Format(
                "term '{0}': an abbreviation must carry 'expands_to'", term));
        }
        if (category != "abbreviation" && expands_to != null)
        {
            throw new ArgumentException(string.Format(
                "term '{0}': only an abbreviation carries 'expands_to'", term));
        }
    }
}
