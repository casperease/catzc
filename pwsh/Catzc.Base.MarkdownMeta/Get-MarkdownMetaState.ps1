<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-markdown-meta/Get-MarkdownMetaState.ps1.md"
  header: "generated"
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
