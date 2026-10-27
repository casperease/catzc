# Seed a secret

The repository holds no secret. A template that needs one, such as `expedition`'s break-glass SQL password, reads it from `foundation`'s Key
Vault through a Key Vault reference in its parameter file, so the secret must be in the vault before that template deploys
([expedition](../../references/infrastructure/expedition.md)). Seeding writes it there once: after a new vault is deployed, after a vault is
rebuilt, and when a secret is rotated.

## Seed it

1. Deploy the vault and its way in, in this order: `foundation`, then `discovery`, then `foundation` again. The first `foundation` deploy is
   the bootstrap pass: the slot's yml sets `deployKeyVaultPrivateEndpoint: { value: false }` for it, since the network the endpoint lands in
   does not exist yet, and the override is removed for the second pass, which places the endpoint under its derived names. The vault has
   public network access off from its first deploy, and it is reachable only once the second `foundation` deploy has placed its private
   endpoint in the network `discovery` built, so a secret is seeded only after that second deploy, from inside the network, through the
   endpoint.
2. Sign in as a principal that holds the `Key Vault Secrets Officer` role on that vault. The vault uses Azure role-based access, not access
   policies, so no other right writes a secret.
3. Generate the value with a password generator outside the repository, never in a script that is committed or in a shell history file.
4. Write it under the name the consuming template's configuration names, for `expedition` `exped-sql-admin-password`, and for `discovery`
   `disco-anomaly-recipients`, the anomaly alert's email recipients, comma-separated, which the pipeline setup seeds from its variable:

   ```powershell
   $value = Read-Host -AsSecureString 'secret value'
   Set-AzKeyVaultSecret -VaultName <vault> -Name exped-sql-admin-password -SecretValue $value
   ```

5. Deploy the consuming template. Its preview with `-DryRun` resolves the reference, so a missing or misnamed secret stops it there.

## Keep it safe

- A seeded value is never written back into the repository, a pipeline variable, or a log.
- Rotating a secret is a new seed of the same name, followed by a deploy of every template that reads it.
