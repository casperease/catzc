---
name: listen-tiers
description:
  The tiers and doc types of the listen mode and the one search over its committed reference; for listen-very-carefully-to-doc-changes and
  doc-pattern-scout; input is a pattern and a tier or folder slice.
user-invocable: false
allowed-tools: Bash, Read
metadata:
  catzc:
    config:
      model_floor: haiku
      needs: [pwsh]
---

# listen-tiers

1. A doc type is a file kind (`Get-FileKind`, file-kinds.yml); its tier is listen.yml's: `rule` (adr, glossary, index), `docs` (the other
   docs kinds), and `code`, the rest. Siblings are files of the same kind.
2. Search only with `Find-DocPattern <regex> -Tier <name> -Path <slice>`: it reads the session's reference/, the repository at the pinned
   commit, committed files only; never Grep or Glob the live tree.
3. Search top-down: `rule` first, then `docs`, then `code`; a match states its path, line and tier at that commit.
