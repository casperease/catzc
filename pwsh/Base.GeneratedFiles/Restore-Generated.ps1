function Restore-Generated {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([string])]
    param(
        [string[]] $Name,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $MemoPath = (Join-Path (Get-OutputRoot) 'cache/generated-writers.json')
    )

    $order = @(Get-GeneratedWriterOrder)
    $writers = @($order | Where-Object { $_.class -ceq 'rollable' -and (-not $Name -or $_.name -in $Name) })
    foreach ($writer in $writers) {
        # Asked writer by writer, in render order, so a writer reading what an earlier one just wrote sees that change.
        $due = @(Get-GeneratedWriterDue -Name $writer.name -RepositoryRoot $RepositoryRoot -MemoPath $MemoPath)
        if (-not ($due | Where-Object { $_.Name -ceq $writer.name -and $_.Due })) {
            continue
        }
        $isCommand = [bool] (Get-Command $writer.name -ErrorAction Ignore)
        if (-not $isCommand -and -not $writer.regenerate) {
            throw "Restore-Generated: the writer '$($writer.name)' is not a command in this session and its row has no regenerate command."
        }
        if ($PSCmdlet.ShouldProcess($writer.name, 'Run the writer')) {
            if ($isCommand) {
                & $writer.name | Out-Null
            }
            else {
                Invoke-GeneratedWriterRegenerate -Writer $writer -Writers $order -RepositoryRoot $RepositoryRoot
            }
            Save-GeneratedWriterStamp -Name $writer.name -RepositoryRoot $RepositoryRoot -MemoPath $MemoPath
            $writer.name
        }
    }
}
