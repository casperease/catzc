function Restore-Generated {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([string])]
    param(
        [string[]] $Name,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $MemoPath = (Join-Path (Get-OutputRoot) 'cache/generated-writers.json')
    )

    $writers = @(Get-GeneratedWriterOrder | Where-Object { $_.class -ceq 'rollable' -and (-not $Name -or $_.name -in $Name) })
    foreach ($writer in $writers) {
        # Asked writer by writer, in render order, so a writer reading what an earlier one just wrote sees that change.
        $due = @(Get-GeneratedWriterDue -Name $writer.name -RepositoryRoot $RepositoryRoot -MemoPath $MemoPath)
        if (-not ($due | Where-Object { $_.Name -ceq $writer.name -and $_.Due })) {
            continue
        }
        if (-not (Get-Command $writer.name -ErrorAction Ignore)) {
            throw "Restore-Generated: the writer '$($writer.name)' is not a command in this session."
        }
        if ($PSCmdlet.ShouldProcess($writer.name, 'Run the writer')) {
            & $writer.name | Out-Null
            Save-GeneratedWriterStamp -Name $writer.name -RepositoryRoot $RepositoryRoot -MemoPath $MemoPath
            $writer.name
        }
    }
}
