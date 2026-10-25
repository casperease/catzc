<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-generated-files/Save-GeneratedWriterStamp.ps1.md"
  header: "generated"
---
#>

function Save-GeneratedWriterStamp {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $MemoPath = (Join-Path (Get-OutputRoot) 'cache/generated-writers.json')
    )

    # Taken after the run, so a file the writer both reads and writes is in the stored stamp and never makes it due again by itself.
    $writer = (Get-Config -Config generated-files).writers[$Name]
    if ($null -eq $writer) {
        throw "Save-GeneratedWriterStamp: '$Name' is not a writer in generated-files.yml."
    }
    $inputs = [string[]] @($writer.inputs | Where-Object { $_ })
    $walk = Get-GeneratedWriterInputFile -InputGlob $inputs -RepositoryRoot $RepositoryRoot
    $memo = Get-GeneratedWriterMemo -MemoPath $MemoPath
    $memo[$Name] = (Get-GeneratedWriterStamp -Writer @($writer) -Walk $walk -RepositoryRoot $RepositoryRoot)[$Name]
    [void] [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($MemoPath))
    [System.IO.File]::WriteAllText($MemoPath, ($memo | ConvertTo-Json -Compress))
}
