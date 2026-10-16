/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/TerminologyTerm.cs
    kind: csharp-type
    language: csharp
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/types/TerminologyTerm.cs.md
    adrs:
      - ADR-AUTO-SPELL
---
*/

using System;
using System.Collections;

namespace Catzc.Base.QualityGates;

public sealed class TerminologyTerm : Catzc.Base.Objects.DictionaryRecord
{
    // The approved token, lower-cased as the spell-checker matches it. Required.
    public string term { get; }

    // One line: what the term is and why it is legitimate vocabulary. Required.
    public string meaning { get; }

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
