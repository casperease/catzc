---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-README-IDEMPOTENTGENERATION
      - ADR-REPO-FILEMETA-COMPOSEDFILES
---

# A readme is generated idempotently and a composed file carries the generated head

This article is one rule:
[ADR-REPO-README-IDEMPOTENTGENERATION](../../drs/repository/generated-readmes.md#rule-adr-repo-readme-idempotentgeneration) and
[ADR-REPO-FILEMETA-COMPOSEDFILES](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-composedfiles) merged into one. It holds nothing
beyond what those two rules say.

Generation is idempotent and runs on every import: `Build-Readme` composes each README and writes it through `Write-FileIfChanged`, which
rewrites only a README whose content differs and writes by delete-then-write, so a README that is a filesystem link is severed. A file the
automation composes whole carries the generated-file head instead of an imprinted block.
