/*
---
catzc:
  immutable:
    with_body_sha: "2ce041575a6d"
  edges:
    cites:
      - FDR-CD-RUNGSREGISTRY
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.Flow;

// One rung of the promotion ladder ([FDR-CD-RUNGSREGISTRY](/docs/adr/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-rungsregistry)).
public sealed class Rung
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The rung's name, its key in the `rungs` map (e.g. release-uat); a unit's ADO environment for the rung is `<unit>-<name>`.
    public string name { get; }

    // The configuration environment the rung deploys (e.g. test): the `<env>` of a template's configuration slot.
    public string environment { get; }

    // The gate a commit clears to enter the rung: none, rc, rbc or prod-approval.
    public string gate { get; }

    // The ADR rule codes that define the rung: a file that cites one of them, or the ADR that holds it, concerns the rung.
    public IReadOnlyList<string> rules { get; }

    public Rung(string name, string environment, string gate, string[] rules = null)
    {
        this.name = name;
        this.environment = environment;
        this.gate = gate;
        this.rules = Array.AsReadOnly(rules ?? Array.Empty<string>());
    }
}
