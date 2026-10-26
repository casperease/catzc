Describe 'Test-TrackMemberCommitted' -Tag 'L0', 'logic', 'DDR-TRACK-TRACKISPLACEDCLUSTER' {
    BeforeAll {
        function script:New-Member {
            param([string] $Path, [bool] $Committed = $true, [bool] $Generated = $false)
            [Catzc.Base.Variants.TrackMember]::new('widget', [Catzc.Base.Variants.VariantMember]::new($Path, $Generated,
                    $Committed))
        }
    }

    BeforeEach {
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Get-GeneratedTarget -ModuleName Catzc.Base.QualityGates { }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $TestDrive }
        # The index tracks one file under every member unless a case says otherwise.
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates { "$Path/widget.txt" }
        # Every root entry lies in a track unless a case says otherwise.
        Mock Get-Track -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ name = 'widget' } }
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
        $result.Issues |
            Should -Contain "track 'widget': member 'widget' is declared committed, but git tracks none of it"
        $result.Issues |
            Should -Contain "track 'widget': member 'widget.cache' is declared not committed, but git tracks 1 file(s) of it, e.g. 'widget.cache/stray.txt'"
    }

    It 'names a member that declares generated while a generator already writes it, and passes one only the member declares' {
        Mock Get-GeneratedTarget -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ path = 'widget/**'; generator = 'Build-Widget' }
        }
        Mock Get-TrackMember -ModuleName Catzc.Base.QualityGates {
            New-Member 'widget/rendered.md' -Generated $true; New-Member 'gadget.cache' -Generated $true
        }
        $result = Test-TrackMemberCommitted -PassThru -OutputFolder $script:outputFolder
        $result.IssueCount | Should -Be 1
        $result.Issues |
            Should -Be "track 'widget': member 'widget/rendered.md' declares generated, but Build-Widget already writes it as a generated target; drop the declaration"
    }

    It 'leaves a committed member alone while nothing of it is on disk yet' {
        Mock Get-TrackMember -ModuleName Catzc.Base.QualityGates { New-Member 'widget'; New-Member '.landing' }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Path -eq '.landing' } { }
        (Test-TrackMemberCommitted -PassThru -OutputFolder $script:outputFolder).IssueCount | Should -Be 0
    }

    It 'names a root entry no track covers, and passes a folder that only holds a member' -Tag 'DDR-TRACKTYPE-LONGESTPLACEWINS' {
        $root = Join-Path $TestDrive "root-$([guid]::NewGuid().ToString('N'))"
        foreach ($folder in 'widget', 'holder/inner', '.git') {
            [System.IO.Directory]::CreateDirectory((Join-Path $root $folder)) | Out-Null
        }
        [System.IO.File]::WriteAllText((Join-Path $root 'stray.txt'), 'stray')
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $root }
        Mock Get-TrackMember -ModuleName Catzc.Base.QualityGates { New-Member 'widget'; New-Member 'holder/inner' }
        Mock Get-Track -ModuleName Catzc.Base.QualityGates { }
        Mock Get-Track -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Path -eq 'widget' } { [pscustomobject]@{ name = 'widget' } }
        $result = Test-TrackMemberCommitted -PassThru -OutputFolder $script:outputFolder
        $result.Issues | Should -Be @("root entry 'stray.txt' lies in no track; add it as a member of the track that owns it in variants.yml")
    }
}

Describe 'Test-TrackMemberCommitted — the real tree' -Tag 'L1', 'integrity', 'source-only', 'DDR-TRACK-TRACKISPLACEDCLUSTER' {
    It 'finds every declared member in step with the git index' {
        $result = Test-TrackMemberCommitted -PassThru -OutputFolder (Join-Path $TestDrive 'report')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
