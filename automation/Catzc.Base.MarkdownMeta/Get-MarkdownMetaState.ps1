# catzc:
#   path: automation/Catzc.Base.MarkdownMeta/Get-MarkdownMetaState.ps1
#   module: Catzc.Base.MarkdownMeta
#   visibility: public

<#
.SYNOPSIS
    Reads what a Markdown text says about its own meta block, without changing it
    ([ADR-REPO-FILEMETA#1](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta1)).
.DESCRIPTION
    Pure: it takes the text, reads no file and no config.
    [ADR-REPO-FILEMETA#3](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta3)
    [comment:1](/docs/references/automation/catzc-base-markdownmeta/Get-MarkdownMetaState.ps1.md#comment1)
.PARAMETER Text
    The whole Markdown file as text.
.OUTPUTS
    [pscustomobject] @{ HasFrontMatter; HasMetaBlock; Body; BodyHash; Sections; DerivedKeys; ConfigLines } — Sections are the keys
    directly under `catzc`, DerivedKeys the keys under `derived`, and ConfigLines the authored lines under `config`, as written.
.EXAMPLE
    (Get-MarkdownMetaState -Text $text).BodyHash
#>
function Get-MarkdownMetaState {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Text
    )

    $document = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($Text)
    $block = $document.MetaBlock
    [pscustomobject]@{
        HasFrontMatter = $document.HasFrontMatter
        HasMetaBlock   = $document.HasMetaBlock
        Body           = $document.Body
        BodyHash       = $document.BodyHash()
        Sections       = [string[]] @([Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::SectionKeys($block))
        DerivedKeys    = [string[]] @([Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::DerivedKeys($block))
        ConfigLines    = [string[]] @([Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::ConfigLines($block))
    }
}
