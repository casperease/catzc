<#
---
catzc:
  immutable:
    with_body_sha: a283fb1945aa
  edges:
    docs: "[Get-ReadmeContent.ps1.md](docs/references/pwsh/catzc-base-docs/private/Get-ReadmeContent.ps1.md)"
    cites:
      - ADR-REPO-README-WORKINGLINKS
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
    # The rebased links are longer than the source's, so a line the source wrapped at the width can pass it here; wrap those blocks again.
    $body = Format-LongMarkdownLines -Text ([Catzc.Base.MarkdownMeta.MarkdownLinkRebaser]::Rebase($text, $Mapping.source, $Mapping.folder))

    # The head names the source to edit and says not to edit the copy, so the body is the article alone.
    $readme = "$($Mapping.folder)/README.md"
    Format-GeneratedFileHead -Text $body -Path $readme -Generator Build-Readme -Source $Mapping.source -FileKind (Get-FileKind $readme)
}
