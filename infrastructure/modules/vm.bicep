// Reusable bicep module: a Windows virtual machine with its NIC and a dynamic public IP. Takes an
// existing subnet (create the vnet with ../../modules/virtual-network.bicep and pass its subnetId).
// Cheapest SKU by default (Standard_B1s) — this is a PoC VM. `az bicep build` inlines it.

@description('VM name. Also used as the Windows computer name, so keep it <= 15 chars.')
param name string

@description('Network interface name.')
param nicName string

@description('Public IP address name.')
param publicIpName string

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

resource publicIp 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: publicIpName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetId
          }
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: name
  location: location
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
