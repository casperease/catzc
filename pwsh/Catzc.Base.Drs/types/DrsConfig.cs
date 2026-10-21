/*
---
catzc:
  immutable:
    with_body_sha: "31830ea773d1"
  edges:
    test: pwsh/Catzc.Base.Drs/tests/types/DrsConfig.Tests.ps1
    docs: "[DrsConfig.cs.md](docs/references/pwsh/catzc-base-docs/types/DrsConfig.cs.md)"
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-AUTO-LAYERS-REALISENEVERREDEFINE
      - ADR-AZ-CUSTOMER-REFERENCENOTVALIDATEDONLOAD
      - ADR-BCL-TYPES-NATIVETYPEDMODEL
      - ADR-CONF-LOADING-CSHARPCONFIGTYPE
      - ADR-REPO-AI
      - ADR-REPO-DRSCODE-PATHOFSEGMENTS
      - ADR-REPO-DRSCODE-DOMAINSEGMENT
      - DDR-TRACK-VALUECHAINSTACK
      - DDR-TRACK-VALUECHAINCONCERN
      - FDR-CD
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Text.RegularExpressions;

namespace Catzc.Base.Drs;

public sealed class DrsConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static readonly Regex CodeRe = new Regex("^[A-Z]{2,4}(-[A-Z]{2,4})?$", RegexOptions.Compiled);
    private static readonly Regex KindRe = new Regex("^[A-Z]{2,4}$", RegexOptions.Compiled);

    public const string DefaultKind = "ADR";

    // The segments a rule's code has after its kind when no ruleset of the kind is registered: ADR-<DOMAIN>-<ADR>-<NAME>, TDR-<ADR>-<NAME>.
    public const int DefaultSharedRuleSegments = 3;
    public const int DefaultOwnedRuleSegments = 2;

    // The rows of the value-chain stack, top to bottom ([DDR-TRACK-VALUECHAINSTACK](/docs/drs/design/tracks.md#rule-ddr-track-valuechainstack)).
    public static readonly IReadOnlyList<string> Stacks = Array.AsReadOnly(new[] { "PRIN", "DSGN", "AUTO", "PIPE", "CLOUD" });

    public static readonly IReadOnlyList<string> Concerns = Array.AsReadOnly(new[] { "automation", "build", "quality-control", "release", "deploy", "access" });

    public IReadOnlyList<DrsDomain> Domains { get; }
    public IReadOnlyList<DrsRuleSet> RuleSets { get; }
    public IReadOnlyList<DrsDomainEdge> Edges { get; }

    // The registered record kinds in authored order, each code's first segment, and which of them several domains share.
    public IReadOnlyList<string> Kinds { get; }
    public IReadOnlyList<string> SharedKinds { get; }

    public DrsCodeForm CodeForm { get; }
    private readonly Dictionary<string, string> kindNames = new Dictionary<string, string>(StringComparer.Ordinal);

    // The long name of a registered kind (Thesis Decision Record), or null for one not registered.
    public string KindName(string kind) => kind != null && kindNames.TryGetValue(kind, out string name) ? name : null;

    private static readonly string[] AllowedKeys = { "root", "kinds", "domains" };

    // The repository-relative folder that holds every decision record when drs.yml names none.
    public const string DefaultRoot = "docs/drs";

    // The repository-relative folder that holds every decision record, '/'-separated, with no trailing '/'.
    public string Root { get; }
    private static readonly string[] AllowedKindKeys = { "name", "shared" };
    private static readonly string[] AllowedDomainKeys = { "kind", "code", "role", "description", "depends_on", "stack", "concern", "folder", "rulesets" };
    private static readonly Regex FolderRe = new Regex("^[A-Za-z0-9._-]+(/[A-Za-z0-9._-]+)*$", RegexOptions.Compiled);

    // The folder under docs/drs that holds a domain's ADRs when its entry names none: the domain's own name.
    public static string DefaultFolder(string domain) => domain;
    private static readonly string[] AllowedRuleSetKeys = { "external", "code", "concern", "layer" };

    // The five layers of the automation, and the one an ADR belongs to when its entry names none ([ADR-AUTO-LAYERS-REALISENEVERREDEFINE](/docs/drs/automation/layers.md#rule-adr-auto-layers-realiseneverredefine)).
    private static readonly string[] LayerNames = { "automation", "contract", "language", "engine", "importer" };
    public static readonly IReadOnlyList<string> Layers = LayerNames;
    public const string DefaultLayer = "automation";

    public DrsConfig(IDictionary raw)
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

        List<string> kinds = new List<string>();
        List<string> sharedKinds = new List<string>();
        IDictionary kindsMap = (raw != null && raw.Contains("kinds")) ? raw["kinds"] as IDictionary : null;
        if (kindsMap == null)
        {
            if (raw != null && raw.Contains("kinds")) { errors.Add("'kinds' must be a map of kind -> { name, shared }"); }
            kinds.Add(DefaultKind);
            sharedKinds.Add(DefaultKind);
            kindNames[DefaultKind] = "Architecture Decision Record";
        }
        else
        {
            foreach (object kk in kindsMap.Keys)
            {
                string kind = kk == null ? null : kk.ToString();
                IDictionary k = kindsMap[kk] as IDictionary;
                if (kind == null || !KindRe.IsMatch(kind)) { errors.Add(string.Format("kind '{0}' must be 2-4 uppercase letters", kind)); continue; }
                if (k == null) { errors.Add(string.Format("kind '{0}': must be a mapping", kind)); continue; }
                CheckKeys(k, AllowedKindKeys, string.Format("kind '{0}'", kind), errors);
                string kindName = k.Contains("name") && k["name"] != null ? k["name"].ToString().Trim() : null;
                if (string.IsNullOrWhiteSpace(kindName)) { errors.Add(string.Format("kind '{0}': missing 'name'", kind)); }
                kinds.Add(kind);
                kindNames[kind] = kindName;
                if (k.Contains("shared") && k["shared"] != null && string.Equals(k["shared"].ToString(), "true", StringComparison.OrdinalIgnoreCase))
                {
                    sharedKinds.Add(kind);
                }
            }
            if (kinds.Count == 0) { errors.Add("'kinds' must register one or more kinds"); }
        }
        Kinds = kinds.AsReadOnly();
        SharedKinds = sharedKinds.AsReadOnly();
        if (kinds.Count == 0) { throw new ArgumentException("drs.yml is invalid:\n  - " + string.Join("\n  - ", errors)); }
        // Until the rulesets are read, a rule's code has three segments after a shared kind and two after a kind one domain owns.
        OrderedDictionary defaultSegments = new OrderedDictionary();
        foreach (string kind in kinds) { defaultSegments[kind] = sharedKinds.Contains(kind) ? DefaultSharedRuleSegments : DefaultOwnedRuleSegments; }
        Regex externalRe = new Regex("^" + new DrsCodeForm(defaultSegments).Cited + "$", RegexOptions.Compiled);
        Dictionary<string, string> kindOwner = new Dictionary<string, string>(StringComparer.Ordinal);

        string root = (raw != null && raw.Contains("root") && raw["root"] != null) ? raw["root"].ToString() : DefaultRoot;
        if (!FolderRe.IsMatch(root) || Array.IndexOf(root.Split('/'), "..") >= 0 || Array.IndexOf(root.Split('/'), ".") >= 0)
        {
            errors.Add(string.Format("root '{0}' must be a '/'-separated repository-relative folder, with no '.' or '..' segment", root));
        }
        Root = root;

        IDictionary domainsMap = (raw != null && raw.Contains("domains")) ? raw["domains"] as IDictionary : null;
        if (domainsMap == null || domainsMap.Count == 0)
        {
            throw new ArgumentException("drs.yml requires a non-empty 'domains' map");
        }

        HashSet<string> domainNames = new HashSet<string>(StringComparer.Ordinal);
        foreach (object k in domainsMap.Keys)
        {
            string n = k == null ? null : k.ToString();
            if (!string.IsNullOrEmpty(n)) { domainNames.Add(n); }
        }

        List<DrsDomain> domains = new List<DrsDomain>();
        List<DrsRuleSet> allRuleSets = new List<DrsRuleSet>();
        Dictionary<string, string> seenExternals = new Dictionary<string, string>(StringComparer.Ordinal);
        Dictionary<string, List<string>> graph = new Dictionary<string, List<string>>(StringComparer.Ordinal);
        Dictionary<string, string> seenFolders = new Dictionary<string, string>(StringComparer.Ordinal);

        foreach (object dk in domainsMap.Keys)
        {
            string name = dk == null ? null : dk.ToString();
            IDictionary d = domainsMap[dk] as IDictionary;
            if (d == null) { errors.Add(string.Format("domain '{0}': must be a mapping", name)); continue; }

            CheckKeys(d, AllowedDomainKeys, string.Format("domain '{0}'", name), errors);

            string domainKind = d.Contains("kind") && d["kind"] != null ? d["kind"].ToString() : DefaultKind;
            bool shared = sharedKinds.Contains(domainKind);
            if (!kinds.Contains(domainKind))
            {
                errors.Add(string.Format("domain '{0}': kind '{1}' is not a registered kind (one of: {2})", name, domainKind, string.Join(", ", kinds)));
            }
            else if (!shared && kindOwner.ContainsKey(domainKind))
            {
                errors.Add(string.Format("domain '{0}': kind '{1}' is owned by domain '{2}' and is not shared", name, domainKind, kindOwner[domainKind]));
            }
            else if (!shared)
            {
                kindOwner[domainKind] = name;
            }
            string code = d.Contains("code") && d["code"] != null ? d["code"].ToString() : null;
            if (shared && (code == null || !CodeRe.IsMatch(code)))
            {
                errors.Add(string.Format("domain '{0}': code '{1}' must be 2-4 uppercase letters under the shared kind {2}", name, code, domainKind));
            }
            else if (!shared && code != null)
            {
                errors.Add(string.Format("domain '{0}': has code '{1}', but its kind {2} is its own and carries no domain segment", name, code, domainKind));
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

            string folder = d.Contains("folder") && d["folder"] != null ? d["folder"].ToString() : DefaultFolder(name);
            if (!FolderRe.IsMatch(folder) || Array.IndexOf(folder.Split('/'), "..") >= 0 || Array.IndexOf(folder.Split('/'), ".") >= 0)
            {
                errors.Add(string.Format("domain '{0}': folder '{1}' must be a '/'-separated path under the root, with no '.' or '..' segment", name, folder));
            }
            else if (seenFolders.ContainsKey(folder))
            {
                errors.Add(string.Format("domain '{0}': folder '{1}' is also the folder of domain '{2}'", name, folder, seenFolders[folder]));
            }
            else
            {
                seenFolders[folder] = name;
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

            List<DrsRuleSet> ruleSets = new List<DrsRuleSet>();
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
                    if (external == null || !externalRe.IsMatch(external))
                    {
                        errors.Add(string.Format("ruleset '{0}/{1}': external '{2}' must be a registered kind ({3}) and uppercase segments", name, slug, external, string.Join(", ", kinds)));
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

                    // Under a shared kind the segment after the kind is the effective code; under an owned kind the kind is the prefix.
                    string expectedPrefix = effective == null ? domainKind : domainKind + "-" + effective;
                    bool hasDomainSegment = effective == null || external.IndexOf('-', domainKind.Length + 1) >= 0;
                    bool domainSegmentMatches = external.StartsWith(domainKind + "-", StringComparison.Ordinal)
                        && (!hasDomainSegment
                            || string.Equals(external, expectedPrefix, StringComparison.Ordinal)
                            || external.StartsWith(expectedPrefix + "-", StringComparison.Ordinal));
                    if (!domainSegmentMatches)
                    {
                        errors.Add(string.Format("ruleset '{0}/{1}': external '{2}' does not start with its domain's prefix '{3}'", name, slug, external, expectedPrefix));
                    }

                    // The value-chain concerns: the ruleset's own list when it declares one, else the domain default.
                    IReadOnlyList<string> concerns = domainConcerns;
                    if (r.Contains("concern"))
                    {
                        concerns = r["concern"] == null
                            ? Fail(string.Format("ruleset '{0}/{1}': 'concern' must list one or more of: {2}", name, slug, string.Join(", ", Concerns)), errors)
                            : ParseConcerns(r["concern"], string.Format("ruleset '{0}/{1}'", name, slug), errors);
                    }

                    string layer = DefaultLayer;
                    if (r.Contains("layer"))
                    {
                        string named = r["layer"] == null ? null : r["layer"].ToString();
                        if (named == null || Array.IndexOf(LayerNames, named) < 0)
                        {
                            errors.Add(string.Format("ruleset '{0}/{1}': layer '{2}' is not one of: {3}", name, slug, named, string.Join(", ", Layers)));
                        }
                        else
                        {
                            layer = named;
                        }
                    }

                    DrsRuleSet one = new DrsRuleSet(name, role, slug, external, effective, code, stack, concerns, domainConcerns, layer, folder);
                    ruleSets.Add(one);
                    allRuleSets.Add(one);
                }
            }

            domains.Add(new DrsDomain(name, code, domainKind, role, description, deps, stack, domainConcerns, ruleSets, folder));
        }

        // Acyclic domain graph (depth-first cycle detection: 1 = on the current stack, 2 = fully explored).
        Dictionary<string, int> state = new Dictionary<string, int>(StringComparer.Ordinal);
        foreach (string n in domainNames)
        {
            DetectCycle(n, graph, state, errors);
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("drs.yml is invalid:\n  - " + string.Join("\n  - ", errors));
        }

        // The domain DAG as edges, one per depends_on link in declaration order — built only from validated domains.
        List<DrsDomainEdge> edges = new List<DrsDomainEdge>();
        foreach (DrsDomain domain in domains)
        {
            foreach (string target in domain.DependsOn)
            {
                edges.Add(new DrsDomainEdge(domain.Name, target));
            }
        }

        Domains = domains;
        RuleSets = allRuleSets;
        Edges = edges;

        // A kind's rule has one segment more than its shortest registered ADR code, so a group segment (RDR-DORA-<NAME>) is an ADR's.
        OrderedDictionary ruleSegments = new OrderedDictionary();
        foreach (string kind in kinds)
        {
            int shortest = int.MaxValue;
            foreach (DrsRuleSet ruleSet in allRuleSets)
            {
                if (ruleSet.Kind == kind) { shortest = Math.Min(shortest, ruleSet.External.Split('-').Length - 1); }
            }
            ruleSegments[kind] = shortest == int.MaxValue ? defaultSegments[kind] : shortest + 1;
        }
        CodeForm = new DrsCodeForm(ruleSegments);
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
