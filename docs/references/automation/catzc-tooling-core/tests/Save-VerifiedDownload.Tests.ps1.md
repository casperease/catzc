---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/tests/Save-VerifiedDownload.Tests.ps1.md
    kind: test-asset
    body_sha: "361851503e4d"
---

# automation/Catzc.Tooling.Core/tests/Save-VerifiedDownload.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `It 'returns the path when the SHA-256 matches (tolerates a sha256: prefix)' {`.

```text
SHA-256('abc') = ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad (NIST test vector).
The mocked download writes exactly the 3 bytes 'abc' (utf8NoBOM, no newline).
```
