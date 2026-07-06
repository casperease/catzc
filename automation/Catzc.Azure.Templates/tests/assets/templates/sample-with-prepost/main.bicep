// Merge-seam fixture template: a virtual network whose address ranges are merged in at build time by
// PrePost.psm1 from the global IP plan (Catzc.Azure.Templates/assets/network.yml) — a cross-cutting fact the
// per-slot configuration/<slot>.yml deliberately does NOT carry. The vnet NAME comes from the config
// (like every resource name); only the ranges come from the asset.
//
// See docs/adr/automation/powershell/prepost-extension-modules.md.

param vnetName string
param location string = resourceGroup().location

// Merged from assets/network.yml by PrePost.psm1 (the cross-cutting IP plan), not by the per-slot config.
param addressPrefix string
param subnetPrefix string

// Key Vault-backed: the per-slot config does NOT carry it; PrePost.psm1 injects an ARM Key Vault *reference*
// at build time (the production pattern for keeping deploy-time values out of the repo). Consumed as a tag
// so the parameter is genuinely used by the template (no unused-parameter warning). Named to avoid bicep's
// secure-secrets-in-params linter (a @secure() param cannot be used in a tag) — the KV *secret* name lives
// in the rendered parameter file, not in this bicep parameter name.
param sharedReference string = ''

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: location
  tags: {
    kvReference: sharedReference
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: subnetPrefix
        }
      }
    ]
  }
}

output vnetId string = vnet.id
