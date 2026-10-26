<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-types-system/Build-AgentHook.ps1.md"
  header: "generated"
---
#>

function Build-AgentHook {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Position = 0)]
        [string[]] $Name = (Get-AgentHookName),

        [string] $OutputDirectory = (Join-Path (Get-RepositoryRoot) '.claude/hooks/bin'),

        [switch] $Force,

        [switch] $ListStale
    )

    Assert-SourceTree

    $hooks = Join-Path (Get-RepositoryRoot) '.claude/hooks'

    foreach ($hook in $Name) {
        $project = Join-Path $hooks $hook
        Assert-PathExist $project -PathType Container

        $csproj = Join-Path $project "$hook.csproj"
        Assert-PathExist $csproj
        $projectXml = [xml](Get-Content -LiteralPath $csproj -Raw)
        Assert-NotNull $projectXml.DocumentElement -ErrorText "No <Project> element in $csproj."

        # Linked module types count as sources too, so a change to a type the hook compiles in republishes the hook.
        $sources = @(Get-ChildPath $project -File -Filter '*.cs',
            '*.csproj' -Depth 1 | Sort-Object { [System.IO.Path]::GetFileName($_) })
        Assert-True ($sources.Count -gt 0) -ErrorText "No hook files (*.cs, *.csproj) in $project"
        $modulesFolder = Get-CatzcModulesFolder
        $linked = @($projectXml.SelectNodes('//Compile/@Include') | ForEach-Object { $_.Value.Replace('$(CatzcModulesFolder)', $modulesFolder) } | Sort-Object)
        $hashLines = @($sources | ForEach-Object { "$([System.IO.Path]::GetFileName($_)):$((Get-FileHash -LiteralPath $_ -Algorithm SHA256).Hash)" })
        foreach ($include in $linked) {
            $linkedPath = Join-Path $project $include
            Assert-PathExist $linkedPath -PathType Leaf
            $hashLines += "$($include):$((Get-FileHash -LiteralPath $linkedPath -Algorithm SHA256).Hash)"
        }
        $sourceHash = $hashLines -join "`n"

        # The program is found by its AssemblyName as an application, never by a guessed platform suffix.
        $assemblyName = $projectXml.Project.PropertyGroup.AssemblyName | Where-Object { $_ } | Select-Object -First 1
        Assert-NotNullOrWhitespace $assemblyName -ErrorText "No <AssemblyName> in $csproj — it names the published hook program."
        $programBase = Join-Path $OutputDirectory $assemblyName
        $findProgram = {
            $application = Get-Command -Name $programBase -CommandType Application -ErrorAction Ignore |
                Select-Object -First 1
            if ($application) {
                $application.Source
            }
        }

        $stamp = Join-Path $OutputDirectory "$assemblyName.source.sha256"
        $program = & $findProgram
        $isCurrent = $program -and (Test-Path -LiteralPath $stamp) -and ((Get-Content -LiteralPath $stamp -Raw).Trim() -ceq $sourceHash.Trim())
        if ($ListStale) {
            if (-not $isCurrent) {
                $hook
            }
            continue
        }
        if ($isCurrent -and -not $Force) {
            $program
            continue
        }

        Assert-Command dotnet -ErrorText 'dotnet is not on PATH. Install the .NET SDK (Install-Dotnet), then re-run Build-AgentHook.'

        $configuration = (Get-Config -Config bcl).configuration
        Assert-DotnetOffline $csproj
        Invoke-Executable "dotnet publish `"$csproj`" --configuration $configuration --output `"$OutputDirectory`" --verbosity quiet --disable-build-servers -p:CatzcModulesFolder=$modulesFolder" -Silent
        $program = & $findProgram
        Assert-NotNullOrWhitespace $program -ErrorText "dotnet publish succeeded but produced no runnable '$assemblyName' program in $OutputDirectory."
        Set-Content -LiteralPath $stamp -Value $sourceHash -NoNewline
        Write-Message "Agent hook: published $assemblyName to $program"

        $program
    }
}
