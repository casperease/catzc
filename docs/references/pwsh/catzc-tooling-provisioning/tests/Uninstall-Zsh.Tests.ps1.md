# pwsh/Tooling.Provisioning/tests/Uninstall-Zsh.Tests.ps1

The tests of `Uninstall-Zsh` on a fixture Git tree in `TestDrive` with the layout mocked, so nothing outside `TestDrive` changes
([ADR-AUTO-TEST-NOCLOUDBELOWLTHREE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-nocloudbelowlthree)). The fixtures carry
neutral names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

On Linux the shared apt uninstaller is mocked: it reads the package name from the entry's `apt_package` and owns the presence check and the
root assert, so nothing is removed and no process starts.
