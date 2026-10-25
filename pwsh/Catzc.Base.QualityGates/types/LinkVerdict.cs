/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/types/LinkVerdict.cs.md"
  warning: "Generated Header"
---
*/

namespace Catzc.Base.QualityGates;

public enum LinkVerdict
{
    Allow,
    Deny,
    // The files the row's from side selects must each have an edge of its relations to its to side: a row about edges that are missing.
    Require,
}
