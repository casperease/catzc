Describe 'Invoke-Java' -Tag 'L0', 'logic' {
    It 'builds correct command via -DryRun' {
        Invoke-Java '--version' -DryRun | Should -Be 'java --version'
    }

    It 'builds correct multi-arg command via -DryRun' {
        Invoke-Java '-jar app.jar --port 8080' -DryRun | Should -Be 'java -jar app.jar --port 8080'
    }
}
