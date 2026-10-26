Describe 'ConvertFrom-NodeTestJunit' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:folder = Join-Path $TestDrive 'tests'
        $script:convert = {
            param([string] $Body)
            InModuleScope Catzc.Base.Languages -Parameters @{ Text = "<testsuites><testsuite>$Body</testsuite></testsuites>"; Folder = $script:folder } {
                param($Text, $Folder)
                ConvertFrom-NodeTestJunit -Text $Text -Folder $Folder
            }
        }
        $script:file = { param([string] $Relative) (Join-Path $script:folder $Relative) }
    }

    It 'reads each case as a result named by its file inside the folder, with its outcome, time and message' {
        $body = "<testcase name=`"spins`" time=`"0.25`" file=`"$(& $script:file 'spin.test.js')`"/>" +
        "<testcase name=`"stalls`" time=`"0.5`" file=`"$(& $script:file 'nested/stall.test.js')`"><failure message=`"widget stuck`">at stall</failure></testcase>" +
        "<testcase name=`"integrity: ships`" time=`"0`" file=`"$(& $script:file 'spin.test.js')`"><skipped message=`"no package`"/></testcase>"
        $results = @(& $script:convert $body)
        $results.ForEach({ "$($_.Package)|$($_.Name)|$($_.Outcome)" }) | Should -Be @('spin.test.js|spins|pass',
            'nested/stall.test.js|stalls|fail', 'spin.test.js|integrity: ships|skip')
        $results[0].DurationSeconds | Should -Be 0.25
        $results[1].Output | Should -Be "widget stuck`nat stall"
        $results[2].Category | Should -Be 'integrity'
    }

    It 'returns nothing for an empty report' {
        @(& $script:convert '' | Where-Object { $_ }) | Should -HaveCount 0
        InModuleScope Catzc.Base.Languages { @(ConvertFrom-NodeTestJunit -Text '  ' -Folder 'x') } | Should -HaveCount 0
    }

    It 'refuses a failure outside any test file: node failing around the tests' {
        { & $script:convert "<testcase name=`"widget.js`" file=`"$(& $script:file 'widget.js')`"><failure message=`"cannot load`"/></testcase>" } | Should -Throw '*outside any test*'
    }
}
