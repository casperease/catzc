/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/types/AdrsConfig.cs
    kind: csharp-type
    module: Catzc.Base.Docs
    relatives:
      page: docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md
      test: automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#9
      - ADR-AZ-CUSTOMER#3
      - ADR-CONF-LOADING#4
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-FLOW-CD
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Docs;

public sealed class AdrsConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static readonly Regex CodeRe = new Regex("^[A-Z]{2,4}(-[A-Z]{2,4})?$", RegexOptions.Compiled);
    private static readonly Regex ExternalRe = new Regex("^ADR-[A-Z]{2,4}(-[A-Z]+)+$", RegexOptions.Compiled);

    // The rows of the value-chain stack, top to bottom ([ADR-DSGN-TRACK#14](/docs/adr/design/tracks.md#rule-adr-dsgn-track14)).
    public static readonly IReadOnlyList<string> Stacks = Array.AsReadOnly(new[] { "PRIN", "DSGN", "AUTO", "PIPE", "CLOUD" });

    public static readonly IReadOnlyList<string> Concerns = Array.AsReadOnly(new[] { "automation", "build", "quality-control", "release", "deploy", "access" });

    public IReadOnlyList<AdrDomain> Domains { get; }
    public IReadOnlyList<AdrRuleSet> RuleSets { get; }
    public IReadOnlyList<AdrDomainEdge> Edges { get; }

    private static readonly string[] AllowedKeys = { "domains" };
    private static readonly string[] AllowedDomainKeys = { "code", "role", "description", "depends_on", "stack", "concern", "rulesets" };
    private static readonly string[] AllowedRuleSetKeys = { "external", "code", "terminology", "concern" };

    public AdrsConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string topKey = key == null ? string.Empty : key.ToString();
                if (Array.IndexOf(AllowedKeys, topKey) < 0)
                {
                    errors.Add(string.Format("unknown top-level key '{0}' (allowed: {1})", topKey, string.Join(", ", AllowedKeys)));
                }
            }
        }

        IDictionary domainsMap = (raw != null && raw.Contains("domains")) ? raw["domains"] as IDictionary : null;
        if (domainsMap == null || domainsMap.Count == 0)
        {
            throw new ArgumentException("adrs.yml requires a non-empty 'domains' map");
        }

        HashSet<string> domainNames = new HashSet<string>(StringComparer.Ordinal);
        foreach (object k in domainsMap.Keys)
        {
            string n = k == null ? null : k.ToString();
            if (!string.IsNullOrEmpty(n)) { domainNames.Add(n); }
        }

        List<AdrDomain> domains = new List<AdrDomain>();
        List<AdrRuleSet> allRuleSets = new List<AdrRuleSet>();
        Dictionary<string, string> seenExternals = new Dictionary<string, string>(StringComparer.Ordinal);
        Dictionary<string, List<string>> graph = new Dictionary<string, List<string>>(StringComparer.Ordinal);

        foreach (object dk in domainsMap.Keys)
        {
            string name = dk == null ? null : dk.ToString();
            IDictionary d = domainsMap[dk] as IDictionary;
            if (d == null) { errors.Add(string.Format("domain '{0}': must be a mapping", name)); continue; }

            CheckKeys(d, AllowedDomainKeys, string.Format("domain '{0}'", name), errors);

            string code = d.Contains("code") && d["code"] != null ? d["code"].ToString() : null;
            if (code == null || !CodeRe.IsMatch(code))
            {
                errors.Add(string.Format("domain '{0}': code '{1}' must be 2-4 uppercase letters", name, code));
            }
            string role = d.Contains("role") && d["role"] != null ? d["role"].ToString() : null;
            if (string.IsNullOrWhiteSpace(role))
            {
                errors.Add(string.Format("domain '{0}': missing 'role'", name));
            }
            string description = d.Contains("description") && d["description"] != null ? d["description"].ToString().Trim() : null;
            if (string.IsNullOrWhiteSpace(description))
            {
                errors.Add(string.Format("domain '{0}': missing 'description'", name));
            }

            string stack = d.Contains("stack") && d["stack"] != null ? d["stack"].ToString() : null;
            if (stack == null)
            {
                errors.Add(string.Format("domain '{0}': missing 'stack' (allowed: {1})", name, string.Join(", ", Stacks)));
            }
            else if (!Contains(Stacks, stack))
            {
                errors.Add(string.Format("domain '{0}': stack '{1}' is not a row of the value-chain stack (allowed: {2})", name, stack, string.Join(", ", Stacks)));
            }

            IReadOnlyList<string> domainConcerns = null;
            if (!d.Contains("concern") || d["concern"] == null)
            {
                errors.Add(string.Format("domain '{0}': missing 'concern' (one or more of: {1})", name, string.Join(", ", Concerns)));
            }
            else
            {
                domainConcerns = ParseConcerns(d["concern"], string.Format("domain '{0}'", name), errors);
            }

            List<string> deps = new List<string>();
            object depsRaw = d.Contains("depends_on") ? d["depends_on"] : null;
            IEnumerable depsList = (depsRaw is string) ? null : depsRaw as IEnumerable;
            if (depsList != null)
            {
                foreach (object t in depsList)
                {
                    string ts = t == null ? null : t.ToString();
                    if (ts != null) { deps.Add(ts); }
                }
            }
            graph[name] = deps;
            foreach (string t in deps)
            {
                if (t == name) { errors.Add(string.Format("domain '{0}': depends_on itself", name)); }
                else if (!domainNames.Contains(t)) { errors.Add(string.Format("domain '{0}': depends_on '{1}' is not a declared domain", name, t)); }
            }

            List<AdrRuleSet> ruleSets = new List<AdrRuleSet>();
            IDictionary rulesetMap = d.Contains("rulesets") ? d["rulesets"] as IDictionary : null;
            if (rulesetMap == null || rulesetMap.Count == 0)
            {
                errors.Add(string.Format("domain '{0}': missing or empty 'rulesets'", name));
            }
            else
            {
                foreach (object sk in rulesetMap.Keys)
                {
                    string slug = sk == null ? null : sk.ToString();
                    IDictionary r = rulesetMap[sk] as IDictionary;
                    if (r == null) { errors.Add(string.Format("ruleset '{0}/{1}': must be a mapping", name, slug)); continue; }

                    CheckKeys(r, AllowedRuleSetKeys, string.Format("ruleset '{0}/{1}'", name, slug), errors);

                    string external = r.Contains("external") && r["external"] != null ? r["external"].ToString() : null;
                    if (external == null || !ExternalRe.IsMatch(external))
                    {
                        errors.Add(string.Format("ruleset '{0}/{1}': external '{2}' must be ADR-<DC>-<NAME>", name, slug, external));
                        continue;
                    }
                    if (seenExternals.ContainsKey(external))
                    {
                        errors.Add(string.Format("ruleset '{0}/{1}': external '{2}' duplicates '{3}'", name, slug, external, seenExternals[external]));
                    }
                    else
                    {
                        seenExternals[external] = string.Format("{0}/{1}", name, slug);
                    }

                    string leaf = r.Contains("code") && r["code"] != null ? r["code"].ToString() : null;
                    if (leaf != null && !CodeRe.IsMatch(leaf))
                    {
                        errors.Add(string.Format("ruleset '{0}/{1}': code override '{2}' must be 2-4 uppercase letters", name, slug, leaf));
                    }
                    string effective = leaf != null ? leaf : code;
                    string terminology = r.Contains("terminology") && r["terminology"] != null ? r["terminology"].ToString() : null;

                    string expectedPrefix = "ADR-" + effective;
                    bool domainSegmentMatches = string.Equals(external, expectedPrefix, StringComparison.Ordinal)
                        || external.StartsWith(expectedPrefix + "-", StringComparison.Ordinal);
                    if (!domainSegmentMatches)
                    {
                        errors.Add(string.Format("ruleset '{0}/{1}': external '{2}' domain segment does not match effective code '{3}'", name, slug, external, effective));
                    }

                    // The value-chain concerns: the ruleset's own list when it declares one, else the domain default.
                    IReadOnlyList<string> concerns = domainConcerns;
                    if (r.Contains("concern"))
                    {
                        concerns = r["concern"] == null
                            ? Fail(string.Format("ruleset '{0}/{1}': 'concern' must list one or more of: {2}", name, slug, string.Join(", ", Concerns)), errors)
                            : ParseConcerns(r["concern"], string.Format("ruleset '{0}/{1}'", name, slug), errors);
                    }

                    AdrRuleSet one = new AdrRuleSet(name, role, slug, external, effective, code, terminology, stack, concerns, domainConcerns);
                    ruleSets.Add(one);
                    allRuleSets.Add(one);
                }
            }

            domains.Add(new AdrDomain(name, code, role, description, deps, stack, domainConcerns, ruleSets));
        }

        // Acyclic domain graph (depth-first cycle detection: 1 = on the current stack, 2 = fully explored).
        Dictionary<string, int> state = new Dictionary<string, int>(StringComparer.Ordinal);
        foreach (string n in domainNames)
        {
            DetectCycle(n, graph, state, errors);
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("adrs.yml is invalid:\n  - " + string.Join("\n  - ", errors));
        }

        // The domain DAG as edges, one per depends_on link in declaration order — built only from validated domains.
        List<AdrDomainEdge> edges = new List<AdrDomainEdge>();
        foreach (AdrDomain domain in domains)
        {
            foreach (string target in domain.DependsOn)
            {
                edges.Add(new AdrDomainEdge(domain.Name, target));
            }
        }

        Domains = domains;
        RuleSets = allRuleSets;
        Edges = edges;
    }

    private static void CheckKeys(IDictionary map, string[] allowed, string where, List<string> errors)
    {
        foreach (object key in map.Keys)
        {
            string k = key == null ? string.Empty : key.ToString();
            if (Array.IndexOf(allowed, k) < 0)
            {
                errors.Add(string.Format("{0}: unknown key '{1}' (allowed: {2})", where, k, string.Join(", ", allowed)));
            }
        }
    }

    private static bool Contains(IReadOnlyList<string> list, string value)
    {
        foreach (string item in list)
        {
            if (string.Equals(item, value, StringComparison.Ordinal)) { return true; }
        }
        return false;
    }

    private static IReadOnlyList<string> Fail(string message, List<string> errors)
    {
        errors.Add(message);
        return null;
    }

    // A concern list: a YAML sequence of one or more distinct value-chain concerns, returned in value-chain order.
    private static IReadOnlyList<string> ParseConcerns(object raw, string where, List<string> errors)
    {
        IEnumerable list = (raw is string) ? null : raw as IEnumerable;
        if (list == null)
        {
            return Fail(string.Format("{0}: 'concern' must be a list, e.g. [{1}]", where, Concerns[0]), errors);
        }

        HashSet<string> declared = new HashSet<string>(StringComparer.Ordinal);
        bool valid = true;
        foreach (object item in list)
        {
            string value = item == null ? null : item.ToString();
            if (value == null || !Contains(Concerns, value))
            {
                errors.Add(string.Format("{0}: concern '{1}' is not a value-chain concern (allowed: {2})", where, value, string.Join(", ", Concerns)));
                valid = false;
            }
            else if (!declared.Add(value))
            {
                errors.Add(string.Format("{0}: concern '{1}' is listed twice", where, value));
                valid = false;
            }
        }
        if (declared.Count == 0 && valid)
        {
            return Fail(string.Format("{0}: 'concern' must list one or more of: {1}", where, string.Join(", ", Concerns)), errors);
        }
        if (!valid) { return null; }

        List<string> ordered = new List<string>();
        foreach (string concern in Concerns)
        {
            if (declared.Contains(concern)) { ordered.Add(concern); }
        }
        return ordered.AsReadOnly();
    }

    private static void DetectCycle(string node, Dictionary<string, List<string>> graph, Dictionary<string, int> state, List<string> errors)
    {
        int current;
        if (state.TryGetValue(node, out current) && current != 0) { return; }
        state[node] = 1;
        List<string> successors;
        if (graph.TryGetValue(node, out successors))
        {
            foreach (string next in successors)
            {
                if (!graph.ContainsKey(next)) { continue; }
                int nextState;
                state.TryGetValue(next, out nextState);
                if (nextState == 1) { errors.Add(string.Format("domain dependency cycle through '{0}' -> '{1}'", node, next)); }
                else if (nextState != 2) { DetectCycle(next, graph, state, errors); }
            }
        }
        state[node] = 2;
    }
}
