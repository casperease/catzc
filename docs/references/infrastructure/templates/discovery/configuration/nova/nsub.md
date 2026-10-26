# infrastructure/templates/discovery/configuration/nova/nsub.yml

The discovery configuration for the nova customer's nonprod subscription (env `nsub`, customer `nova`). It deploys a spoke.

The kind and the address ranges come from `network.yml` by config address. The spoke peers to the nonprod hub. The nova customer is
dev-only, so it has a nonprod configuration and no prod one.
