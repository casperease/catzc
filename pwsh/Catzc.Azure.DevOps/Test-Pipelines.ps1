function Test-Pipelines {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
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

        if ($extension -eq '.yml') {
            $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPE-NAME-EXECUTABLEYAMLEXTENSION' -Message "Executable pipeline YAML must be '.yaml', not '.yml'."))
            continue
        }

        if ($segments.Count -eq 0) {
            $prefix = ($name -split '-', 2)[0]
            if ($prefix -notin $typePrefixes) {
                $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPE-NAME-TYPEPREFIX' -Message "Pipeline name must start with a type ($($typePrefixes -join ' | ')); got '$prefix'."))
            }
        }
        else {
            if ($topFolder -notin $templateFolders) {
                $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPE-NAME-TEMPLATEKINDFOLDER' -Message "Template folder '$topFolder' is not one of: $($templateFolders -join ' | ')."))
            }
            elseif ($segments.Count -gt 1) {
                $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPE-NAME-FLATPIPELINESFOLDER' -Message "Templates live directly in '$topFolder/', not nested deeper ('$dir/')."))
            }
            else {
                if ($record.Classification -eq 'Pipeline') {
                    $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPE-NAME-FLATPIPELINESFOLDER' -Message "A pipeline (trigger/pr/… shape) must live flat in pipelines/, not inside '$topFolder/'."))
                }
                elseif ($folderKind.ContainsKey($topFolder) -and $record.TemplateType -and "$($record.TemplateType)" -ne $folderKind[$topFolder]) {
                    $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPE-NAME-TEMPLATEKINDFOLDER' -Message "A '$($record.TemplateType)' template does not belong in '$topFolder/' (expected $($folderKind[$topFolder]))."))
                }
            }
        }

        foreach ($ref in (Get-PipelineTemplateReference -Path $record.Path)) {
            if ($ref -notmatch '^/pipelines/') {
                $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPE-NAME-ABSOLUTETEMPLATEPATH' -Message "Template reference '$ref' must be an absolute path starting with /pipelines/."))
            }
        }
    }

    Write-QualityGateReport -Subject pipelines -Title Test-Pipelines -Issues $violations.ToArray() `
        -Facts ([ordered]@{ Files = $records.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
