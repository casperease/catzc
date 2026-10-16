---
catzc:
  immutable:
    with_body_sha: "8f95e1f08ea2"
    repo_status: locked
    path: docs/references/infrastructure/templates/expedition/configuration/test.yml.md
    folder: docs/references/infrastructure/templates/expedition/configuration
    name: test-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# infrastructure/templates/expedition/configuration/test.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `ParametersFile:`, written with `#`.

```text
expedition, shared test (configuration root, shared_nonprod subscription): in the nonprod hub's shared-services
subnet, registered in the same hub's private DNS zones. Nonprod class: a serverless database that pauses when
idle.
```
