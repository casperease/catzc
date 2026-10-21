/*
---
catzc:
  immutable:
    with_body_sha: "5610b60862c9"
  edges:
    cites:
      - PDR-ONELIVE-ONEVERSION
---
*/

// A run of line comments, or one delimited block; both move to the page the same way.

namespace Catzc.Base.QualityGates;

// Rests on [PDR-ONELIVE-ONEVERSION](/docs/drs/principles/one-living-version.md#rule-pdr-onelive-oneversion).
public enum CommentBlockKind
{
    LineRun,
    Block,
}
