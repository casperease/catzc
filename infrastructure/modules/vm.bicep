@description('VM name. Also used as the Windows computer name, so keep it <= 15 chars.')
param name string

@description('Network interface name.')
param nicName string

@description('Resource id of the subnet the NIC attaches to.')
param subnetId string

@description('Azure region. Defaults to the enclosing resource group location.')
param location string = resourceGroup().location

@description('Local administrator username.')
param adminUsername string

@description('Local administrator password (supplied from the foundation Key Vault).')
@secure()
param adminPassword string

@description('VM size. Standard_B1s is the cheapest burstable size.')
param vmSize string = 'Standard_B1s'

@description('Resource tags.')
param tags object = {}

// The VM has no public IP: it is reached through the network, and its egress leaves through the hub firewall.
resource nic 'Microsoft.Network/networkInterfaces@2024-05-01' = {
  name: nicName
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetId
          }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: name
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

output id string = vm.id
output name string = vm.name
