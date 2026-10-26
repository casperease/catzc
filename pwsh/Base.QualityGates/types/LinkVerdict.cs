/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/types/LinkVerdict.cs.md"
  header: "generated"
---
*/

namespace Catzc.Base.QualityGates;

// What a direction row says of the relations it matches.
public enum LinkVerdict
{
    Allow,
    Deny,
    // The files the row's from side selects must each have an edge of its relations to its to side: a row about edges that are missing.
    Require,
}
