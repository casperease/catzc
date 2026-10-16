<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Objects/tests/types/ArtifactRef.Tests.ps1
    folder: tests/types
    name: artifact-ref-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Objects
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-AUTO-PATH#10
---
#>

Describe 'ArtifactRef' -Tag 'L0', 'logic', 'ADR-AUTO-PATH#10' {
    It 'materializes both forms from a raw absolute path under the artifact root' {
        $artifactRoot = [IO.Path]::GetFullPath((Join-Path ([IO.Path]::GetTempPath()) ('catzc-art-' + [Guid]::NewGuid())))
        $raw = [IO.Path]::GetFullPath((Join-Path $artifactRoot 'main.json'))
        $ref = [Catzc.Base.Objects.ArtifactRef]::Materialize($raw, $artifactRoot)
        $ref.relative | Should -Be 'main.json'
        $ref.absolute | Should -Be $raw
    }

    It 'materializes a nested path relative to the artifact root (forward slashes)' {
        $artifactRoot = [IO.Path]::GetFullPath((Join-Path ([IO.Path]::GetTempPath()) ('catzc-art-' + [Guid]::NewGuid())))
        $ref = [Catzc.Base.Objects.ArtifactRef]::Materialize('resources/policy.json', $artifactRoot)
        $ref.relative | Should -Be 'resources/policy.json'
        $ref.absolute | Should -Be ([IO.Path]::GetFullPath((Join-Path $artifactRoot 'resources/policy.json')))
    }

    It 'throws when the file is not under the artifact root' {
        $artifactRoot = [IO.Path]::GetFullPath((Join-Path ([IO.Path]::GetTempPath()) ('catzc-art-' + [Guid]::NewGuid())))
        $elsewhere = [IO.Path]::GetFullPath((Join-Path ([IO.Path]::GetTempPath()) ('catzc-elsewhere-' + [Guid]::NewGuid() + '/main.json')))
        { [Catzc.Base.Objects.ArtifactRef]::Materialize($elsewhere, $artifactRoot) } | Should -Throw '*under the artifact root*'
    }

    It 're-resolves against a DIFFERENT artifact root (survives the ADO publish rename)' {
        $producerRoot = [IO.Path]::GetFullPath((Join-Path ([IO.Path]::GetTempPath()) ('catzc-build-' + [Guid]::NewGuid())))
        $consumerRoot = [IO.Path]::GetFullPath((Join-Path ([IO.Path]::GetTempPath()) ('catzc-download-' + [Guid]::NewGuid())))
        $ref = [Catzc.Base.Objects.ArtifactRef]::Materialize((Join-Path $producerRoot 'main.json'), $producerRoot)
        $ref.ResolveAt($consumerRoot) | Should -Be ([IO.Path]::GetFullPath((Join-Path $consumerRoot 'main.json')))
    }

    It 'rehydrates from the (relative, absolute) constructor and round-trips' {
        $ref = [Catzc.Base.Objects.ArtifactRef]::new('main.json', 'C:/build/out/template/sample/main.json')
        $ref.relative | Should -Be 'main.json'
        "$ref" | Should -Be 'main.json'
    }

    It 'rejects a rooted (non-artifact-relative) relative form' {
        { [Catzc.Base.Objects.ArtifactRef]::new('C:/somewhere/main.json', 'C:/x') } | Should -Throw '*artifact-relative*'
        { [Catzc.Base.Objects.ArtifactRef]::new('/abs/main.json', 'C:/x') } | Should -Throw '*artifact-relative*'
    }

    It 'rejects a relative form that escapes the artifact root' {
        { [Catzc.Base.Objects.ArtifactRef]::new('../outside/main.json', 'C:/x') } | Should -Throw '*within the artifact root*'
    }

    It 'verifies existence at the consumer root' {
        $consumerRoot = [IO.Path]::GetFullPath((Join-Path ([IO.Path]::GetTempPath()) ('catzc-download-' + [Guid]::NewGuid())))
        New-Item -ItemType Directory -Path $consumerRoot -Force | Out-Null
        Set-Content -Path (Join-Path $consumerRoot 'main.json') -Value '{}' -Encoding utf8
        try {
            $ref = [Catzc.Base.Objects.ArtifactRef]::new('main.json', 'C:/build/out/template/sample/main.json')
            $ref.ExistsAt($consumerRoot) | Should -BeTrue
            $ref.ExistsAt([IO.Path]::GetFullPath((Join-Path ([IO.Path]::GetTempPath()) ('catzc-empty-' + [Guid]::NewGuid())))) | Should -BeFalse
        }
        finally {
            Remove-Item $consumerRoot -Recurse -Force -ErrorAction Ignore
        }
    }

    It 'serializes both forms to JSON (and no methods)' {
        $ref = [Catzc.Base.Objects.ArtifactRef]::new('parameters.dev.json', 'C:/build/out/template/sample/parameters.dev.json')
        $round = $ref | ConvertTo-Json | ConvertFrom-Json
        $round.relative | Should -Be 'parameters.dev.json'
        $round.absolute | Should -Be 'C:/build/out/template/sample/parameters.dev.json'
    }
}
