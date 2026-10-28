function Disable-GeneratedGuardHook {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([string])]
    param(
        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $hook = Get-GeneratedGuardHook -RepositoryRoot $RepositoryRoot
    if (-not [System.IO.File]::Exists($hook.Path)) {
        return
    }
    if (-not [System.IO.File]::ReadAllText($hook.Path).Contains($hook.Marker)) {
        throw "Disable-GeneratedGuardHook: '$($hook.Path)' is a pre-commit hook catzc did not write; it stays."
    }

    if ($PSCmdlet.ShouldProcess($hook.Path, 'Remove the generated-files guard pre-commit hook')) {
        [System.IO.File]::Delete($hook.Path)
        $hook.Path
    }
}
