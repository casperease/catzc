---
catzc:
  immutable:
    with_body_sha: "4a4314849a9c"
    path: docs/references/automation/catzc-tooling-provisioning/tests/Install-Git.Tests.ps1.md
    folder: docs/references/automation/catzc-tooling-provisioning/tests
    name: install-git-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Tooling.Provisioning/tests/Install-Git.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeEach {`, written with `#`.

```text
Install-Git is mostly a live-download integration (GitHub API + verified download + self-extracting
installer); per fail-fast-with-asserts that path earns its confidence from an L2/manual run, not from
mocking every step. These L0 tests cover the hermetic, high-value decisions: the idempotent skip and
the platform delegation. Every external boundary is mocked so nothing downloads, extracts, or launches.
```
