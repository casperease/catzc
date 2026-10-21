/*
---
catzc:
  immutable:
    with_body_sha: "57bb9c96a3c0"
  edges:
    docs: "[HeadAnchor.cs.md](docs/references/pwsh/catzc-base-code-meta/types/HeadAnchor.cs.md)"
    cites:
      - ADR-REPO-CODEMETA-CODEFILEHEAD
---
*/

namespace Catzc.Base.CodeMeta;

public enum HeadAnchor
{
    Start,
    AfterShebang,
    AfterProlog,
    AfterPreamble,
}
