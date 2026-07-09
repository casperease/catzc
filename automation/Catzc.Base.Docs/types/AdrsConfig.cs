// adrs.yml — the ADR domain-structure registry (RULES ↔ domains wiring). Constructing an instance MAPS and
// VALIDATES the parsed YAML (throwing with every violation collected) and exposes the typed Domains and the
// flattened RuleSets. Registered in Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Docs.AdrsConfig)
// so Get-Config -Config adrs returns this typed model rather than a slippery ordered dictionary
// (docs/adr/automation/module-config-loading.md ADR-CONF-LOADING:5, native-csharp-types.md ADR-AUTO-TYPES:9).
//
// Load-time rules (self-contained — no filesystem or other-config reads; folder↔domain and terminology-token
// cross-checks are shipped-asset integrity TESTS, mirroring the one-directional coupling of the customer
// model, ADR-AZ-CUSTOMER:3):
//   - domains is a non-empty map; each domain has code (^[A-Z]{2,4}$, optionally a compound of two segments
//     like FLOW-CD), a non-empty role, a depends_on list, and a non-empty rulesets map;
//   - every depends_on target resolves to a declared domain, no self-edge, and the domain graph is acyclic;
//   - each ruleset external is ADR-<code>[-<NAME>…] (^ADR-[A-Z]{2,4}(-[A-Z]+)+$), the leaf code (if any)
//     matches the domain-code pattern, and the EFFECTIVE code (leaf override else domain code) is the
//     external's domain segment — the external is 'ADR-<effective>' or begins 'ADR-<effective>-' (so a
//     compound-code domain cites its root ADR as ADR-FLOW-CD and the rest as ADR-FLOW-CD-<NAME>); every
//     external is unique.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Docs;

public sealed class AdrsConfig
{
    private static readonly Regex CodeRe = new Regex("^[A-Z]{2,4}(-[A-Z]{2,4})?$", RegexOptions.Compiled);
    private static readonly Regex ExternalRe = new Regex("^ADR-[A-Z]{2,4}(-[A-Z]+)+$", RegexOptions.Compiled);

    public IReadOnlyList<AdrDomain> Domains { get; }
    public IReadOnlyList<AdrRuleSet> RuleSets { get; }

    public AdrsConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();

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

                    // The external's domain segment is the effective code: the external is either the
                    // domain-root citation 'ADR-<effective>' or a named 'ADR-<effective>-<NAME>'. A compound
                    // domain code (e.g. FLOW-CD, whose ADRs cite ADR-FLOW-CD and ADR-FLOW-CD-<NAME>) is matched
                    // by this prefix rule without splitting on a specific dash.
                    string expectedPrefix = "ADR-" + effective;
                    bool domainSegmentMatches = string.Equals(external, expectedPrefix, StringComparison.Ordinal)
                        || external.StartsWith(expectedPrefix + "-", StringComparison.Ordinal);
                    if (!domainSegmentMatches)
                    {
                        errors.Add(string.Format("ruleset '{0}/{1}': external '{2}' domain segment does not match effective code '{3}'", name, slug, external, effective));
                    }

                    AdrRuleSet one = new AdrRuleSet(name, role, slug, external, effective, code, terminology);
                    ruleSets.Add(one);
                    allRuleSets.Add(one);
                }
            }

            domains.Add(new AdrDomain(name, code, role, deps, ruleSets));
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

        Domains = domains;
        RuleSets = allRuleSets;
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
