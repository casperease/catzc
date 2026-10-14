# The result-cache halves shared by Format-Code and the analyzer: Split-CachedFile reads, Update-ResultCache writes,
# Get-ContentStamp fingerprints a check's inputs ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)).
# Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Split-CachedFile' -Tag 'L0', 'logic', 'ADR-AUTO-CACHE#10' {
    BeforeEach {
        $script:root = [System.IO.Path]::GetFullPath((Join-Path $TestDrive "repo-$([guid]::NewGuid().ToString('N'))"))
        $script:widget = Join-Path $script:root 'widgets/widget.wdg'
        $script:gadget = Join-Path $script:root 'gadgets/gadget.gdg'
        foreach ($file in $script:widget, $script:gadget) {
            $null = New-Item -ItemType File -Path $file -Force
            [System.IO.File]::WriteAllText($file, "content of $([System.IO.Path]::GetFileName($file))")
        }
        $script:outside = Join-Path $TestDrive 'elsewhere/sprocket.wdg'
        $null = New-Item -ItemType File -Path $script:outside -Force
        $script:split = {
            param($Files, $Cache, $Stamp)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ F = $Files; C = $Cache; S = $Stamp; R = $script:root } {
                param($F, $C, $S, $R)
                Split-CachedFile -File $F -Cache $C -Stamp $S -RepositoryRoot $R
            }
        }
        $script:update = {
            param($Cache, $Key, $Checked, $Flagged)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ C = $Cache; K = $Key; Ch = $Checked; F = $Flagged } {
                param($C, $K, $Ch, $F)
                Update-ResultCache -Cache $C -Key $K -Checked $Ch -Flagged $F
            }
        }
    }

    It 'checks everything on an empty cache, records only the clean files, and then skips them' {
        $cache = @{}
        $first = & $script:split @($script:widget, $script:gadget, $script:outside) $cache 'stamp-1'
        $first.Pending | Should -Be @($script:widget, $script:gadget, $script:outside)
        $first.CachedCount | Should -Be 0
        & $script:update $cache $first.Key @($script:widget, $script:gadget, $script:outside) @($script:gadget)
        @($cache.Keys) | Should -Be @('widgets/widget.wdg')

        $second = & $script:split @($script:widget, $script:gadget, $script:outside) $cache 'stamp-1'
        $second.Pending | Should -Be @($script:gadget, $script:outside)
        $second.CachedCount | Should -Be 1
    }

    It 'checks a file again when its bytes or the stamp change' {
        $cache = @{}
        $first = & $script:split @($script:widget) $cache 'stamp-1'
        & $script:update $cache $first.Key @($script:widget) @()
        [System.IO.File]::WriteAllText($script:widget, 'edited')
        (& $script:split @($script:widget) $cache 'stamp-1').Pending | Should -Be @($script:widget)
        [System.IO.File]::WriteAllText($script:widget, 'content of widget.wdg')
        (& $script:split @($script:widget) $cache 'stamp-1').Pending.Count | Should -Be 0
        (& $script:split @($script:widget) $cache 'stamp-2').Pending | Should -Be @($script:widget)
    }

    It 'removes a cached file the check flags, and rekeys a rewritten file from its bytes now' {
        $cache = @{}
        $first = & $script:split @($script:widget) $cache 'stamp-1'
        & $script:update $cache $first.Key @($script:widget) @()
        & $script:update $cache $first.Key @($script:widget) @($script:widget)
        $cache.Count | Should -Be 0

        [System.IO.File]::WriteAllText($script:widget, 'reformatted')
        InModuleScope Catzc.Base.QualityGates -Parameters @{ C = $cache; K = $first.Key; W = $script:widget } {
            param($C, $K, $W)
            Update-ResultCache -Cache $C -Key $K -Checked @($W) -Stamp 'stamp-1' -RekeyFromDisk
        }
        (& $script:split @($script:widget) $cache 'stamp-1').Pending.Count | Should -Be 0
    }
}

Describe 'Get-ContentStamp' -Tag 'L0', 'logic', 'ADR-AUTO-CACHE#10' {
    It 'changes when an input''s content, presence or the label changes, and is stable otherwise' {
        $root = [System.IO.Path]::GetFullPath((Join-Path $TestDrive 'stamp-repo'))
        $settings = Join-Path $root 'widget.settings'
        $null = New-Item -ItemType File -Path $settings -Force
        [System.IO.File]::WriteAllText($settings, 'width: 140')
        $stamp = {
            param($Label, $Files)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ L = $Label; F = $Files; R = $root } {
                param($L, $F, $R)
                Get-ContentStamp -Label $L -File $F -RepositoryRoot $R
            }
        }
        $first = & $stamp 'widget' @($settings)
        & $stamp 'widget' @($settings) | Should -Be $first
        & $stamp 'gadget' @($settings) | Should -Not -Be $first
        [System.IO.File]::WriteAllText($settings, 'width: 120')
        $edited = & $stamp 'widget' @($settings)
        $edited | Should -Not -Be $first
        Remove-Item -LiteralPath $settings
        & $stamp 'widget' @($settings) | Should -Not -Be $edited
    }
}
