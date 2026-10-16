<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.MarkdownMeta/Get-MarkdownMetaState.ps1
    name: get-markdown-meta-state
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.MarkdownMeta
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.MarkdownMeta/tests/Get-MarkdownMetaState.Tests.ps1
    cites:
      - ADR-REPO-FILEMETA#{1,3}
  config:
    synopsis: Reads what a Markdown text says about its own meta block, without changing it.
    description: |-
      Pure: it takes the text, reads no file and no config. The body is what follows the front matter, and its hash drops the
      blank line that separates written front matter from it, so imprinting never changes the hash it records
      ([ADR-REPO-FILEMETA#3](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta3)).
    parameters:
      Text: The whole Markdown file as text.
      Key: 'The front-matter key path of the block: catzc at the top level (the default), or a dotted path such as metadata.catzc where the carrier nests it under another tool''s keys.'
    outputs: |-
      [pscustomobject] @{ HasFrontMatter; HasMetaBlock; CanHoldMetaBlock; Body; BodyHash; Sections; ImmutableKeys; EdgeKeys; ConfigLines } —
      CanHoldMetaBlock is false when a key above the block holds a flow or scalar value, Sections are the keys directly under `catzc`,
      ImmutableKeys the keys under `immutable`, EdgeKeys the edge names under `edges`, and ConfigLines the authored lines under `config`, as
      written.
    examples:
      - (Get-MarkdownMetaState -Text $text).BodyHash
---
#>

function Get-MarkdownMetaState {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Text,

        [ValidateNotNullOrEmpty()]
        [string] $Key = [Catzc.Base.MarkdownMeta.MarkdownDocument]::MetaKey
    )

    $document = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($Text, $Key)
    $block = $document.MetaBlock
    [pscustomobject]@{
        HasFrontMatter   = $document.HasFrontMatter
        HasMetaBlock     = $document.HasMetaBlock
        CanHoldMetaBlock = $document.CanHoldMetaBlock
        Body             = $document.Body
        BodyHash         = $document.BodyHash()
        Sections         = [string[]] @([Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::SectionKeys($block))
        ImmutableKeys    = [string[]] @([Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::ImmutableKeys($block))
        EdgeKeys         = [string[]] @([Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::EdgeKeys($block))
        ConfigLines      = [string[]] @([Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::ConfigLines($block))
    }
}
