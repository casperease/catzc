Describe 'Test-TrackMemberCommitted' -Tag 'L0', 'logic', 'DDR-TRACK-TRACKISPLACEDCLUSTER' {
    BeforeAll {
        function script:New-Member {
            param([string] $Path, [bool] $Committed = $true)
            [Catzc.Base.Variants.TrackMember]::new('widget', [Catzc.Base.Variants.VariantMember]::new($Path, $false, $Committed))
        }
    }

    BeforeEach {
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $TestDrive }
        # The index tracks one file under every member unless a case says otherwise.
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates { "$Path/widget.txt" }
        foreach ($folder in 'widget', 'widget.cache') {
            [System.IO.Directory]::CreateDirectory((Join-Path $TestDrive $folder)) | Out-Null
        }
        $script:outputFolder = Join-Path $TestDrive 'report'
    }

    It 'passes a committed member git tracks and a not-committed member git does not, and names each that disagrees' {
        Mock Get-TrackMember -ModuleName Catzc.Base.QualityGates { New-Member 'widget'; New-Member 'widget.cache' -Committed $false }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Path -eq 'widget.cache' } { }
        (Test-TrackMemberCommitted -PassThru -OutputFolder $script:outputFolder).IssueCount | Should -Be 0

        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Path -eq 'widget.cache' } { 'widget.cache/stray.txt' }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Path -eq 'widget' } { }
        $result = Test-TrackMemberCommitted -PassThru -OutputFolder $script:outputFolder
        $result.IssueCount | Should -Be 2
        $result.Issues | Should -Contain "track 'widget': member 'widget' is declared committed, but git tracks none of it"
        $result.Issues | Should -Contain "track 'widget': member 'widget.cache' is declared not committed, but git tracks 1 file(s) of it, e.g. 'widget.cache/stray.txt'"
    }

    It 'leaves a committed member alone while nothing of it is on disk yet' {
        Mock Get-TrackMember -ModuleName Catzc.Base.QualityGates { New-Member 'widget'; New-Member '.landing' }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Path -eq '.landing' } { }
        (Test-TrackMemberCommitted -PassThru -OutputFolder $script:outputFolder).IssueCount | Should -Be 0
    }
}

Describe 'Test-TrackMemberCommitted — the real tree' -Tag 'L1', 'integrity', 'source-only', 'DDR-TRACK-TRACKISPLACEDCLUSTER' {
    It 'finds every declared member in step with the git index' {
        $result = Test-TrackMemberCommitted -PassThru -OutputFolder (Join-Path $TestDrive 'report')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
