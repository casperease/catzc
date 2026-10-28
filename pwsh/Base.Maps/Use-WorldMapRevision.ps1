function Use-WorldMapRevision {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidatePattern('^[0-9a-f]{40}$')]
        [string] $Revision,

        [Parameter(Mandatory, Position = 1)]
        [scriptblock] $ScriptBlock
    )

    # The map's inputs beside the cited texts: every config, and the decision records with their index.
    $tree = Get-GitCommitTree -Revision $Revision
    $records = ((Get-Config -Config drs).Root -replace '\\', '/').TrimEnd('/') + '/'
    $loaded = [string[]] @($tree.Keys | Where-Object {
            ($_.EndsWith('.yml') -and "/$_".Contains('/configs/')) -or ($_.StartsWith($records, [System.StringComparison]::Ordinal) -and
                $_.EndsWith('.md'))
        })
    $blobTexts = Get-GitBlobText -Blob @($loaded | ForEach-Object { $tree[$_] })
    $texts = @{}
    foreach ($path in $loaded) {
        $texts[$path] = $blobTexts[$tree[$path]]
    }
    Use-RepositoryTextSource -Name $Revision -Path ([string[]] @($tree.Keys)) -Text $texts -ScriptBlock $ScriptBlock
}
