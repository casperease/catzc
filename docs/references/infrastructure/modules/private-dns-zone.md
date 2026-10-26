# infrastructure/modules/private-dns-zone.bicep

The reusable module for a private DNS zone (for example `privatelink.blob.core.windows.net`) with a virtual network link to each listed
network.

## Links

The linked networks may live in other subscriptions. The hub owns the zones and links them to every spoke, so a private endpoint registered
in a zone resolves from any linked network. Each link is named after its network.

## Use

`az bicep build` inlines the module into the template that references it.
