function Get-ContractTypeFindings {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Version,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $root = [Catzc.Base.Contracts.ContractLayout]::ProvidedRoot
    $versionFolder = Join-Path $RepositoryRoot "contracts/$root/$Version"
    if (-not [System.IO.Directory]::Exists($versionFolder)) {
        return
    }
    $normalForm = (Get-Config -Config languages).naming_normal_form
    $surface = [Catzc.Base.Contracts.ContractLayout]::TypesSurfaceName
    $known = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $layout = [Catzc.Base.Contracts.ContractLayout]::new((Get-Config -Config folder-walk))
    foreach ($groupFolder in @($layout.Folders($versionFolder))) {
        $file = Join-Path $groupFolder $surface
        if (-not [System.IO.File]::Exists($file)) {
            continue
        }
        $group = [System.IO.Path]::GetFileName($groupFolder)
        $names = @(@((Read-ContractData -RepositoryRoot $RepositoryRoot -Path "contracts/$root/$Version/$group/$surface")['types']) |
                ForEach-Object { $_['name'] })
        foreach ($name in $names) {
            [void] $known.Add([Catzc.Base.Objects.NameCase]::ToNormal('pascal-dotted', $name, $normalForm))
        }
        foreach ($module in @($names | ForEach-Object { $_.Substring(0, $_.LastIndexOf('.')) } | Select-Object -Unique)) {
            $expected = try {
                Get-ContractGroup -Module $module -RepositoryRoot $RepositoryRoot
            }
            catch {
                $_.Exception.Message
            }
            if ($expected -cne $group) {
                "contracts/$root/$Version/$group/$surface lists types of $module, whose contract group is '$expected' (ADR-REPO-CONTRACT-LAYOUT)."
            }
        }
    }

    foreach ($command in @(Get-CommandContract -Version $Version -RepositoryRoot $RepositoryRoot)) {
        $named = @(@($command.parameters | ForEach-Object { $_.Type }) + @($command.output)) |
            Where-Object { $_ } | ForEach-Object { $_ -creplace '\[\]$', '' } | Where-Object { $_.StartsWith('catzc.', [System.StringComparison]::Ordinal) }
        foreach ($type in @($named | Select-Object -Unique)) {
            if (-not $known.Contains($type)) {
                "$($command.Asset.AssetPath) names the type '$type', which no group's $surface lists (ADR-REPO-CONTRACT-BINDINGINTERFACE)."
            }
        }
    }
}
