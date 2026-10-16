/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.Git/types/GitIgnoreSection.cs
    folder: types
    name: git-ignore-section
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.Git
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-git/types/GitIgnoreSection.cs.md
    test: automation/Catzc.Base.Git/tests/types/GitIgnoreSection.Tests.ps1
---
*/

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Git;

public sealed class GitIgnoreSection : Catzc.Base.Objects.DictionaryRecord
{
    // Short kebab identifier — unique across the registry. Required.
    public string id { get; }

    // The section's heading, rendered as its comment rule-line. Required.
    public string title { get; }

    // The explanation rendered (wrapped) under the heading — why these paths are ignored. Required.
    public string why { get; }

    // Static patterns, in registry order. Exactly one of patterns/inject.
    public IReadOnlyList<GitIgnorePattern> patterns { get; }

    public string inject { get; }

    public GitIgnoreSection(IDictionary d)
    {
        if (d == null) { throw new ArgumentException("GitIgnoreSection requires a mapping"); }
        id = Req(d, "id");
        title = Req(d, "title");
        why = Req(d, "why");
        inject = OptStr(d, "inject");
        patterns = ParsePatterns(d);

        bool hasPatterns = patterns.Count > 0;
        if (hasPatterns == (inject != null))
        {
            throw new ArgumentException(string.Format(
                "gitignore section '{0}' must declare exactly one of 'patterns' or 'inject'", id));
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
