/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/types/LinkDirectionEngine.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections.Generic;
using System.Linq;

namespace Catzc.Base.QualityGates;

public static class LinkDirectionEngine
{
    public static IReadOnlyList<LinkDirectionFinding> Judge(IEnumerable<LinkEdge> edges, IReadOnlyDictionary<string, LinkEndpoint> endpoints,
        LinkDirectionsConfig config)
    {
        if (endpoints == null) { throw new ArgumentNullException(nameof(endpoints)); }
        if (config == null) { throw new ArgumentNullException(nameof(config)); }
        var findings = new List<LinkDirectionFinding>();
        foreach (LinkEdge edge in edges ?? Array.Empty<LinkEdge>())
        {
            if (config.exempt.ContainsKey(edge.File)) { continue; }
            endpoints.TryGetValue(edge.File, out LinkEndpoint from);
            endpoints.TryGetValue(edge.Target, out LinkEndpoint to);
            if (from == null || to == null)
            {
                string missing = from == null ? edge.File : edge.Target;
                findings.Add(new LinkDirectionFinding(edge, from?.Class, to?.Class, 0, null, "has no endpoint for " + missing));
                continue;
            }

            int number = 0;
            LinkDirectionRow decided = null;
            foreach (LinkDirectionRow row in config.rows)
            {
                number++;
                // A require row judges missing edges below, never an edge that exists.
                if (row.verdict == LinkVerdict.Require) { continue; }
                if (row.Matches(edge.Relation, from, to))
                {
                    decided = row;
                    break;
                }
            }
            if (decided == null)
            {
                findings.Add(new LinkDirectionFinding(edge, from.Class, to.Class, 0, null, null));
            }
            else if (decided.verdict == LinkVerdict.Deny)
            {
                findings.Add(new LinkDirectionFinding(edge, from.Class, to.Class, number, decided.because, null));
            }
        }
        findings.AddRange(Missing(edges, endpoints, config));
        return findings;
    }

    // Each file a require row selects, its condition holding, that has no edge of the row's relations to the row's to side.
    static IEnumerable<LinkDirectionFinding> Missing(IEnumerable<LinkEdge> edges, IReadOnlyDictionary<string, LinkEndpoint> endpoints,
        LinkDirectionsConfig config)
    {
        var bySource = new Dictionary<string, List<LinkEdge>>(StringComparer.Ordinal);
        foreach (LinkEdge edge in edges ?? Array.Empty<LinkEdge>())
        {
            if (!bySource.TryGetValue(edge.File, out List<LinkEdge> list)) { bySource[edge.File] = list = new List<LinkEdge>(); }
            list.Add(edge);
        }
        var paths = new List<string>(endpoints.Keys);
        paths.Sort(StringComparer.Ordinal);
        int number = 0;
        foreach (LinkDirectionRow row in config.rows)
        {
            number++;
            if (row.verdict != LinkVerdict.Require) { continue; }
            foreach (string path in paths)
            {
                LinkEndpoint from = endpoints[path];
                if (config.exempt.ContainsKey(path) || !row.from.Matches(from)) { continue; }
                bySource.TryGetValue(path, out List<LinkEdge> own);
                own ??= new List<LinkEdge>();
                bool Reaches(IReadOnlyList<LinkRelation> relations) => own.Exists(e =>
                    relations.Contains(e.Relation) && endpoints.TryGetValue(e.Target, out LinkEndpoint to) && row.to.Matches(to));
                if (row.when.Count > 0 && !Reaches(row.when)) { continue; }
                if (!Reaches(row.relations))
                {
                    yield return new LinkDirectionFinding(path, row.relations[0], from.Class, "(required)", number, row.because);
                }
            }
        }
    }
}
