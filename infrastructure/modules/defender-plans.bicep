targetScope = 'subscription'

@description('Defender for Cloud plans to turn on, one per service in use; a plan not listed stays on the free tier.')
@allowed([
  'StorageAccounts'
  'SqlServers'
  'KeyVaults'
  'VirtualMachines'
  'Arm'
])
param plans array = [
  'StorageAccounts'
  'SqlServers'
  'KeyVaults'
  'Arm'
]

// Each plan is a subscription-level pricing on the Standard tier; the plans deploy one after another, as the pricing API allows one change at a time.
@batchSize(1)
resource pricing 'Microsoft.Security/pricings@2024-01-01' = [
  for plan in plans: {
    name: plan
    properties: {
      pricingTier: 'Standard'
    }
  }
]

output plans array = plans
