/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/IdentityTokensConfig.cs
    kind: csharp-type
    module: Catzc.Base.QualityGates
---
*/

// Only shape is checked at load; that a rule's config belongs to the declaring module is checked later, where both are known.
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/IdentityTokensConfig.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.QualityGates;

public sealed class IdentityTokensConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The source's rules, in source order.
    public IReadOnlyList<IdentityTokenRule> tokens { get; }

    public IdentityTokensConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException("identity-tokens config validation failed:\nthe source must be a mapping"); }

        foreach (object key in raw.Keys)
        {
            string name = key == null ? string.Empty : key.ToString();
            if (name != "tokens") { errors.Add(string.Format("unknown top-level key '{0}' (allowed: tokens)", name)); }
        }

        List<IdentityTokenRule> rules = new List<IdentityTokenRule>();
        IList list = raw.Contains("tokens") ? raw["tokens"] as IList : null;
        if (list == null || list.Count == 0)
        {
            errors.Add("the source requires a non-empty 'tokens' list");
        }
        else
        {
            for (int position = 0; position < list.Count; position++)
            {
                try { rules.Add(new IdentityTokenRule(position, list[position] as IDictionary)); }
                catch (ArgumentException ex) { errors.Add(ex.Message); }
            }
        }
        tokens = rules;

        if (errors.Count > 0)
        {
            throw new ArgumentException("identity-tokens config validation failed:\n" + string.Join("\n", errors));
        }
    }
}
