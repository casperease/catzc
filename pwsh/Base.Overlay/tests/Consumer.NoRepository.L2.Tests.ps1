Describe 'A consumer root with no repository' -Tag 'L2', 'logic', 'greedy', 'source-only', 'post-build' {
    BeforeAll {
        Import-InternalModule TestKit

        # The consumer module's public function and the consumer's tracks, the same small strings as the first Describe of Consumer.L2.Tests.ps1.
        $widget = @'
function Get-LocalWidget {
    [OutputType([string])]
    [CmdletBinding()]
    param()

    'widget-v1'
}

'@
        $variants = @'
tracks:
  widget:
    members: [widget]
    type: modules
    namespace: Widget
  docs:
    members: [docs]
    type: documentation

'@
        # The bundle installed and no `git init`: the working root is no checkout.
        $noRepoFile = @{
            'widget/Local/Get-LocalWidget.ps1' = $widget
            '.catzc/configs/variants.yml'      = $variants
        }
        # The immutable build store serves the full bundle the other file built, so this root pays the install and not a second build.
        $script:handle = New-ConsumerRoot -Bundle 'full' -File $noRepoFile

        $script:session = Invoke-InBuiltCatzc -Handle $script:handle -ScriptBlock {
            [pscustomobject]@{
                RunMode     = Get-CatzcRunMode
                LocalWidget = Get-LocalWidget
                TrackedPath = @(Get-GitTrackedPath '.')
                RepoStatus  = $(
                    try {
                        Get-RepoStatus -Path '.'
                        'passed'
                    }
                    catch {
                        $_.Exception.Message
                    }
                )
                ChangedPath = $(
                    try {
                        Get-GitChangedPath
                        'passed'
                    }
                    catch {
                        $_.Exception.Message
                    }
                )
                GateOutcome = $(
                    try {
                        $report = Test-QualityGates -PassThru
                        "issues:$(@($report.Issues).Count)"
                    }
                    catch {
                        "threw:$($_.Exception.Message)"
                    }
                )
            }
        }
    }

    AfterAll {
        Remove-BuiltCatzcRoot $script:handle
    }

    It 'runs in the run mode build' -Tag 'ADR-REPO-REPOKIND-NOREPO' {
        $script:session.RunMode | Should -Be 'build'
    }

    It 'loads the consumer module, which needs no repository' -Tag 'ADR-REPO-REPOKIND-NOREPO' {
        $script:session.LocalWidget | Should -Be 'widget-v1'
    }

    It 'lists no tracked path, since there is no index' -Tag 'ADR-REPO-REPOKIND-NOREPO' {
        $script:session.TrackedPath | Should -HaveCount 0
    }

    It 'stops a command that needs git with a message naming it' -Tag 'ADR-REPO-REPOKIND-NOREPO' {
        $script:session.RepoStatus | Should -BeLike 'Get-RepoStatus works on a git work tree*not a git checkout.'
        $script:session.ChangedPath | Should -BeLike 'Get-GitChangedPath works on a git work tree*not a git checkout.'
    }

    It 'runs the quality gates and finds no issue, since no gate finds a tracked file' -Tag 'ADR-REPO-REPOKIND-NOREPO' {
        $script:session.GateOutcome | Should -Be 'issues:0'
    }
}
