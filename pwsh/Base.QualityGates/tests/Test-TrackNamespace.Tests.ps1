Describe 'Test-TrackNamespace' -Tag 'L0', 'logic', 'DDR-TRACK-MODULENAMESPACE' {
    BeforeEach {
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Get-Track -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{
                    tracks = [ordered]@{
                        widgets = [ordered]@{ members = @('widgetry'); type = 'modules'; namespace = 'gadget'; join = '-'
                            namespace_exempt = @('widgetry/.core/gadget-core.*')
                        }
                        notes   = [ordered]@{ members = @('notes'); type = 'modules' }
                    }
                }).tracks
        }
        $script:outputFolder = Join-Path $TestDrive 'report'
    }

    It 'passes a tree whose folders and files drop the namespace, an exempt file, and a track with no namespace' {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates {
            'widgetry/spring/lever.js', 'widgetry/.core/gadget-core.psm1', 'notes/gadget-notes.md'
        }
        (Test-TrackNamespace -PassThru -OutputFolder $script:outputFolder).IssueCount | Should -Be 0
    }

    It 'names each folder or file that spells the namespace, once per folder' {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates {
            'widgetry/gadget-spring/lever.js', 'widgetry/gadget-spring/cog.js', 'widgetry/spring/gadget-lever.js'
        }
        $result = Test-TrackNamespace -PassThru -OutputFolder $script:outputFolder
        $result.IssueCount | Should -Be 2
        $result.Issues | Should -Contain "track 'widgets': 'widgetry/gadget-spring' spells the namespace 'gadget-' on disk; drop it from the name, or exempt the file under the track's namespace_exempt"
        $result.Issues | Should -Contain "track 'widgets': 'widgetry/spring/gadget-lever.js' spells the namespace 'gadget-' on disk; drop it from the name, or exempt the file under the track's namespace_exempt"
    }
}

Describe 'Test-TrackNamespace — the real tree' -Tag 'L1', 'integrity', 'source-only', 'DDR-TRACK-MODULENAMESPACE' {
    It 'finds no folder or file under a track that spells its namespace, apart from the declared exemptions' {
        $result = Test-TrackNamespace -PassThru -OutputFolder (Join-Path $TestDrive 'report')
        $result.Facts['Tracks'] | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
