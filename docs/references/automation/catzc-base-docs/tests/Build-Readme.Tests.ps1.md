---
catzc:
  immutable:
    with_body_sha: "40032377cc9d"
    path: docs/references/automation/catzc-base-docs/tests/Build-Readme.Tests.ps1.md
    folder: docs/references/automation/catzc-base-docs/tests
    name: build-readme-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PWSH-PESTER#2
---

# automation/Catzc.Base.Docs/tests/Build-Readme.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$sourceText = @(`, written with `#`.

```text
Isolate through the seams
([ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2)): mock the
config seam (Get-Config) and redirect the repository
root to a fixture tree (TestKit) so Resolve-RepoPath binds inside it.
```

## comment:2

Above `Mock Assert-SourceTree -ModuleName Catzc.Base.Docs { }`, written with `#`.

```text
The fixture repository root is not the loaded code root, which the run-mode guard reads as a built
package — the guard is its own seam, asserted separately below.
```

## comment:3

Above `Describe 'Build-Readme — real readme.yml' -Tag 'L2', 'integrity',...`, written with `#`.

```text
Reads only the repository's readme.yml, folders, and .gitignore — the same answer in both run modes, so the
build run skips it.
```

## comment:4

Above `BeforeAll {` (occurrence 2), written with `#`.

```text
The real readme.yml registry is consistent with the repository — every resolved README's source exists
(Get-ReadmeContent asserts it), every automation module is covered by the pattern, and the generated/committed
split matches .gitignore (every mapped README is ignored; none is opted back in). Resolves through the
public generator (Build-Readme -DryRun -PassThru) since the pattern expansion (Get-ReadmeMappings) is
private. Closes the poka-yoke gap of the two-place "generated vs committed" convention (readme.yml <->
.gitignore).
```

## comment:5

Above `$violations = foreach ($module in $modules) {`, written with `#`.

```text
One Should over the violating set — a Should per module pays Pester's per-assertion cost
times the whole automation tree.
```
