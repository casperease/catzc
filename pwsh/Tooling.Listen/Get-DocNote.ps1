function Get-DocNote {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $Session,

        [switch] $Unprocessed,

        [ValidateSet('editor', 'agent', 'unknown')]
        [string[]] $Source
    )

    $Session = Resolve-ListenSession $Session
    $notes = Join-Path $Session 'notes'
    if (-not [System.IO.Directory]::Exists($notes)) {
        return
    }

    $processed = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $ledger = Join-Path $Session 'processed.md'
    if ([System.IO.File]::Exists($ledger)) {
        foreach ($line in [System.IO.File]::ReadAllLines($ledger)) {
            if ($line -match '^- (\d{4}) \|') {
                [void] $processed.Add($Matches[1])
            }
        }
    }

    $files = [Catzc.Base.Folders.PathSet]::new((Get-Config -Config folder-walk)).AddPattern($notes, '*.md', 1).ToArray()
    foreach ($file in $files) {
        $head = @{}
        $lines = [System.IO.File]::ReadAllLines($file)
        for ($i = 1; $i -lt $lines.Count -and $lines[$i] -ne '---'; $i++) {
            if ($lines[$i] -match '^([a-z_]+): ?(.*)$') {
                $head[$Matches[1]] = $Matches[2].Trim('"')
            }
        }
        $id = $head['note']
        if (($Unprocessed -and $processed.Contains($id)) -or ($Source -and $head['source'] -cnotin $Source)) {
            continue
        }
        $rules = $head['rules'].Trim('[', ']')
        [pscustomobject]@{
            Id        = $id
            File      = $head['path']
            Change    = $head['change']
            From      = $head['from']
            Kind      = $head['kind']
            Tier      = $head['tier']
            Source    = $head['source']
            Agent     = $head['agent']
            Rules     = [string[]] @(if ($rules) {
                    $rules -split ', '
                })
            Commit    = $head['commit']
            Note      = $file
            Session   = $Session
            Processed = $processed.Contains($id)
        }
    }
}
