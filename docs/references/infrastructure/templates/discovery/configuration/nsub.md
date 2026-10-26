# infrastructure/templates/discovery/configuration/nsub.yml

The discovery configuration for the shared nonprod subscription (env `nsub`). It deploys the nonprod hub.

The kind and the address ranges come from `network.yml` by config address. The hub peers to the nonprod spokes and links its private DNS
zones to them.
