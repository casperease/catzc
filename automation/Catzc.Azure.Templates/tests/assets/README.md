# tests/assets

Test-only fixtures for Catzc.Azure.Templates, packaged alongside the tests that use them. Not shipped and not discovered at runtime — they
exist purely so unit tests own their inputs and never depend on the live `infrastructure/templates/` samples (an edit to a shipped sample
must not break unrelated tests). Nothing here may be named `*.Tests.ps1` — the test runner recurses `tests/`, so a fixture with that suffix
would be collected as a test.

- `config/` — the test-only **identity** fixture (`azure.yml`, `network.yml`). Tests redirect config discovery here by mocking the
  `Resolve-ConfigEntry` seam (in `Catzc.Base.Config`) so it points each name at this fixture:

  ```powershell
  Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network' } -MockWith {
      @{ Name = $Config; Module = 'Catzc.Azure.Templates'; Path = ... tests/assets/config/$Config.yml }
  }
  ```

  `Get-Config` caches by resolved path, so reset its cache first (`InModuleScope Catzc.Base.Config { $script:configCache = $null }`) to load
  the fixture fresh; the fixture and the shipped `configs/azure.yml` never collide. Uses deliberately distinct identities (envs
  `alpha`/`beta`/`gamma`/`delta`, customers `acme`/`globex`, org `tst`) so editing the shipped `azure.yml` can never change a logic-test
  outcome. The shipped assets are validated separately by `tests/Get-Config.Integrity.Tests.ps1`.

- `templates/<name>/` — fixture bicep templates (their configs use the `config/` fixture's envs + customers). Tests redirect discovery here
  with `Mock Get-BicepTemplatesRoot { ... tests/assets/templates } -ModuleName Catzc.Azure.Templates`; the session cache in
  `Get-BicepTemplates` keys on the root, so the fixture tree and the real tree never collide.
- `modules/` — reusable modules the fixture templates reference, so `../../modules/...` resolves within this fixture tree (mirrors
  `infrastructure/modules/`).
- `Get-AzureResourceName.Content.yml` — data-driven cases for `Get-AzureResourceName` (literal inputs; the namer reads no assets).

A bicep/identity unit test should mock **both** seams (`Get-BicepTemplatesRoot` → `tests/assets/templates` and `Resolve-ConfigEntry` →
`tests/assets/config`) so it owns its inputs entirely. Add a new fixture here rather than pointing at `infrastructure/templates/` or the
shipped `assets/`. Tests that must validate the _shipped_ assets belong in `tests/Get-Config.Integrity.Tests.ps1` (which mocks neither
seam).

Full rationale — logic vs integrity tests, isolation via seams, mocking discipline, the gotchas — is the
[`test-automation`](../../../../docs/adr/automation/test-automation.md) ADR.
