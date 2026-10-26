# pwsh/Tooling.Toolchain/tests/Update-BatsVendor.Tests.ps1

The tests of `Update-BatsVendor` with the download and tar mocked. The mocked tar lays out a fixture release in the staging folder, and the
vendored folder of a fixture repository in `TestDrive` is rebuilt from it. The fixtures carry neutral names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

The vendored runner is compared file for file by a whole-tree walk
([ADR-PWSH-ENUM-ALWAYSBOUNDED](../../../../drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded)), so nothing is pruned.
