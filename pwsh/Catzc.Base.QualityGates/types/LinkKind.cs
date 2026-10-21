/*
---
catzc:
  immutable:
    with_body_sha: "767588a2e560"
  edges:
    docs: "[LinkKind.cs.md](docs/references/pwsh/catzc-base-qualitygates/types/LinkKind.cs.md)"
    cites:
      - ADR-REPO-LINK-KINDBYFILE
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
