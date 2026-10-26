function Get-DrsUsage {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string[]] $Path,

        [string[]] $Code,

        [ValidateSet('cites', 'link')]
        [string] $Source,

        [ValidateSet('Rule', 'Document')]
        [string] $GroupBy
    )

    $map = Get-DrsCitationMap -RepositoryRoot $RepositoryRoot
    $pages = Get-Config -Config comment-pages
    $drs = Get-Config -Config drs
    $scanner = [Catzc.Base.Drs.DrsCitationScanner]::new($drs.CodeForm, $map)
    $rows = foreach ($entry in Get-FileMetaScope -RepositoryRoot $RepositoryRoot -Path $Path) {
        $carrier = $entry.Carrier.carrier
        if ($carrier -eq [Catzc.Base.Languages.CarrierKind]::Property) {
            continue
        }
        $file = Join-Path $RepositoryRoot $entry.Path
        if (-not [System.IO.File]::Exists($file)) {
            continue
        }
        $text = [System.IO.File]::ReadAllText($file)
        $arguments = @{
            Text           = $text
            Path           = $entry.Path
            Map            = $map
            Pages          = $pages
            RepositoryRoot = $RepositoryRoot
            CodeForm       = $drs.CodeForm
            DomainClasses  = $drs.DomainClasses
            FileClass      = $entry.Class
            Scanner        = $scanner
        }
        if ($carrier -eq [Catzc.Base.Languages.CarrierKind]::CommentHead) {
            $arguments['Form'] = $entry.Carrier.Form()
        }
        foreach ($row in Get-DrsUsageRow @arguments) {
            if ($Code -and $row.Code -notin $Code) {
                continue
            }
            if ($Source -and $row.Source -ne $Source) {
                continue
            }
            $row
        }
    }

    if ($GroupBy) {
        Group-DrsUsage -Row @($rows) -By $GroupBy
        return
    }
    $rows
}
