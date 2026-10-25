# pwsh/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `branch: main`, written with `#`.

```text
Build-validation branch policies tied to globsets — the server-side pre-commit half of a unit's CI
binding ([FDR-CD-TYPE-PRECOMMITBUDGET](/docs/drs/flow/pipeline-types.md#rule-fdr-cd-type-precommitbudget)): each entry binds one DECLARED globset's native
path projection
(Get-GlobSetTrigger,
[FDR-CD-GLOBS](/docs/drs/flow/durable-sha-globs.md)) as the policy's path filter and runs the entry's pipeline as an
ADO build validation on `branch`. Entries are a list (globset names are kebab-case, and snake_case key
validation forbids hyphenated map keys). Per entry: `globset` (required, a declared globset name),
`pipeline` (defaults to the globset's own `pipeline:` annotation in globs.yml), `blocking` (defaults to
true), `display_name` (defaults to 'Build validation - <globset>').

Loaded via Get-Config -Config build-validation (shape-validated by the BuildValidationConfig type); applied
to the server with Sync-AdoBuildValidations / Register-AdoBuildValidation. Globset existence is checked
at runtime (Get-GlobSet throws on an unknown name) and by an integrity test — never at load, so reading
this config stays hermetic (the [ADR-AZ-CUSTOMER-REFERENCENOTVALIDATEDONLOAD](/docs/drs/azure/azure-customer-model.md#rule-adr-az-customer-referencenotvalidatedonload) pattern).
```
