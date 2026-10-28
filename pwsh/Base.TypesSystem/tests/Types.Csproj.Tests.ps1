Describe 'Catzc.Types.csproj — editor build stamps, never warns on loaded types' -Tag 'L1', 'integrity' {
    BeforeAll {
        $modulesRoot = Get-CatzcModulesRoot
        $template = [xml][System.IO.File]::ReadAllText((Join-Path $modulesRoot 'Base.TypesSystem/assets/Catzc.Types.csproj.xml'))
        $target = $template.SelectSingleNode("//Target[@Name='StampCatzcTypesVersionFromSources']")
        $script:steps = $target.SelectNodes('Exec | Error | PropertyGroup[CatzcTypesHash] | Warning')
        # The stamp locates the loader from the project's own folder; the project sits in TestDrive, so that folder is a property here.
        $body = ($script:steps | ForEach-Object { $_.OuterXml }) -join ''
        $body = $body.Replace('$(MSBuildProjectDirectory)', '$(CatzcAssets)')
        $body += '<Message Importance="high" Text="stamp=$(CatzcTypesHash)" />'
        $script:project = Join-Path $TestDrive 'Check.proj'
        [System.IO.File]::WriteAllText($script:project, "<Project><Target Name=`"Check`">$body</Target></Project>")
        $script:assets = Join-Path $modulesRoot '.internal/assets'
        $script:shadow = Join-Path $TestDrive 'shadow'
        $script:saved = @{ LOCALAPPDATA = $env:LOCALAPPDATA; HOME = $env:HOME }
        $env:LOCALAPPDATA = $script:shadow
        $env:HOME = $script:shadow
        $script:types = if ($IsWindows) {
            Join-Path $script:shadow 'catzc/types'
        }
        else {
            Join-Path $script:shadow '.local/share/catzc/types'
        }
        [void][System.IO.Directory]::CreateDirectory($script:types)

        function script:Invoke-Check {
            & dotnet msbuild $script:project -t:Check -nologo "-p:CatzcAssets=$script:assets" 2>&1 | Out-String
        }
    }

    AfterAll {
        $env:LOCALAPPDATA = $script:saved.LOCALAPPDATA
        $env:HOME = $script:saved.HOME
    }

    It 'lifts the stamp and the version from the template, and no warning' {
        $script:steps.Count | Should -Be 3
        @($script:steps | Where-Object { $_.LocalName -eq 'Warning' }).Count | Should -Be 0
    }

    It 'stamps the source hash and stays silent when only an older-hash DLL is in the shadow root' {
        [System.IO.File]::WriteAllText((Join-Path $script:types 'Catzc.Types.old999.dll'), '')
        $output = Invoke-Check
        $output | Should -Match 'stamp=\w+' -Because $output
        $output | Should -Not -Match 'warning'
    }
}
