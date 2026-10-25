function Save-GeneratedWriterStamp {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Name,

        [string] $MemoPath = (Join-Path (Get-OutputRoot) 'cache/generated-writers.json')
    )

    # Stores the stamp the last Get-GeneratedWriterDue computed for a writer, once that writer has run, so it is not due again until
    # one of its inputs changes. A writer the last call did not judge stores nothing.
    $stamps = $script:GeneratedWriterStamps
    if ($null -eq $stamps -or -not $stamps.ContainsKey($Name)) {
        return
    }
    $memo = Get-GeneratedWriterMemo -MemoPath $MemoPath
    $memo[$Name] = $stamps[$Name]
    [void] [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($MemoPath))
    [System.IO.File]::WriteAllText($MemoPath, ($memo | ConvertTo-Json -Compress))
}
