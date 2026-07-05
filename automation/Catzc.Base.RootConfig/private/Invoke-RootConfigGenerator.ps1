<#
.SYNOPSIS
    Renders the full content of a generator-produced managed root file — the registry's generator dispatch.
.DESCRIPTION
    A rootconfig entry with a `generator` names a function that renders the target's whole content (header
    included) rather than an authored source file to copy. This dispatch is the one place a generator name is
    bound to its invocation, so Build-RootConfig stays generic and an unknown name fails loudly instead of
    invoking an arbitrary command. Each generator is called in its content-returning form (never its writing
    form) — Build-RootConfig owns the write, through the same Write-FileIfChanged path as every copy-in.
.PARAMETER Name
    The generator function name from the registry entry (e.g. 'New-Importer').
.OUTPUTS
    [string] The rendered target content.
#>
function Invoke-RootConfigGenerator {
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Name
    )

    switch ($Name) {
        'New-Importer' {
            # The importer.ps1 shim, rendered from the Invoke-Importer overlay's param block (-DryRun returns
            # the content without writing).
            New-Importer -DryRun
        }
        default {
            throw "Unknown root-config generator '$Name'. Register its invocation in Invoke-RootConfigGenerator (Catzc.Base.RootConfig)."
        }
    }
}
