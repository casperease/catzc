/*
---
catzc:
  immutable:
    with_body_sha: f7ed723118f2
  edges:
    cites:
      - ADR-PRIN-ONELIVE-ONEVERSION
---
*/

// A run of line comments, or one delimited block; both move to the page the same way.

namespace Catzc.Base.QualityGates;

// Rests on [ADR-PRIN-ONELIVE-ONEVERSION](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive-oneversion).
public enum CommentBlockKind
{
    LineRun,
    Block,
}
