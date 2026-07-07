# Get-PipelineTrigger: read a pipeline/workflow YAML's actual trigger path filters (ADR-GLOBS:1) — the
# on-disk side the drift gate compares against the computed projection.
Describe 'Get-PipelineTrigger' -Tag 'L0', 'logic' {
    It 'extracts ADO trigger and pr include/exclude path filters' {
        $script:yaml = @'
trigger:
  branches:
    include: [main]
  paths:
    include:
      - a/**
      - b/**
    exclude:
      - a/gen/**
pr:
  branches:
    include: [main]
  paths:
    include: [a/**, b/**]
    exclude: [a/gen/**]
'@
        Mock Get-Content { $script:yaml } -ModuleName Catzc.Base.Globs
        $t = InModuleScope Catzc.Base.Globs { Get-PipelineTrigger -Path 'x.yaml' -Vendor Ado }
        $t.TriggerInclude | Should -Be @('a/**', 'b/**')
        $t.TriggerExclude | Should -Be @('a/gen/**')
        $t.PrInclude | Should -Be @('a/**', 'b/**')
        $t.PrExclude | Should -Be @('a/gen/**')
    }

    It 'returns empty arrays for absent ADO sections' {
        $script:yaml = @'
trigger:
  paths:
    include: [a/**]
'@
        Mock Get-Content { $script:yaml } -ModuleName Catzc.Base.Globs
        $t = InModuleScope Catzc.Base.Globs { Get-PipelineTrigger -Path 'x.yaml' -Vendor Ado }
        $t.TriggerInclude | Should -Be @('a/**')
        @($t.TriggerExclude).Count | Should -Be 0
        @($t.PrInclude).Count | Should -Be 0
    }

    It 'extracts GitHub push/pr paths despite the YAML 1.1 boolean on: key' {
        $script:yaml = @'
name: CI
on:
  push:
    branches: [main]
    paths: [automation/**]
  pull_request:
    branches: [main]
    paths: [automation/**]
'@
        Mock Get-Content { $script:yaml } -ModuleName Catzc.Base.Globs
        $t = InModuleScope Catzc.Base.Globs { Get-PipelineTrigger -Path 'x.yml' -Vendor GitHub }
        $t.PushPaths | Should -Be @('automation/**')
        $t.PrPaths | Should -Be @('automation/**')
    }
}
