function Save-GeneratedWriterStamp {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $MemoPath = (Join-Path (Get-OutputRoot) 'cache/generated-writers.json')
    )

    # Taken after the run, so a file the writer both reads and writes is in the stamp and never makes it due again by itself.
    $writer = @(Get-GeneratedWriterOrder | Where-Object name -CEQ $Name) | Select-Object -First 1
    if ($null -eq $writer) {
        throw "Save-GeneratedWriterStamp: '$Name' is not a writer of any module's generated.yml."
    }
    $inputs = [Catzc.Base.GeneratedFiles.GeneratedWriterGraph]::Inputs($writer)
    $walk = Get-GeneratedWriterInputFile -InputGlob $inputs -RepositoryRoot $RepositoryRoot
    $memo = Get-GeneratedWriterMemo -MemoPath $MemoPath
    $memo[$Name] = (Get-GeneratedWriterStamp -Writer @($writer) -Walk $walk -RepositoryRoot $RepositoryRoot)[$Name]
    [void] [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($MemoPath))
    [System.IO.File]::WriteAllText($MemoPath, ($memo | ConvertTo-Json -Compress))
}
