# catzc:
#   path: automation/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1
#   module: Catzc.Base.RootConfig
#   visibility: private

<#
.SYNOPSIS
    Renders a generator entry of the root-config registry into one { Target; Content } record per file.
.DESCRIPTION
    A wildcard target may render no file, but a literal target must render exactly one; any other shape throws.
    [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)
    [comment:1](/docs/references/automation/catzc-base-rootconfig/private/Get-RootConfigRenderedFile.ps1.md#comment1)
.PARAMETER Entry
    An opted-in generator entry of rootconfig.yml (a RootConfigFile, or any object with target and generator).
.OUTPUTS
    [pscustomobject] One { Target; Content } record per rendered file, in the generator's order.
#>
function Get-RootConfigRenderedFile {
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        $Entry
    )

    $pattern = [string] $Entry.target
    $isPattern = [System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($pattern)
    $rendered = @(Invoke-RootConfigGenerator -Name $Entry.generator -Target $pattern)

    if ($rendered.Count -eq 1 -and $rendered[0] -is [string]) {
        if ($isPattern) {
            throw "Root-config entry '$pattern': generator $($Entry.generator) returned one string, but a wildcard target needs one { Target; Content } record per file."
        }
        return [pscustomobject]@{ Target = $pattern; Content = $rendered[0] }
    }

    $files = foreach ($record in $rendered) {
        if ($record -is [string] -or -not $record.PSObject.Properties['Target'] -or -not $record.PSObject.Properties['Content']) {
            throw "Root-config entry '$pattern': generator $($Entry.generator) must return one string or { Target; Content } records."
        }
        $recordTarget = [string] $record.Target
        if ($recordTarget -cnotlike $pattern) {
            throw "Root-config entry '$pattern': generator $($Entry.generator) rendered '$recordTarget', which does not match the entry's target."
        }
        [pscustomobject]@{ Target = $recordTarget; Content = [string] $record.Content }
    }
    $files = @($files)

    if (-not $isPattern -and $files.Count -ne 1) {
        throw "Root-config entry '$pattern': generator $($Entry.generator) rendered $($files.Count) files for a literal target; it must render exactly one."
    }
    $files
}
