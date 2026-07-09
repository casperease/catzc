# The reference-commit resolver (ADR-FLOW-CD-DETECT): the diff range per execution context — local working tree,
# post-commit first-parent (squash-proof), or the PR merge-base — with a fail-open null.
Describe 'Get-GlobSetChangeRange' -Tag 'L0', 'logic' {
    BeforeEach {
        # A clean, deterministic env regardless of where the suite runs (a real pipeline sets some of these).
        $env:SYSTEM_PULLREQUEST_PULLREQUESTID = $null
        $env:SYSTEM_PULLREQUEST_TARGETBRANCH = $null
        $env:GITHUB_EVENT_NAME = $null
        $env:GITHUB_BASE_REF = $null
    }
    AfterEach {
        $env:SYSTEM_PULLREQUEST_PULLREQUESTID = $null
        $env:SYSTEM_PULLREQUEST_TARGETBRANCH = $null
        $env:GITHUB_EVENT_NAME = $null
        $env:GITHUB_BASE_REF = $null
    }

    It 'returns the working-tree range locally (not in a pipeline)' {
        Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Base.Globs
        Get-GlobSetChangeRange | Should -Be 'HEAD'
    }

    It 'returns the first-parent range for a post-commit push to main' {
        Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Base.Globs
        Get-GlobSetChangeRange | Should -Be 'HEAD^1..HEAD'
    }

    It 'returns the merge-base range for an ADO pull-request build (refs/heads/ stripped)' {
        Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Base.Globs
        $env:SYSTEM_PULLREQUEST_PULLREQUESTID = '42'
        $env:SYSTEM_PULLREQUEST_TARGETBRANCH = 'refs/heads/main'
        Get-GlobSetChangeRange | Should -Be 'origin/main...HEAD'
    }

    It 'returns the merge-base range for a GitHub pull_request build' {
        Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Base.Globs
        $env:GITHUB_EVENT_NAME = 'pull_request'
        $env:GITHUB_BASE_REF = 'main'
        Get-GlobSetChangeRange | Should -Be 'origin/main...HEAD'
    }

    It 'fails open (null) for a pull request with no resolvable target' {
        Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Base.Globs
        $env:SYSTEM_PULLREQUEST_PULLREQUESTID = '42'
        Get-GlobSetChangeRange | Should -BeNullOrEmpty
    }
}
