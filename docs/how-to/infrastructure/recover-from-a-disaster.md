# Recover from a disaster

A disaster is a loss that the zone redundancy of the production resources does not absorb: a deleted or corrupted database, a lost
subscription, or a region that is down. The recovery rebuilds the infrastructure from the repository and restores the data from its backups.
The targets it must meet, the recovery point and the recovery time per environment class, are stated in
[expedition](../../references/infrastructure/expedition.md#recovery-objectives).

## What comes from where

- **Infrastructure:** every resource is a template in `infrastructure/templates`, so it is redeployed, never repaired by hand.
- **Data:** the SQL database's automated backups: in production geo-redundant and kept 35 days, outside production local and kept 7.
- **Secrets:** they live only in `foundation`'s Key Vault and are seeded again after a vault is rebuilt (see
  [seed a secret](seed-a-secret.md)).

## Recover

1. Open an incident (see [respond to an incident](respond-to-an-incident.md)) and name the loss: one database, one subscription, or a
   region.
2. Redeploy in dependency order, previewing each deploy first with `-DryRun`:
   1. `Deploy-Bicep <environment> foundation`: the Log Analytics workspace and the Key Vault. When the network is lost too, this is the
      bootstrap pass, with `deployKeyVaultPrivateEndpoint: { value: false }` set in the slot's yml until the network is back.
   2. `Deploy-Bicep <environment> discovery`: the hub, then each spoke, with their peering and private DNS zones.
   3. `Deploy-Bicep <environment> foundation` again: the vault's private endpoint, now that the network and the hub's vaultcore zone exist.
      The vault has public network access off from its first deploy, so this is its only way in.
   4. Seed the secrets the rebuilt vault lacks, through its endpoint (see [seed a secret](seed-a-secret.md)).
   5. `Deploy-Bicep <environment> expedition`: the workload's storage account and SQL server, with an empty database; it reads the seeded
      secrets.

   For a region that is down, the environment's `region` in `pwsh/Azure/configs/azure.yml` changes to the paired region first, in one
   reviewed commit.

3. Restore the data. For a deleted or corrupted database, restore it to a point in time before the fault. For a lost region, geo-restore it
   from the geo-redundant backup into the rebuilt server. Then point the workload at the restored database.
4. Check that the service answers, that every resource sends its diagnostics to the workspace, and that the compliance gate
   (`Test-BicepTemplateCompliance`) passes.
5. Record the recovery point reached and the time taken in the incident, against the targets.

## Rehearse it

Rehearse the recovery against a non-production environment, so its steps and its times are known before they are needed.
