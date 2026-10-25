function Save-GeneratedWriterStamp {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Name,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $MemoPath = (Join-Path (Get-OutputRoot) 'cache/generated-writers.json')
    )

    # Stores a writer's input stamp once it has run, taken after the run, so an input it writes itself (a target declared as an input) is
    # part of the stored stamp and the writer is not due again until one of its inputs changes.
    $writer = (Get-Config -Config generated-files).writers[$Name]
    if ($null -eq $writer) {
        throw "Save-GeneratedWriterStamp: '$Name' is not a writer in generated-files.yml."
    }
    $inputs = [string[]] @($writer.inputs | Where-Object { $_ })
    $walk = Get-GeneratedWriterInputFile -InputGlob $inputs -RepositoryRoot $RepositoryRoot
    $memo = Get-GeneratedWriterMemo -MemoPath $MemoPath
    $memo[$Name] = Get-GeneratedWriterStamp -InputGlob $inputs -Walk $walk -RepositoryRoot $RepositoryRoot
    [void] [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($MemoPath))
    [System.IO.File]::WriteAllText($MemoPath, ($memo | ConvertTo-Json -Compress))
}
