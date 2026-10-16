---
catzc:
  immutable:
    with_body_sha: "0f2f92a434c5"
    path: docs/references/pipelines/cd-shared.yaml.md
    folder: docs/references/pipelines
    name: cd-shared-yaml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AZ-LZ#7
---

# pipelines/cd-shared.yaml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `trigger:`, written with `#`.

```text
Stage order is the safety property: foundation owns the Key Vault the others use, and expedition lands in discovery's network.
[ADR-FLOW-CD-TYPE](/docs/adr/flow/pipeline-types.md), [ADR-AZ-LZ#7](/docs/adr/azure/landing-zones.md#rule-adr-az-lz7),
[ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md) [comment:1](/docs/references/pipelines/cd-shared.yaml.md#comment1)
```

## comment:2

Above `trigger:`, written with `#`.

```text
Root ymls and customer subfolders sit at one folder depth, so ADO may drop a root yml; Test-GlobSetAffected is the exact backstop.
[ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md) [comment:2](/docs/references/pipelines/cd-shared.yaml.md#comment2)
```

## comment:3

Above `- template: /pipelines/steps/invoke-automation.yaml`, written with `#`.

```text
Build-Bicep writes each template to out/template/<name>; publish that as the artifact the
deploy stages consume. -Shared scopes the build to the configuration-root (shared platform)
slots — customer subfolders are built by their own customer CD.
```
