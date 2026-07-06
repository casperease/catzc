// One zone of the gitignore registry (configs/gitignore.yml) — a titled, explained group of ignore
// patterns. A zone declares EITHER `patterns` (a static list, each a bare string or { pattern, note }) OR
// `inject: <provider>` (the patterns are supplied at render time by the caller — e.g. the root-config
// registry's committed:false targets), never both. `title` and `why` render as the zone's comment block, so
// every rule in the generated .gitignore carries its explanation.
//
// Derives from Catzc.Base.Objects.DictionaryRecord, so an instance also presents as a read-only dictionary
// over its own properties and its constructor uses the base's extraction helpers.

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Git;

public sealed class GitIgnoreZone : Catzc.Base.Objects.DictionaryRecord
{
    // Short kebab identifier — unique across the registry. Required.
    public string id { get; }

    // The zone's heading, rendered as its comment rule-line. Required.
    public string title { get; }

    // The explanation rendered (wrapped) under the heading — why these paths are ignored. Required.
    public string why { get; }

    // Static patterns, in registry order. Exactly one of patterns/inject.
    public IReadOnlyList<GitIgnorePattern> patterns { get; }

    // Name of the render-time pattern provider (e.g. 'rootconfig-committed-false'). Exactly one of
    // patterns/inject.
    public string inject { get; }

    public GitIgnoreZone(IDictionary d)
    {
        if (d == null) { throw new ArgumentException("GitIgnoreZone requires a mapping"); }
        id = Req(d, "id");
        title = Req(d, "title");
        why = Req(d, "why");
        inject = OptStr(d, "inject");
        patterns = ParsePatterns(d);

        bool hasPatterns = patterns.Count > 0;
        if (hasPatterns == (inject != null))
        {
            throw new ArgumentException(string.Format(
                "gitignore zone '{0}' must declare exactly one of 'patterns' or 'inject'", id));
        }
    }

    private static IReadOnlyList<GitIgnorePattern> ParsePatterns(IDictionary d)
    {
        List<GitIgnorePattern> list = new List<GitIgnorePattern>();
        object obj = d.Contains("patterns") ? d["patterns"] : null;
        if (obj == null) { return list; }

        IEnumerable seq = obj as IEnumerable;
        if (seq == null || obj is string)
        {
            throw new ArgumentException("'patterns' must be a list of pattern entries");
        }
        foreach (object item in seq)
        {
            IDictionary entry = item as IDictionary;
            list.Add(entry != null ? new GitIgnorePattern(entry) : new GitIgnorePattern(item as string));
        }
        return list;
    }
}
