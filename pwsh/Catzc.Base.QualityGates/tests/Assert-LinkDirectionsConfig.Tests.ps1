# The validator refuses a row naming a value no registry declares, or a because that is no rule code.
Describe 'Assert-LinkDirectionsConfig' -Tag 'L0', 'logic', 'ADR-CONF-LOADING-POWERSHELLVALIDATOR', 'ADR-REPO-LINKS-DIRECTIONSAREROWS' {
    BeforeEach {
        InModuleScope Catzc.Base.QualityGates {
            $kinds = [pscustomobject] @{
                kinds = @(
                    [pscustomobject] @{ role = 'code'; subkinds = @() }
                    [pscustomobject] @{ role = 'reference'; subkinds = @([pscustomobject] @{ subkind = 'gadget'; subkinds = @() }) }
                )
            }
            $types = [pscustomobject] @{ types = @([pscustomobject] @{ id = 'widgets' }) }
            $map = [pscustomobject] @{} | Add-Member -PassThru ScriptMethod HasCode { param($Code) $Code -ceq 'ADR-WIDGET-ONE' }
            Mock Get-Config -ParameterFilter { $Config -eq 'file-kinds' } { $kinds }.GetNewClosure()
            Mock Get-Config -ParameterFilter { $Config -eq 'track-types' } { $types }.GetNewClosure()
            Mock Get-Track { [pscustomobject] @{ name = 'mods' } }
            Mock Get-AspectGlobSet { [ordered]@{ live = @(); tests = @() } }
            Mock Get-DrsCitationMap { $map }.GetNewClosure()
        }
        $script:assert = {
            param([hashtable] $Row)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Row = $Row } { param($Row) Assert-LinkDirectionsConfig -Config @{ rows = @($Row) } }
        }
    }

    It 'passes a row whose every value is declared' {
        $row = @{
            from = @{ classes = @('code'); aspects = @('live'); tracks = @('mods'); track_types = @('widgets'); modules = @('Catzc.Base.QualityGates') }
            to = @{ classes = @('reference/gadget', 'reference', 'ref*') }; verdict = 'allow'; because = 'ADR-WIDGET-ONE'
        }
        { & $assert $row } | Should -Not -Throw
    }

    It 'names every undeclared value and an unknown because, row and side included' {
        $row = @{ from = @{ classes = @('gizmo'); aspects = @('docs') }; to = @{ track_types = @('gadgets'); modules = @('Catzc.Gadget') }; verdict = 'deny'; because = 'ADR-WIDGET-TWO' }
        { & $assert $row } | Should -Throw "*row 1.from: class 'gizmo'*row 1.from: aspects value 'docs'*row 1.to: track_types value 'gadgets'*row 1.to: modules value 'Catzc.Gadget'*row 1: because 'ADR-WIDGET-TWO'*"
    }

    It 'refuses a subkind under the wrong role' {
        { & $assert @{ to = @{ classes = @('code/gadget') }; verdict = 'deny'; because = 'ADR-WIDGET-ONE' } } | Should -Throw "*class 'code/gadget'*"
    }
}
