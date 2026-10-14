// One defined term of the controlled vocabulary (a configs/glossary.yml `concepts:` entry, keyed by the term). It
// carries the term's machine key, its ADR domain, the ONE rule that defines it
// ([ADR-REPO-VOCAB#1](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab1)), a one-line
// definition, how it exists in the repository (GlossaryRealization), and optionally its relations to other terms,
// its contrasts with similar terms (each explained,
// [ADR-REPO-VOCAB#4](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab4)), and its avoided phrasings (GlossaryAvoid,
// [ADR-REPO-VOCAB#5](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab5)), and the words allowed to qualify its
// head word (forms, [ADR-REPO-VOCAB#8](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab8)). Mirrors the YAML entry (snake_case keys,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//
// Only the entry's own shape is checked here. Whether `defined_by` names a real rule, `domain` a declared ADR
// domain, and the relation/contrast targets real concepts are cross-file facts, checked by the glossary checks
// (Test-Glossary), not on load — so loading a glossary stays hermetic (the
// [ADR-AZ-CUSTOMER#3](/docs/adr/azure/azure-customer-model.md#rule-adr-az-customer3) pattern).

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Docs;

public sealed class GlossaryConcept : Catzc.Base.Objects.DictionaryRecord
{
    // The closed set of relation kinds.
    public static readonly IReadOnlyList<string> RelationKinds = new[] { "part_of", "kind_of", "selected_by" };

    private static readonly string[] AllowedKeys =
    {
        "key", "domain", "defined_by", "short", "realized_by", "relations", "contrasts", "avoid", "forms", "verbs"
    };

    // A term: lower-case words joined by single spaces or hyphens ('test suite', 'deployable-unit').
    public static readonly Regex TermRe = new Regex("^[a-z0-9]+([ -][a-z0-9]+)*$", RegexOptions.Compiled);

    // A machine key: snake_case ('test_suite', 'all_tests').
    public static readonly Regex KeyRe = new Regex("^[a-z][a-z0-9]*(_[a-z0-9]+)*$", RegexOptions.Compiled);

    // A rule citation in the '#' form: ADR-<code>[-<NAME>…]#<n>
    // ([ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30),
    // [ADR-FLOW-CD#2](/docs/adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd2)).
    public static readonly Regex CitationRe = new Regex("^ADR-[A-Z]{2,4}(-[A-Z]+)+#[1-9][0-9]*$", RegexOptions.Compiled);

    // One qualifier word in a concept's forms ('quality', 'CI').
    public static readonly Regex FormRe = new Regex("^[A-Za-z0-9]+$", RegexOptions.Compiled);

    // An ADR domain key, as adrs.yml spells it ('automation', 'repository').
    private static readonly Regex DomainRe = new Regex("^[a-z]+(-[a-z]+)*$", RegexOptions.Compiled);

    // The canonical term (the concepts: map key). Required.
    public string term { get; }

    // The snake_case machine key. Required.
    public string key { get; }

    // The adrs.yml domain the term belongs to. Required.
    public string domain { get; }

    // The citation of the one rule that defines the term. Required.
    public string defined_by { get; }

    // The one-line definition (generated glossary and violation messages). Required.
    public string @short { get; }

    // How the concept exists in the repository. Required.
    public GlossaryRealization realized_by { get; }

    // Relation kind -> related terms. Empty when the entry has no relations.
    public IReadOnlyDictionary<string, IReadOnlyList<string>> relations { get; }

    // Similar term -> one sentence on how this concept differs. Empty when the entry names no similar term.
    public IReadOnlyDictionary<string, string> contrasts { get; }

    // The avoided phrasings, in entry order. Empty when the entry avoids none.
    public IReadOnlyList<GlossaryAvoid> avoid { get; }

    // The words allowed to qualify the term's head word ('quality' in 'quality gate'), in entry order. Empty when the
    // entry declares no forms; then the qualified-forms check (G6) does not look at the term.
    public IReadOnlyList<string> forms { get; }

    // Whether the head word's -ed and -ing forms are ordinary English for this term ('scoped', 'sourced'), so the
    // qualified-forms check (G6) allows them. False by default: a noun family such as 'gate' takes no verb forms.
    public bool verbs { get; }

    public GlossaryConcept(string term, IDictionary d)
    {
        this.term = term;
        List<string> errors = new List<string>();

        if (string.IsNullOrWhiteSpace(term) || !TermRe.IsMatch(term))
        {
            errors.Add("the term must be lower-case words joined by single spaces or hyphens");
        }
        if (d == null) { throw Fail(term, new List<string> { "must be a mapping" }); }

        foreach (object k in d.Keys)
        {
            string name = k == null ? null : k.ToString();
            if (Array.IndexOf(AllowedKeys, name) < 0)
            {
                errors.Add(string.Format("unknown key '{0}' (allowed: {1})", name, string.Join(", ", AllowedKeys)));
            }
        }

        key = Capture(() => Req(d, "key"), errors);
        domain = Capture(() => Req(d, "domain"), errors);
        defined_by = Capture(() => Req(d, "defined_by"), errors);
        @short = Capture(() => Req(d, "short").Trim(), errors);

        if (key != null && !KeyRe.IsMatch(key)) { errors.Add(string.Format("key '{0}' must be snake_case", key)); }
        if (domain != null && !DomainRe.IsMatch(domain)) { errors.Add(string.Format("domain '{0}' must be an adrs.yml domain key", domain)); }
        if (defined_by != null && !CitationRe.IsMatch(defined_by))
        {
            errors.Add(string.Format("defined_by '{0}' must be a rule citation ADR-<CODE>-<NAME>#<n>", defined_by));
        }

        IDictionary realization = d.Contains("realized_by") ? d["realized_by"] as IDictionary : null;
        if (realization == null) { errors.Add("realized_by is required (a mapping with 'kind' and 'pattern')"); }
        else
        {
            try { realized_by = new GlossaryRealization(realization); }
            catch (ArgumentException ex) { errors.Add(ex.Message); }
        }

        relations = ParseRelations(d, errors);
        contrasts = ParseContrasts(d, errors);
        avoid = ParseAvoid(d, errors);
        forms = ParseForms(d, errors);
        verbs = Flag(d, "verbs");

        if (errors.Count > 0) { throw Fail(term, errors); }
    }

    private static string Capture(Func<string> read, List<string> errors)
    {
        try { return read(); }
        catch (ArgumentException ex) { errors.Add(ex.Message); return null; }
    }

    private static ArgumentException Fail(string term, List<string> errors)
    {
        return new ArgumentException(string.Format("concept '{0}': {1}", term, string.Join("; ", errors)));
    }

    private static IReadOnlyDictionary<string, IReadOnlyList<string>> ParseRelations(IDictionary d, List<string> errors)
    {
        Dictionary<string, IReadOnlyList<string>> map = new Dictionary<string, IReadOnlyList<string>>(StringComparer.Ordinal);
        if (!d.Contains("relations") || d["relations"] == null) { return map; }
        IDictionary raw = d["relations"] as IDictionary;
        if (raw == null) { errors.Add("relations must be a mapping of relation kind to a list of terms"); return map; }

        foreach (object k in raw.Keys)
        {
            string kind = k == null ? null : k.ToString();
            if (Array.IndexOf((string[])RelationKinds, kind) < 0)
            {
                errors.Add(string.Format("relations: '{0}' is not one of {1}", kind, string.Join(", ", RelationKinds)));
                continue;
            }
            List<string> targets = new List<string>();
            foreach (string target in StrArr(raw, kind))
            {
                if (!TermRe.IsMatch(target)) { errors.Add(string.Format("relations.{0}: '{1}' is not a term", kind, target)); }
                else { targets.Add(target); }
            }
            map[kind] = targets;
        }
        return map;
    }

    private IReadOnlyDictionary<string, string> ParseContrasts(IDictionary d, List<string> errors)
    {
        Dictionary<string, string> map = new Dictionary<string, string>(StringComparer.Ordinal);
        if (!d.Contains("contrasts") || d["contrasts"] == null) { return map; }
        IDictionary raw = d["contrasts"] as IDictionary;
        if (raw == null) { errors.Add("contrasts must be a mapping of similar term to how this one differs"); return map; }

        foreach (object k in raw.Keys)
        {
            string other = k == null ? null : k.ToString();
            string why = raw[k] == null ? null : raw[k].ToString().Trim();
            if (other == null || !TermRe.IsMatch(other)) { errors.Add(string.Format("contrasts: '{0}' is not a term", other)); continue; }
            if (other == term) { errors.Add("contrasts: a concept cannot contrast with itself"); continue; }
            if (string.IsNullOrWhiteSpace(why)) { errors.Add(string.Format("contrasts: '{0}' needs a sentence on how this concept differs", other)); continue; }
            map[other] = why;
        }
        return map;
    }

    private static IReadOnlyList<string> ParseForms(IDictionary d, List<string> errors)
    {
        List<string> list = new List<string>();
        if (!d.Contains("forms") || d["forms"] == null) { return list; }
        object raw = d["forms"];
        if (raw is string || raw is IDictionary || !(raw is IEnumerable))
        {
            errors.Add("forms must be a list of single qualifier words");
            return list;
        }
        HashSet<string> seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        foreach (object item in (IEnumerable)raw)
        {
            string word = item == null ? null : item.ToString().Trim();
            if (word == null || !FormRe.IsMatch(word)) { errors.Add(string.Format("forms: '{0}' must be one word (letters and digits)", word)); continue; }
            if (!seen.Add(word)) { errors.Add(string.Format("forms: '{0}' is listed twice", word)); continue; }
            list.Add(word);
        }
        return list;
    }

    private static IReadOnlyList<GlossaryAvoid> ParseAvoid(IDictionary d, List<string> errors)
    {
        List<GlossaryAvoid> list = new List<GlossaryAvoid>();
        if (!d.Contains("avoid") || d["avoid"] == null) { return list; }
        object raw = d["avoid"];
        IEnumerable seq = raw is string ? null : raw as IEnumerable;
        if (seq == null || raw is IDictionary) { errors.Add("avoid must be a list of { phrase, say } entries"); return list; }

        foreach (object item in seq)
        {
            try { list.Add(new GlossaryAvoid(item as IDictionary)); }
            catch (ArgumentException ex) { errors.Add(ex.Message); }
        }
        return list;
    }
}
