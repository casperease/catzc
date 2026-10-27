# The `docs` key of a file's head: what it said, and why nothing replaces it

## What the key said

An authored code or config file carried one edge in its meta head, `docs`, the plain path from the file's own folder to its comment page:

```yaml
catzc:
  docs: "../../../docs/references/pwsh/catzc-widget/Get-Gadget.ps1.md"
  header: "generated"
```

The relative-edges file-meta kind wrote it: `file-meta.yml` declared one relation, `docs` to `{page}`, Get-RelativeEdgesFileMetaFact
resolved it through Get-RelativeEdgeCandidate and the comment-page map, and a file without a comment page carried no head at all. The
provided head contract (`contracts/catzc/0.1.0/pwsh.base.quality_gates/head.schema.json` and `head.sample.yml`) named it as the authored
head's one edge.

## Why it goes

No file links to its page any more (the user, 2026-10-26, plan-reference-normal-form): a page sits at a path derived from its source, so the
path is a fact anyone can compute, and a fact written into a head goes stale the moment either file moves. A head holds only what it alone
can carry, and a derivable path is not that.

## What replaces it

Nothing in the file. The page of a source is derived on demand (CommentPagesConfig.PageFor), the same way every other fact about a file is.
An authored file now carries no head; only a generated file does, with its `immutable` part.
