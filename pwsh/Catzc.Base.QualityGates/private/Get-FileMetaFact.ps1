function Get-FileMetaFact {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $State,

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.FileMetaConfig] $Config
    )

    $facts = @{ immutable = [ordered]@{}; edges = [ordered]@{} }
    $language = (Get-Config -Config languages).ForPath($Path)
    $languageName = if ($language) {
        $language.name
    }
    else {
        $null
    }
    $fileClass = (Get-FileKind $Path).Class
    foreach ($kind in $Config.Imprint()) {
        if (-not $Config.Selects($kind, $fileClass, $languageName)) {
            continue
        }
        $processor = Get-Command -Name $kind.processor -CommandType Function -ErrorAction Ignore
        Assert-NotNull $processor -ErrorText "file-meta config: kind '$($kind.id)' is subscribed by '$($kind.processor)', but no such function exists."
        $produced = & $kind.processor -State $State -Path $Path -Kind $kind
        $expected = @($kind.keys)
        $actual = @($produced.Keys)
        Assert-True (($actual -join ',') -ceq ($expected -join ',')) `
            -ErrorText "file-meta config: '$($kind.processor)' returned keys [$($actual -join ', ')], but kind '$($kind.id)' declares [$($expected -join ', ')]."
        foreach ($key in $expected) {
            $facts[$kind.section][$key] = $produced[$key]
        }
    }
    [pscustomobject]@{ Immutable = $facts['immutable']; Edges = $facts['edges'] }
}
