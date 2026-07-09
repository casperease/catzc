# Poka-yoke backstop: no <token>-shaped text in a non-data-driven test title.
#
# Pester treats <word> in an It/Describe/Context title as its name-template syntax and re-evaluates the title
# as "$($word)" in the test's scope at name-expansion time. With -ForEach/-TestCases data that is the
# intended feature; WITHOUT data the token is almost always prose (e.g. "configs/<name>.yml") — it silently
# expands to empty in a non-strict scope and THROWS ("the variable '$word' cannot be retrieved") in a strict
# one. The suite runs without strict mode under the harness (ADR-AUTO-TEST:25), so such a title is a trap that
# only fires when someone runs the file by hand from a strict importer session — the worst place to discover
# it. This gate bans the pattern outright: a title with a <token> must carry -ForEach data.
# (These titles themselves spell out "angle-bracket token" — a literal one here would fire the very trap.)
Describe 'Test titles use angle-bracket templates only on data-driven tests' -Tag 'L1', 'integrity' {
    It 'finds no template-shaped token in a title without -ForEach data' {
        $automation = Join-Path $env:RepositoryRoot 'automation'
        $testFiles = @([System.IO.Directory]::GetFiles($automation, '*.Tests.ps1', [System.IO.SearchOption]::AllDirectories) |
                Where-Object { $_ -notmatch '[\\/]\.vendor[\\/]' })

        $violations = [System.Collections.Generic.List[string]]::new()
        foreach ($file in $testFiles) {
            $parseErrors = $null
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($file, [ref] $null, [ref] $parseErrors)
            if ($parseErrors) {
                continue   # unparseable files are another gate's problem
            }

            # Every It/Describe/Context call whose title literal carries a <word> token.
            $calls = $ast.FindAll({
                    param($node)
                    $node -is [System.Management.Automation.Language.CommandAst] -and
                    $node.GetCommandName() -in 'It', 'Describe', 'Context'
                }, $true)

            foreach ($call in $calls) {
                $title = $call.CommandElements |
                    Where-Object { $_ -is [System.Management.Automation.Language.StringConstantExpressionAst] } |
                    Select-Object -First 1
                if (-not $title -or $title.Value -notmatch '<\w+>') {
                    continue
                }

                # Data-driven titles legitimately use the template syntax.
                $hasData = @($call.CommandElements | Where-Object {
                        $_ -is [System.Management.Automation.Language.CommandParameterAst] -and
                        $_.ParameterName -in 'ForEach', 'TestCases'
                    }).Count -gt 0
                if ($hasData) {
                    continue
                }

                $relative = $file.Substring($env:RepositoryRoot.Length + 1) -replace '\\', '/'
                $violations.Add("$relative`: $($call.GetCommandName()) '$($title.Value)'")
            }
        }

        $violations | Should -HaveCount 0 -Because (
            'a <token> in a test title is Pester template syntax and throws under a strict caller when the test has no data — ' +
            "rephrase the title (or add -ForEach): $($violations -join '; ')")
    }
}
