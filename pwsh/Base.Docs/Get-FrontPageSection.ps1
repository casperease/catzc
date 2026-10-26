function Get-FrontPageSection {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config frontpage).sections.id })]
        [string] $Id,

        [Catzc.Base.Docs.FrontPageConfig] $Config = (Get-Config -Config frontpage)
    )

    if ($Id) {
        Assert-NotNull $Config.Section($Id) -ErrorText "frontpage.yml declares no section '$Id'."
    }

    $folder = ([System.IO.Path]::GetDirectoryName($Config.target)) -replace '\\', '/'

    # A fragment's title lives in its article, so every title is read before the contents list can name them.
    $fragments = @{}
    foreach ($section in $Config.sections) {
        if ($section.kind -eq 'fragment') {
            $fragments[$section.id] = Get-FrontPageFragment -Source $section.source -Folder $folder
        }
    }
    $titles = [ordered]@{}
    foreach ($section in $Config.sections) {
        $titles[$section.id] = if ($fragments.ContainsKey($section.id)) {
            $fragments[$section.id].Title
        }
        else {
            $section.title
        }
    }

    foreach ($section in $Config.sections) {
        if ($Id -and $section.id -cne $Id) {
            continue
        }
        $body = switch ($section.kind) {
            'fragment' {
                $fragments[$section.id].Body
            }
            'records' {
                Format-FrontPageRecords -Section $section -Folder $folder
            }
            'contents' {
                $entries = foreach ($other in $Config.sections) {
                    if ($other.id -cne $section.id) {
                        "- [$($titles[$other.id])](#$([Catzc.Base.Docs.GitHubAnchor]::Slug($titles[$other.id])))"
                    }
                }
                @($entries) -join "`n"
            }
        }
        [pscustomobject]@{
            Id       = $section.id
            Title    = $titles[$section.id]
            Anchor   = [Catzc.Base.Docs.GitHubAnchor]::Slug($titles[$section.id])
            Markdown = "## $($titles[$section.id])`n`n$body"
        }
    }
}
