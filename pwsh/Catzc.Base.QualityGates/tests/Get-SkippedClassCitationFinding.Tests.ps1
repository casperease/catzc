<#
---
catzc:
  immutable:
    with_body_sha: "1770929ce1ef"
  edges:
    code: pwsh/Catzc.Base.QualityGates/private/Get-SkippedClassCitationFinding.ps1
---
#>

Describe 'Get-SkippedClassCitationFinding' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        foreach ($page in 'pages/widget.md', 'pages/gadget.md', 'pages/gizmo.md') {
            $full = Join-Path $script:root $page
            [System.IO.Directory]::CreateDirectory((Split-Path $full -Parent)) | Out-Null
            [System.IO.File]::WriteAllText($full, '# page')
        }
        $script:kind = [Catzc.Base.QualityGates.FileMetaKind]::new('adr-codes', @{ section = 'edges'; keys = @('cites'); select = @(@{ classes = @('function') }) })
        $pages = [pscustomobject]@{} | Add-Member -MemberType ScriptMethod -Name PageFor -Value {
            param($source)
            @{ 'src/widget.sh' = 'pages/widget.md'; 'src/gadget.ps1' = 'pages/gadget.md'; 'src/gizmo.sh' = 'pages/gizmo.md'; 'src/orphan.sh' = 'pages/none.md' }[$source]
        } -PassThru
        $kinds = [pscustomobject]@{} | Add-Member -MemberType ScriptMethod -Name Resolve -Value {
            param($source)
            $class = 'widget-script'
            if ($source -like '*.ps1') {
                $class = 'function'
            }
            [pscustomobject]@{ Class = $class }
        } -PassThru
        $languages = [pscustomobject]@{} | Add-Member -MemberType ScriptMethod -Name ForPath -Value {
            param($source)
            [pscustomobject]@{ name = 'bash' }
        } -PassThru
        $script:configs = @{ 'file-meta' = [pscustomobject]@{ kinds = @($script:kind) }; 'comment-pages' = $pages; 'file-kinds' = $kinds; 'languages' = $languages }

        Mock Get-Config -ModuleName Catzc.Base.QualityGates { $script:configs[$Config] }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates { @('src/widget.sh', 'src/gadget.ps1', 'src/gizmo.sh', 'src/orphan.sh', 'src/bare.sh') }
        Mock Get-DrsCodesFileMetaFact -ModuleName Catzc.Base.QualityGates {
            @{ cites = [string[]] @(if ($Path -ne 'src/gizmo.sh') {
                        'ADR-WIDGET-GADGET-TURN'
                    })
            }
        }
    }

    It 'reports a comment page that cites rules for a file whose class the adr-codes select skips' {
        $found = @(InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } {
                param($Root)
                Get-SkippedClassCitationFinding -RepositoryRoot $Root
            })
        $found | Should -HaveCount 1
        $found[0] | Should -BeLike 'pages/widget.md:1 `[SkippedClassCitation`] cites ADR-WIDGET-GADGET-TURN for src/widget.sh, whose class ''widget-script''*add the class to the select*'
    }

    It 'passes a selected class, a page that cites nothing, a missing page and a file without one' {
        $found = @(InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } {
                param($Root)
                Get-SkippedClassCitationFinding -RepositoryRoot $Root -Path 'src/gadget.ps1', 'src/gizmo.sh', 'src/orphan.sh', 'src/bare.sh'
            })
        $found | Should -HaveCount 0
    }
}
