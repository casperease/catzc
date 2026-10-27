# pwsh/Azure.Templates/Set-AnomalyAlertRecipientSecret.ps1

The command that seeds the anomaly alert's recipients: `discovery`'s `anomalyAlertRecipients` is a `@secure()` parameter every slot reads as
a Key Vault reference to its subscription's `foundation` vault, so the value is written there at deploy time and never kept in the
repository ([parameter contract](../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-parametercontract)). Every discovery job of
`stages/deploy-unit.yaml` runs it before its what-if, from the secret pipeline variable `AnomalyAlertRecipients`.

## help

### synopsis

Writes the anomaly alert's recipients to the secret discovery references, in the session subscription's foundation vault.

### description

Checks the value is comma-separated email addresses, then reads the target from the az session: the subscription, pinned by
`-SubscriptionIdAssertIs` (required in a pipeline), and its customer. The secret's name is the one discovery's configuration for the
environment and customer references; the vault is foundation's, named by the namer, and a reference to another vault is an error. The
trimmed recipients reach the vault through a file deleted right after, by the same writer the break-glass rotation uses, and no message or
error names a recipient.

### parameter `Environment`

Environment shortname whose discovery slot reads the secret.

### parameter `Value`

The recipients, comma-separated email addresses.

### parameter `SubscriptionIdAssertIs`

The subscription id the az session must target; required in a pipeline.

### parameter `DryRun`

Names the vault and the secret the seed would write, and writes nothing.

### example 1

```powershell
Set-AnomalyAlertRecipientSecret nsub -Value 'finops@discovery.example' -DryRun
```

### example 2

```powershell
Set-AnomalyAlertRecipientSecret psub -Value 'finops@discovery.example,platform@discovery.example'
```
