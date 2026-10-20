function Get-FileMetaFact {
    [CmdletBinding(DefaultParameterSetName = 'Path')]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, ParameterSetName = 'State')]
        [pscustomobject] $State,

        [Parameter(Mandatory, Position = 0)]
        [string[]] $Path,

        [Catzc.Base.QualityGates.FileMetaConfig] $Config = (Get-Config -Config file-meta)
    )

    if ($PSCmdlet.ParameterSetName -eq 'Path') {
        $root = Get-RepositoryRoot
        foreach ($entry in @(Get-FileMetaScope -RepositoryRoot $root -Path $Path -Config $Config)) {
            $carrier = $entry.Carrier.carrier
            # A sidecar carrier's facts are its description file's, which is in scope on its own.
            if ($carrier -eq [Catzc.Base.Languages.CarrierKind]::Sidecar) {
                continue
            }
            $file = $entry.Path
            $text = [System.IO.File]::ReadAllText((Join-Path $root $file))
            $fileState = if ($carrier -eq [Catzc.Base.Languages.CarrierKind]::Property) {
                $propertyState = Get-PropertyMetaState -Text $text -Property $entry.Carrier.property -Strip $entry.Carrier.strip
                if (-not $propertyState.IsObject) {
                    continue
                }
                $propertyState | Add-Member -NotePropertyName Rest -NotePropertyValue $text -PassThru
            }
            elseif ($carrier -eq [Catzc.Base.Languages.CarrierKind]::CommentHead) {
                Get-CodeMetaState -Text $text -Form $entry.Carrier.Form()
            }
            else {
                Get-MarkdownMetaState -Text $text -Key $entry.Carrier.key
            }
            $facts = Get-FileMetaFact -State $fileState -Path $file -Config $Config
            [pscustomobject]@{ Path = $file; Immutable = $facts.Immutable; Edges = $facts.Edges }
        }
        return
    }

    Assert-True ($Path.Count -eq 1) -ErrorText "Get-FileMetaFact -State reads one file, but $($Path.Count) paths were given."
    $facts = @{ immutable = [ordered]@{}; edges = [ordered]@{} }
    $language = (Get-Config -Config languages).ForPath($Path[0])
    $languageName = if ($language) {
        $language.name
    }
    else {
        $null
    }
    $fileClass = (Get-FileKind $Path[0]).Class
    foreach ($kind in $Config.Imprint()) {
        if (-not $Config.Selects($kind, $fileClass, $languageName)) {
            continue
        }
        $processor = Get-Command -Name $kind.processor -CommandType Function -ErrorAction Ignore
        Assert-NotNull $processor -ErrorText "file-meta config: kind '$($kind.id)' is subscribed by '$($kind.processor)', but no such function exists."
        $produced = & $kind.processor -State $State -Path $Path[0] -Kind $kind
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
