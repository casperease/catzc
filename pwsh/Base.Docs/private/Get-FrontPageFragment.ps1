function Get-FrontPageFragment {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Source,

        [Parameter(Mandatory)]
        [string] $Folder
    )

    $sourcePath = Resolve-RepoPath $Source
    Assert-PathExist $sourcePath -PathType Leaf
    $text = Remove-MarkdownFrontMatter -Text ([System.IO.File]::ReadAllText($sourcePath) -replace "`r", '')
    $lines = @($text.Trim("`n") -split "`n")
    Assert-True ($lines[0] -match '^# (?<title>.+)$') -ErrorText "Get-FrontPageFragment: '$Source' must open with its '# ' title, which becomes the section heading."
    $title = $Matches['title'].Trim()

    # The page owns the one '#' title, so every heading of the article moves down one level; a fence's '#' comment never does.
    $inFence = $false
    $body = foreach ($line in ($lines | Select-Object -Skip 1)) {
        if ($line -match '^\s*(```|~~~)') {
            $inFence = -not $inFence
        }
        if (-not $inFence -and $line -match '^#{1,5} ') {
            "#$line"
        }
        else {
            $line
        }
    }

    $rebased = [Catzc.Base.MarkdownMeta.MarkdownLinkRebaser]::Rebase((@($body) -join "`n").Trim("`n"), $Source, $Folder)
    [pscustomobject]@{ Title = $title; Body = $rebased }
}
