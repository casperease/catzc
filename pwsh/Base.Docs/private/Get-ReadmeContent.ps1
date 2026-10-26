<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-docs/private/Get-ReadmeContent.ps1.md"
  header: "generated"
---
#>

function Get-ReadmeContent {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [object] $Mapping
    )

    $sourcePath = Resolve-RepoPath $Mapping.source
    Assert-PathExist $sourcePath -PathType Leaf
    # The copy carries the article, not the source's meta block, so it opens with its title as a reader expects.
    $text = Remove-MarkdownFrontMatter -Text ([System.IO.File]::ReadAllText($sourcePath) -replace "`r", '')
    # Rebased links run longer than the source's, so a line wrapped at the width can pass it here and is wrapped again.
    $body = Format-LongMarkdownLines -Text ([Catzc.Base.MarkdownMeta.MarkdownLinkRebaser]::Rebase($text,
            $Mapping.source, $Mapping.folder))

    # The head says not to edit the copy, so the body is the article alone.
    $readme = "$($Mapping.folder)/README.md"
    Format-GeneratedFileHead -Text $body -Path $readme
}
