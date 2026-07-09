// One approved-vocabulary entry from configs/terminology.yml — a term and its meaning. Its category is the
// group it is listed under in the registry (terms: <category>: [...]), passed in by TerminologyConfig, so
// the entry itself carries no category key. An abbreviation carries its full-word expansion; the other
// categories do not. Mirrors a terminology.yml entry (snake_case keys). See
// docs/adr/automation/spell-out-names.md (ADR-AUTO-SPELL:5-ADR-AUTO-SPELL:8).
//
// Derives from Catzc.Base.Objects.DictionaryRecord, so an instance also presents as a read-only dictionary
// over its own properties and its constructor uses the base's Req/OptStr extraction helpers.

using System;
using System.Collections;

namespace Catzc.Base.QualityGates;

public sealed class TerminologyTerm : Catzc.Base.Objects.DictionaryRecord
{
    // The approved token, lower-cased as the spell-checker matches it. Required.
    public string term       { get; }

    // One line: what the term is and why it is legitimate vocabulary. Required.
    public string meaning    { get; }

    // The group this term is listed under (a defined category). Supplied by TerminologyConfig from the
    // registry's terms: <category>: grouping, not read from the entry.
    public string category   { get; }

    // The full word an abbreviation stands for. Required when category is 'abbreviation', else absent.
    public string expands_to { get; }

    public TerminologyTerm(IDictionary d, string category)
    {
        if (d == null) { throw new ArgumentException("TerminologyTerm requires a dictionary"); }
        term          = Req(d, "term");
        meaning       = Req(d, "meaning");
        this.category = category;
        expands_to    = OptStr(d, "expands_to");

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
