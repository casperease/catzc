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
