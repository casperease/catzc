# pwsh/Catzc.Tooling.Toolchain/tests/Update-BatsVendor.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Update-BatsVendor' -Tag 'L0', 'logic' {`, written with `#`.

```text
Update-BatsVendor with the download and tar mocked: the mocked tar lays out a fixture release in the staging folder,
and the vendored folder of a fixture repository in $TestDrive is rebuilt from it. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `$files = @(Get-ChildPath $script:target -File -Depth 64 -Exclude @()...`, written with `#`.

```text
A whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): the vendored
runner is compared file for file, so nothing is pruned.
```
