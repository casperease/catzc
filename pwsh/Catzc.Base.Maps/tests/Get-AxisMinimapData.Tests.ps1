Describe 'Get-AxisMinimapData' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:schema = [System.IO.File]::ReadAllText((Join-Path (Get-RepositoryRoot) 'contracts/catzc/0.1.0/catzc.base.maps/minimap.schema.json'))
        $adr = {
            param([string] $External, [string] $Stack, [string[]] $Concerns)
            [Catzc.Base.Drs.DrsRuleSet]::new('widgetry', 'fixture', 'widget', $External, 'WIDGET', 'WIDGET', $Stack,
                $Concerns, $Concerns)
        }
        $script:map = [Catzc.Base.Maps.ValueChainMap]::Build(@('TOP', 'SIDE', 'BOTTOM'), @('alpha', 'beta', 'gamma'), @(
                & $adr 'ADR-WIDGET-GADGET' 'TOP' @('alpha', 'beta')
                & $adr 'ADR-WIDGET-COG' 'SIDE' @('beta')
                & $adr 'ADR-WIDGET-GEAR' 'BOTTOM' @('gamma')
            ))
        $rows = [ordered]@{ UPPER = @('TOP', 'SIDE'); LOWER = @('BOTTOM') }
        $script:config = [Catzc.Base.Maps.MapsConfig]::new(@{ minimaps = @{ axis = @{ rows = $rows; columns = @('alpha',
            'beta') } } })
    }

    BeforeEach {
        Mock Get-ValueChainMap -ModuleName Catzc.Base.Maps { $script:map }
        Mock Get-Config -ModuleName Catzc.Base.Maps -ParameterFilter { $Config -eq 'maps' } { $script:config }
    }

    It 'gathers the value-chain stacks into the configured rows and shows only the configured concerns' {
        $data = Get-AxisMinimapData -Adr 'ADR-WIDGET-COG'
        @($data.Axes | ForEach-Object Name) | Should -Be @('domain', 'concern')
        $data.Axes[0].Values | Should -Be @('UPPER', 'LOWER')
        $data.Axes[1].Values | Should -Be @('alpha', 'beta')
        @($data.Cells | ForEach-Object { "$($_.At -join ' x ')=$($_.Count)" }) | Should -Be @('UPPER x alpha=1',
            'UPPER x beta=2', 'LOWER x alpha=0', 'LOWER x beta=0')
    }

    It 'lights the cell of each covered code with the ADR as its reason, and serializes to the minimap contract' {
        $data = Get-AxisMinimapData -Adr 'ADR-WIDGET-COG'
        @($data.Lit | ForEach-Object { $_.At -join ' x ' }) | Should -Be @('UPPER x beta')
        $data.Lit[0].Reasons[0].Subject | Should -Be 'ADR-WIDGET-COG'
        Test-Json -Json $data.ToJson() -Schema $script:schema | Should -BeTrue
    }

    It 'lights the whole row of an ADR whose concerns all fall outside the columns, saying so' {
        $data = Get-AxisMinimapData -Adr 'ADR-WIDGET-GEAR'
        @($data.Lit | ForEach-Object { $_.At -join ' x ' }) | Should -Be @('LOWER x *')
        $data.Lit[0].Reasons[0].Subject | Should -Be 'ADR-WIDGET-GEAR'
        $data.Lit[0].Reasons[0].Note | Should -Be 'concern gamma, outside the axis'
        Test-Json -Json $data.ToJson() -Schema $script:schema | Should -BeTrue
    }

    It 'lights no whole row for an ADR that also has a concern inside the columns' {
        $data = Get-AxisMinimapData -Adr 'ADR-WIDGET-GADGET'
        @($data.Lit | ForEach-Object { $_.At -join ' x ' }) | Should -Be @('UPPER x alpha', 'UPPER x beta')
    }
}
