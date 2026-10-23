---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
      - ADR-REPO-FILEMETA-HEADPOLICY
---

# Generation is idempotent and writes only on a real change under the head policy (ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION + ADR-REPO-FILEMETA-HEADPOLICY)

This article is one rule:
[ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION](../../drs/repository/generated-root-configs.md#rule-adr-repo-rootcfg-idempotentgeneration) and
[ADR-REPO-FILEMETA-HEADPOLICY](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-headpolicy) merged into one. It holds nothing beyond
what those two rules say.

Generation is idempotent and runs on every import. All content writes go through the one shared primitive `Write-FileIfChanged`: canonical
output (UTF-8 no BOM, LF, one trailing newline), an EOL-insensitive compare, and a write only on a real content change, so a clean tree is a
fast no-op. Every file generated this way is format-managed, and a `Format-*` command decides its head policy, whether it carries one meta
block and which.
