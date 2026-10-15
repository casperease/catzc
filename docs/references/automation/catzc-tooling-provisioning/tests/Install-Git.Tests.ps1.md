---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/tests/Install-Git.Tests.ps1.md
    kind: test-asset
    body_sha: "4402b0fb67d3"
---

# automation/Catzc.Tooling.Provisioning/tests/Install-Git.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeEach {`.

```text
Install-Git is mostly a live-download integration (GitHub API + verified download + self-extracting
installer); per fail-fast-with-asserts that path earns its confidence from an L2/manual run, not from
mocking every step. These L0 tests cover the hermetic, high-value decisions: the idempotent skip and
the platform delegation. Every external boundary is mocked so nothing downloads, extracts, or launches.
```
