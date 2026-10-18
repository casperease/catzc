# automation/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the subscriptions a config coordinate (customer?, environment) can resolve to.

### description

The single implementation of the configuration-tree resolution rule ([ADR-AZ-DATAMOD](../../../../adr/azure/azure-data-model.md)): a config
at the configuration/ ROOT (empty -Customer) is served by the NON-customer subscriptions serving its environment; a config under
`configuration/<customer>/` is served by that customer's subscriptions serving it (the subscription's raw customer token — key or shortcode
— is normalized against the folder's customer key). A conforming azure.yml yields exactly one candidate; callers assert that
(Get-BicepSubscriptionConfigViolations for the violation text, discovery for the resolved name) so the rule cannot drift between them.

### parameter `Customer`

The configuration subfolder name (a customer key), or '' for a configuration-root config.

### parameter `Environment`

The config's resolved environment name.

### parameter `AzureConfig`

The loaded azure config (Get-Config -Config azure).

## comment:1

Above `if ($token -ceq $Customer -or (Get-AzureCustomer $token).key -ceq $Customer) {`, written with `#`.

```text
Customer config: match the raw token first (the common, by-key binding), and only resolve a
non-matching token through the catalogue (the by-shortcode binding) — keeps the read lazy.
```
