# The writers' due rows (Get-GeneratedWriterDue), or nothing when they cannot be read: every build janitor then runs, as before the lists.
function Get-DueWriterRow {
    [CmdletBinding()]
    param()

    if (-not (Get-Command Get-GeneratedWriterDue -ErrorAction Ignore)) {
        return
    }
    try {
        Get-GeneratedWriterDue
    }
    catch {
        Write-ImporterMessage "Build janitors: all run, the changed set was not read — $($_.Exception.Message)" -ForegroundColor Yellow
    }
}
