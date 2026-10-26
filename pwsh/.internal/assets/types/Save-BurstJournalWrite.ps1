function Save-BurstJournalWrite {
    # .SYNOPSIS
    #     Records a file a writer is about to write in the journal of the staged burst this process runs in, if any.
    # .DESCRIPTION
    #     Invoke-StagedBurst sets the variable burst-journal.psd1 names to its journal folder for the import it runs, so
    #     only that process journals; a peer's import never sees it. The first write of a path in a burst copies its
    #     content into the journal, or records that it was absent, so a failed burst puts back or deletes exactly the
    #     files its import wrote. Outside a burst it does nothing.
    # .PARAMETER Path
    #     The file about to be written.
    # .OUTPUTS
    #     None.
    # .EXAMPLE
    #     Save-BurstJournalWrite -Path $contract
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Writes only into the burst journal folder the burst owns, never a repository file.')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '',
        Justification = 'The journal is the burst''s own bookkeeping; the burst announces what it restores.')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    # Read once per module: an import writes many files, and only the first call pays for the declaration.
    $declared = Get-Variable -Name burstJournalDeclared -Scope Script -ValueOnly -ErrorAction Ignore
    if ($null -eq $declared) {
        # A copy of the tree without the declaration, such as a test snapshot of the committed files, runs no burst.
        $declaration = [System.IO.Path]::Combine($PSScriptRoot, 'burst-journal.psd1')
        if (-not [System.IO.File]::Exists($declaration)) {
            return
        }
        $declared = Import-PowerShellDataFile -LiteralPath $declaration
        Set-Variable -Name burstJournalDeclared -Scope Script -Value $declared
    }
    $journal = [System.Environment]::GetEnvironmentVariable($declared.Variable)
    if ([string]::IsNullOrEmpty($journal) -or -not [System.IO.Directory]::Exists($journal)) {
        return
    }
    $full = [System.IO.Path]::GetFullPath($Path)
    $log = [System.IO.Path]::Combine($journal, $declared.WrittenLog)
    $entries = [System.Collections.Generic.List[object]]::new()
    if ([System.IO.File]::Exists($log)) {
        foreach ($entry in @([System.IO.File]::ReadAllText($log) | ConvertFrom-Json)) {
            if ($entry.path -ceq $full) {
                return
            }
            $entries.Add($entry)
        }
    }
    $existed = [System.IO.File]::Exists($full)
    $backup = $null
    if ($existed) {
        $backup = [System.IO.Path]::Combine($journal, $declared.WrittenFolder, "$($entries.Count).bak")
        [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($backup)) | Out-Null
        [System.IO.File]::Copy($full, $backup, $true)
    }
    $entries.Add([pscustomobject]@{ path = $full; existed = $existed; backup = $backup })
    [System.IO.File]::WriteAllText($log, (ConvertTo-Json -InputObject @($entries.ToArray()) -Depth 3))
}
