<#
.SYNOPSIS
    Quality gate: checks the pipelines/ tree against the naming-and-placement contract
    ([ADR-PIPE-NAME](/docs/adr/pipelines/pipeline-naming-and-placement.md)).
.DESCRIPTION
    A file that fails to parse is reported as a violation, so a broken pipeline cannot slip through silently.
    [ADR-PIPE-NAME](/docs/adr/pipelines/pipeline-naming-and-placement.md),
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35),
    [ADR-PIPE-NAME#6](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name6),
    [ADR-PIPE-NAME#2](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name2),
    [ADR-PIPE-NAME#3](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name3),
    [ADR-PIPE-NAME#1](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name1),
    [ADR-PIPE-NAME#4](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name4),
    [ADR-PIPE-NAME#7](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name7)
    [comment:1](/docs/references/automation/catzc-azure-devops/Test-Pipelines.ps1.md#comment1)
.PARAMETER Path
    The pipelines/ directory to check. Defaults to `<repo>/pipelines`.
.PARAMETER OutputFolder
    The report base folder. Defaults to Write-QualityGateReport's (out/test-pipelines).
.PARAMETER PassThru
    Return the gate result { Subject; IssueCount; Issues; ReportPath; Files } instead of throwing on violations.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-Pipelines
.EXAMPLE
    (Test-Pipelines -PassThru).Issues
#>
function Test-Pipelines {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $Path,

        [string] $OutputFolder,

        [switch] $PassThru
    )

    $pipelinesRoot = if ($Path) {
        $Path
    }
    else {
        Join-Path (Get-RepositoryRoot) 'pipelines'
    }
    Assert-PathExist $pipelinesRoot -PathType Container

    $typePrefixes = @('cron', 'ci', 'cd', 'cde', 'deploy', 'input')
    $templateFolders = @('steps', 'jobs', 'stages', 'variables', 'extends')
    # The structural kind we expect a fragment folder to hold (extends/ is whole-pipeline — any body).
    $folderKind = @{ steps = 'Steps'; jobs = 'Jobs'; stages = 'Stages'; variables = 'Variables' }

    $records = @(Get-AdoYamlFiles -Path $pipelinesRoot)
    $violations = [System.Collections.Generic.List[string]]::new()

    function New-Violation {
        param($RelativePath, $Rule, $Message)
        "[$Rule] pipelines/${RelativePath}: $Message"
    }

    foreach ($record in $records) {
        $rel = $record.RelativePath
        $dir = ($record.RelativeDirectory -replace '\\', '/').Trim('/')
        $name = Split-Path $rel -Leaf
        $extension = [System.IO.Path]::GetExtension($name).ToLowerInvariant()
        $segments = @()
        if ($dir) {
            $segments = @($dir -split '/')
        }
        $topFolder = if ($segments.Count -ge 1) {
            $segments[0]
        }
        else {
            ''
        }

        # A parse failure is itself a violation — a pipeline that ADO cannot read is not compliant.
        if ($record.ParseError) {
            $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPE-NAME:parse' -Message "YAML failed to parse: $($record.ParseError)"))
            continue
        }

        # Config is .yml but lives outside pipelines/, so any .yml in here is a misplaced or misnamed file.
        # [ADR-PIPE-NAME#6](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name6)
        # [comment:2](/docs/references/automation/catzc-azure-devops/Test-Pipelines.ps1.md#comment2)
        if ($extension -eq '.yml') {
            $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPE-NAME#6' -Message "Executable pipeline YAML must be '.yaml', not '.yml'."))
            continue
        }

        if ($segments.Count -eq 0) {
            # A root file is a pipeline entry point, so its name must start with a type token.
            # [ADR-PIPE-NAME#1](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name1)
            # [comment:3](/docs/references/automation/catzc-azure-devops/Test-Pipelines.ps1.md#comment3)
            $prefix = ($name -split '-', 2)[0]
            if ($prefix -notin $typePrefixes) {
                $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPE-NAME#1' -Message "Pipeline name must start with a type ($($typePrefixes -join ' | ')); got '$prefix'."))
            }
        }
        else {
            # A subfolder holds templates only, in a per-kind folder and never nested deeper than one level.
            # [ADR-PIPE-NAME#3](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name3)
            # [comment:4](/docs/references/automation/catzc-azure-devops/Test-Pipelines.ps1.md#comment4)
            if ($topFolder -notin $templateFolders) {
                $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPE-NAME#3' -Message "Template folder '$topFolder' is not one of: $($templateFolders -join ' | ')."))
            }
            elseif ($segments.Count -gt 1) {
                $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPE-NAME#2' -Message "Templates live directly in '$topFolder/', not nested deeper ('$dir/')."))
            }
            else {
                # A file with a pipeline shape belongs flat at the root, never inside a template folder.
                # [ADR-PIPE-NAME#2](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name2)
                # [comment:5](/docs/references/automation/catzc-azure-devops/Test-Pipelines.ps1.md#comment5)
                if ($record.Classification -eq 'Pipeline') {
                    $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPE-NAME#2' -Message "A pipeline (trigger/pr/… shape) must live flat in pipelines/, not inside '$topFolder/'."))
                }
                # A fragment's folder must name its structural kind; only extends/ is exempt from this match.
                # [ADR-PIPE-NAME#3](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name3)
                # [comment:6](/docs/references/automation/catzc-azure-devops/Test-Pipelines.ps1.md#comment6)
                elseif ($folderKind.ContainsKey($topFolder) -and $record.TemplateType -and "$($record.TemplateType)" -ne $folderKind[$topFolder]) {
                    $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPE-NAME#3' -Message "A '$($record.TemplateType)' template does not belong in '$topFolder/' (expected $($folderKind[$topFolder]))."))
                }
            }
        }

        # An absolute reference stays valid wherever the referring file sits, which a relative one does not.
        # [ADR-PIPE-NAME#4](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name4)
        # [comment:7](/docs/references/automation/catzc-azure-devops/Test-Pipelines.ps1.md#comment7)
        foreach ($ref in (Get-PipelineTemplateReference -Path $record.Path)) {
            if ($ref -notmatch '^/pipelines/') {
                $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPE-NAME#4' -Message "Template reference '$ref' must be an absolute path starting with /pipelines/."))
            }
        }
    }

    Write-QualityGateReport -Subject pipelines -Title Test-Pipelines -Issues $violations.ToArray() `
        -Facts ([ordered]@{ Files = $records.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
