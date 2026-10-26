# infrastructure/templates/discovery/configuration/apex/nsub.yml

The discovery configuration for the apex customer's nonprod subscription (env `nsub`, customer `apex`). It deploys a spoke.

The kind and the address ranges come from `network.yml` by config address, so this file carries no copy of the IP plan. The spoke peers to
the nonprod hub.
