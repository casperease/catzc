# pwsh/Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1

The private function that returns the subscriptions a config coordinate, a customer (optional) and an environment, can resolve to. A root
config has only the non-customer subscriptions as candidates.

## help

### synopsis

Returns the subscriptions a config coordinate (customer?, environment) can resolve to.

### description

The single implementation of the configuration-tree resolution rule ([ADR-AZ-DATAMOD](../../../../drs/azure/azure-data-model.md)): a config
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

## Customer matching

For a customer config the raw token is matched first, the common by-key binding. Only a non-matching token is resolved through the
customer catalogue, the by-shortcode binding, which keeps the catalogue read lazy.
