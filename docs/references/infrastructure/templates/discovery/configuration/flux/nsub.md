# infrastructure/templates/discovery/configuration/flux/nsub.yml

The discovery configuration for the flux customer's nonprod subscription (env `nsub`, customer `flux`). It deploys a spoke.

The kind and the address ranges come from `network.yml` by config address. The spoke peers to the nonprod hub. The flux customer is
dev-only, so it has a nonprod configuration and no prod one.
