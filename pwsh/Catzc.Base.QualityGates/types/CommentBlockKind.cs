/*
---
catzc:
  immutable:
    with_body_sha: "3883a06f7ef6"
  edges:
    cites:
      - PDR-ONELIVE-ONEVERSION
---
*/

// A run of line comments, or one delimited block; both move to the page the same way.

namespace Catzc.Base.QualityGates;

// Rests on [PDR-ONELIVE-ONEVERSION](/docs/adr/principles/one-living-version.md#rule-pdr-onelive-oneversion).
public enum CommentBlockKind
{
    LineRun,
    Block,
}
