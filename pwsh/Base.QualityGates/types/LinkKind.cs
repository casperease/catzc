/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/types/LinkKind.cs.md"
  header: "generated"
---
*/

using System;

namespace Catzc.Base.QualityGates;

// The file a link lives in fixes its kind: markdown in a rendered .md, code links elsewhere.
[Flags]
public enum LinkKind
{
    Code = 1,
    Markdown = 2,
    Both = Code | Markdown,
}
