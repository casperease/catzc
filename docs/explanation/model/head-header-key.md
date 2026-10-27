# The `header` key of a file's head: what it said, and why nothing replaces it

## What the key said

An authored file's head closed with a note that the head itself was written by a tool, after its edges:

```yaml
catzc:
  docs: "../../../docs/references/pwsh/catzc-widget/Get-Gadget.ps1.md"
  header: "generated"
```

Its text came from `file-meta.yml` (`header:`, read by FileMetaConfig), Invoke-FileMetaEngine passed it to the three head writers
(Format-CodeMetaHead, Format-PropertyMetaHead, Format-MarkdownMetaBlock) as `-HeaderText`, and MarkdownMetaBlock rendered and parsed it as a
part of its own. Only a head that showed a fact carried it; a generated file's head never did.

## Why it goes

It was written only into authored heads, and authored files carry no head once the `docs` edge goes ([head-docs-key](head-docs-key.md), the
user, 2026-10-26). A note that a head is generated, on no head, says nothing; heads stay only where they carry something.

## What replaces it

Nothing. A generated file's head says what it is through its `immutable` part (`warning`, and `with_body_sha` while git tracks it), and the
head contract describes that one shape.
