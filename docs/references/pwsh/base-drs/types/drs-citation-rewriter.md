# pwsh/Base.Drs/types/DrsCitationRewriter.cs

Rewrites the ADR references in one file's text through a code map and a rule map. `Update-DrsCitation` reads the files and the maps. This
type does the rewriting.

## What it rewrites

- ADR and rule codes, in a citation or a `### Rule` heading alike;
- rule anchors, `rule-adr-<code>-<name>`;
- markdown and code link destinations into `docs/drs/`;
- plain path mentions of a moved ADR file or folder.

The rule map decides first: a rule that moves, collapses into another rule, or is renamed. Then the code map decides: a moved ADR code
carries every code below it, each keeping the rest of its segments. A numbered citation or group names no rule and is reported `Unhandled`.

## Links

A link that carries a rule anchor follows the rule, possibly to another file. Any other link follows the file. A relative link is resolved
at the file's own folder and written back relative to it, so it stays correct at any depth
([ADR-REPO-LINK-MARKDOWNRELATIVE](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-markdownrelative)). An in-file anchor of a
page that is not the rule's ADR, such as a generated list with its own anchors, stays in-file.

## Matching

Matching is exact, with a token boundary on both sides, and runs everywhere in the text, fenced code blocks included. The type is pure:
paths are repository-relative and `/`-separated, so the result depends only on the text, the file's path and the maps.

## Constructor

- `codeRows` — one dictionary per code-map row (`old_code`, `new_code`, `old_path`, `new_path`, `kind`; `-` for none), paths relative to the
  root. A root row's two paths are repository-relative.
- `ruleRows` — one dictionary per rule-map row (`old_rule`, `new_rule`, `kind`), each a rule's code.
- `citations` — the ADR index (`Get-DrsCitationMap`), which supplies the path of a rule's new code when the code map does not name it. It is
  null when the code map names every path.
- `treeFiles` — the repository-relative paths of the files under `docs/drs` in the tree, before or after a folder moves.
- `kinds` — the record kinds the registry declares (`DrsConfig.Kinds`), old and new codes alike.

## Code grammar

The code grammar is built over the registered record kinds, the markers of a code
([ADR-REPO-DRSCODE-PATHOFSEGMENTS](../../../../drs/repository/drs-code-language.md#rule-adr-repo-drscode-pathofsegments)). A new code may be
a bare kind: the code of a domain that only frames becomes its kind
([ADR-REPO-DRSCODE-DOMAINSEGMENT](../../../../drs/repository/drs-code-language.md#rule-adr-repo-drscode-domainsegment)).

## Path references

A path reference is a path part, then `#` and the fragment when one is given. It is mapped and written back in its own form. It stays as
written when it does not point into `docs/drs/` or nothing changes. After the maps, a rule anchor follows its rule, to the file of the
rule's new ADR when its ADR changes. Otherwise the path follows the file and folder map.
