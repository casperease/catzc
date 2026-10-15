/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/types/ValueChainReason.cs
    kind: csharp-type
    module: Catzc.Base.Maps
    relatives:
      page: docs/references/automation/catzc-base-maps/types/ValueChainReason.cs.md
    adrs:
      - ADR-AUTO-TYPES#8
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.Maps;

[Catzc.Base.Objects.ConsoleDisplay(nameof(Adr), nameof(Stack), nameof(Concern), nameof(Override))]
public sealed class ValueChainReason
{
    // The requested citation that lights the cell (ADR-<CODE> or ADR-<CODE>#n).
    public string Requested { get; }

    // The ADR code (ADR-<CODE>).
    public string Adr { get; }

    // The ADR domain the ADR belongs to.
    public string Domain { get; }

    // The row: the ADR domain's row of the value-chain stack.
    public string Stack { get; }

    // The column: the value-chain concern of the lit cell.
    public string Concern { get; }

    // Every value-chain concern of the ADR (its override, or its ADR domain's default).
    public IReadOnlyList<string> Concerns { get; }

    // The ADR domain's default value-chain concerns.
    public IReadOnlyList<string> DomainConcerns { get; }

    // True when the ADR declares its own value-chain concerns, not its ADR domain's default.
    public bool Override
    {
        get
        {
            if (Concerns.Count != DomainConcerns.Count) { return true; }
            for (int i = 0; i < Concerns.Count; i++)
            {
                if (!string.Equals(Concerns[i], DomainConcerns[i], StringComparison.Ordinal)) { return true; }
            }
            return false;
        }
    }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public ValueChainReason(string requested, string adr, string domain, string stack, string concern, IReadOnlyList<string> concerns,
        IReadOnlyList<string> domainConcerns)
    {
        Requested = requested;
        Adr = adr;
        Domain = domain;
        Stack = stack;
        Concern = concern;
        Concerns = concerns == null ? Array.Empty<string>() : new List<string>(concerns).ToArray();
        DomainConcerns = domainConcerns == null ? Array.Empty<string>() : new List<string>(domainConcerns).ToArray();
    }
}
