# pwsh/Tooling.Provisioning/tests/Install-Zsh.Tests.ps1

The tests of `Install-Zsh` on a fixture Git tree in `TestDrive`. The layout, the tool config, the verified download and the tar extraction
are mocked, so nothing downloads, no process starts and nothing outside `TestDrive` changes
([ADR-AUTO-TEST-NOCLOUDBELOWLTHREE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-nocloudbelowlthree)). The extraction
mock writes a fixture package with neutral names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).

On Linux the shared apt installer is mocked as well: it reads the package name from the entry's `apt_package`, so `Install-Zsh` names only
the tool, and nothing installs and no process starts.
