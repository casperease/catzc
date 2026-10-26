# infrastructure/templates/discovery/configuration/apex/psub.yml

The discovery configuration for the apex customer's prod subscription (env `psub`, customer `apex`). It deploys a spoke.

The kind and the address ranges come from `network.yml` by config address, so this file carries no copy of the IP plan. The spoke peers to
the prod hub.
