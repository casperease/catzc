---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/configs/bash.yml.md
    kind: comment-page
    body_sha: "23bd7da22658"
    adrs: []
    links: []
---

# automation/Catzc.Base.Languages/configs/bash.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `bats_version: "1.14.0"`.

```text
The Bash tests — black-box tests of the engine written in Bash, under <root>/tests/<module-in-kebab>/*.bats, run by the
bats-core runner vendored at <root>/.vendor/bats-core/
([ADR-AUTO-BASH](/docs/adr/automation/bash/bash-test-artifacts.md)). Loaded via Get-Config -Config bash; the shape is
validated by Catzc.Base.Languages.BashConfig.
```

## comment:2

Above `bats_version: "1.14.0"`.

```text
root — the Bash root folder, repository-relative. Not declared here, so it takes the default every test language's root
takes: 'bash' when the repository has a bash/ folder (a Bash root track), else '.bash', the dot-prefixed tooling folder.
```

## comment:3

Above `bats_version: "1.14.0"`.

```text
The vendored bats-core release and the SHA-256 of its source archive (github.com/bats-core/bats-core, tag v<version>):
the vendored copy is reproducible from them with Update-BatsVendor.
```
