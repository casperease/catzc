/*
---
catzc:
  immutable:
    with_body_sha: "8c0d2f3c89c3"
  edges:
    docs: "[TruthStore.cs.md](../../../docs/references/pwsh/catzc-base-flow/types/TruthStore.cs.md)"
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.Flow;

public sealed class TruthStore
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The store's kebab-case name, unique in truth-stores.yml.
    public string name { get; }

    // One of TruthStoresConfig.Kinds.
    public string kind { get; }

    // The absolute URL a fact source or state machine answers at; null when the config names none.
    public string url { get; }

    // The state machine that owns the store; null for a repository or a state machine.
    public string owner { get; }

    // The adjacent stores a repository drives one way from the trunk's pipelines, by name; empty for any other kind.
    public IReadOnlyList<string> projections { get; }

    public TruthStore(string name, string kind, string url, string owner, string[] projections = null)
    {
        this.name = name;
        this.kind = kind;
        this.url = url;
        this.owner = owner;
        this.projections = Array.AsReadOnly(projections ?? Array.Empty<string>());
    }
}
