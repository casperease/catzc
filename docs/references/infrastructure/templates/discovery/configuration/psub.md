# infrastructure/templates/discovery/configuration/psub.yml

The discovery configuration for the shared prod subscription (env `psub`). It deploys the prod hub.

The kind and the address ranges come from `network.yml` by config address. The hub peers to the prod spokes and links its private DNS zones
to them.
