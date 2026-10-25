/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/types/LinkKind.cs.md"
  warning: "Generated Header"
---
*/

using System;

namespace Catzc.Base.QualityGates;

[Flags]
public enum LinkKind
{
    Code = 1,
    Markdown = 2,
    Both = Code | Markdown,
}
