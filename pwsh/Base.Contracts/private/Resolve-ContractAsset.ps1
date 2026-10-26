function Resolve-ContractAsset {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Contracts.ContractAsset[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Root,

        [Parameter(Mandatory)]
        [string] $Version,

        [AllowEmptyString()]
        [string] $Group = '',

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $File,

        [string] $CommandRoot,

        [object] $AppliesTo = @{},

        # A holder the first glob match fills with the tracked files, so nothing is listed until an entry asks.
        [hashtable] $Tracked = @{}
    )

    $name = [System.IO.Path]::GetFileName($Path)
    $key = if ($Group) {
        "$Group/$Path"
    }
    else {
        $Path
    }
    $assetName = "contracts/$Root/$Version/$key"
    $manifest = "contracts/$Root/$Version/contract.yml"
    $isEmpty = [string]::IsNullOrWhiteSpace([System.IO.File]::ReadAllText($File))
    $kind = Get-ContractAssetKind -Name $name -IsEmpty:$isEmpty
    $direction = [Catzc.Base.Contracts.ContractDirection]::DependedOn
    if ($Root -ceq [Catzc.Base.Contracts.ContractLayout]::ProvidedRoot) {
        $direction = [Catzc.Base.Contracts.ContractDirection]::Provided
    }
    $isNamed = $AppliesTo.ContainsKey($key)
    # A subfolder sorts schemas, fragments, presence assets and samples; the rest sit at group level.
    if ($Path.Contains('/') -and ($kind -eq [Catzc.Base.Contracts.ContractAssetKind]::Command -or
            $kind -eq [Catzc.Base.Contracts.ContractAssetKind]::Types -or
            $name -ceq [Catzc.Base.Contracts.ContractLayout]::TypesSchemaName)) {
        throw "contract asset '$assetName': a $kind asset sits at group level, never in a group's folder (ADR-REPO-CONTRACT-LAYOUT)."
    }

    if ($kind -eq [Catzc.Base.Contracts.ContractAssetKind]::Sample -or $kind -eq [Catzc.Base.Contracts.ContractAssetKind]::Types) {
        if ($isNamed) {
            throw "${manifest}: applies_to names '$key', a $kind asset; only a schema, fragment or presence asset constrains files (ADR-REPO-CONTRACT-CONFIGUREDADDRESSING)."
        }
        return [Catzc.Base.Contracts.ContractAsset]::new($Root, $Version, $Group, $Path, $kind, $null, $direction)
    }

    if ($kind -eq [Catzc.Base.Contracts.ContractAssetKind]::Command) {
        if ($isNamed) {
            throw "${manifest}: applies_to names '$key', a $kind asset; only a schema, fragment or presence asset constrains files (ADR-REPO-CONTRACT-CONFIGUREDADDRESSING)."
        }
        if (-not $Group) {
            throw "contract asset '$assetName': a command contract sits in its module's group folder, since the folder names the owner and the file names the command (ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS)."
        }
        if (-not $CommandRoot) {
            throw "contract asset '$assetName': a command contract needs its module's root to name the command's file; pass -CommandRoot (ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS)."
        }
        # The asset names the command in the normal form; its file is named in PowerShell's function case.
        $languages = Get-Config -Config languages
        $commandLanguage = $languages.languages | Where-Object name -ceq 'powershell' | Select-Object -First 1
        $stem = $name.Substring(0, $name.Length - '.command.yml'.Length)
        try {
            $command = [Catzc.Base.Objects.NameCase]::FromNormal($stem, $commandLanguage.naming.function[0],
                $languages.naming_normal_form)
        }
        catch {
            throw "contract asset '$assetName': the command '$stem' is not in the repository normal form, $($languages.naming_normal_form) (ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS)."
        }
        return [Catzc.Base.Contracts.ContractAsset]::new($Root, $Version, $Group, $Path, $kind,
            "$CommandRoot/$command.ps1", $direction)
    }

    if ($kind -eq [Catzc.Base.Contracts.ContractAssetKind]::Schema) {
        $stem = $name.Substring(0, $name.Length - '.schema.json'.Length)
        $samplePattern = '^' + [regex]::Escape($stem) + '\.sample\.[^.]+$'
        $samples = @([Catzc.Base.Contracts.ContractLayout]::new((Get-Config -Config folder-walk)).FileNames([System.IO.Path]::GetDirectoryName($File)) |
                Where-Object { $_ -cmatch $samplePattern })
        if ($samples.Count -gt 1) {
            throw "contract asset '$assetName': the schema sits beside $($samples.Count) sample payloads named '$stem' ($($samples -join ', ')); keep one sample per schema name (ADR-REPO-CONTRACT-CONTRACTASSET)."
        }
        if ($samples.Count -eq 1) {
            if ($isNamed) {
                throw "${manifest}: applies_to names '$key', a schema that applies to the sample payload beside it; only a schema with no sample beside it takes files (ADR-REPO-CONTRACT-CONFIGUREDADDRESSING)."
            }
            $folder = $assetName.Substring(0, $assetName.LastIndexOf('/') + 1)
            return [Catzc.Base.Contracts.ContractAsset]::new($Root, $Version, $Group, $Path, $kind,
                "$folder$($samples[0])", $direction)
        }
        # The one types schema binds every group's types surface on disk, committed or not.
        if ($name -ceq [Catzc.Base.Contracts.ContractLayout]::TypesSchemaName) {
            if ($isNamed) {
                throw "${manifest}: applies_to names '$key', the types schema, which applies to every group's types surface; it takes no files (ADR-REPO-CONTRACT-CONFIGUREDADDRESSING)."
            }
            $versionFolder = [System.IO.Path]::GetDirectoryName([System.IO.Path]::GetDirectoryName($File))
            $surface = [Catzc.Base.Contracts.ContractLayout]::TypesSurfaceName
            foreach ($groupFolder in @([System.IO.Directory]::GetDirectories($versionFolder) | Sort-Object -CaseSensitive)) {
                if ([System.IO.File]::Exists([System.IO.Path]::Combine($groupFolder, $surface))) {
                    [Catzc.Base.Contracts.ContractAsset]::new($Root, $Version, $Group, $Path, $kind,
                        "contracts/$Root/$Version/$([System.IO.Path]::GetFileName($groupFolder))/$surface", $direction)
                }
            }
            return
        }
    }

    # A presence, fragment or sample-less schema binds exactly the files its applies_to names.
    if (-not $isNamed) {
        throw "${manifest}: '$key', a $kind asset, is not named in applies_to, so it binds no file (ADR-REPO-CONTRACT-CONFIGUREDADDRESSING)."
    }
    if ($null -eq $Tracked.Paths) {
        $Tracked.Paths = [string[]] @(Get-GitTrackedPath '.')
    }
    $globs = [string[]] @($AppliesTo[$key])
    $targets = [Catzc.Base.Objects.GlobPattern]::MatchingPaths($globs, $Tracked.Paths)
    if ($targets.Count -eq 0) {
        throw "${manifest}: applies_to of '$key' matches no tracked file ($($globs -join ', ')) (ADR-REPO-CONTRACT-CONFIGUREDADDRESSING)."
    }
    foreach ($target in $targets) {
        [Catzc.Base.Contracts.ContractAsset]::new($Root, $Version, $Group, $Path, $kind, $target, $direction)
    }
}
