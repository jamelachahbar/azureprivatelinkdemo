param virtualNetworks_hub_vnet_name string = 'hub-vnet'
param virtualMachines_az_dns_vm_name string = 'az-dns-vm'
param virtualMachines_az_mgmt_vm_name string = 'az-mgmt-vm'
param virtualNetworks_spoke_vnet_name string = 'spoke-vnet'
param connections_hub_onprem_conn_name string = 'hub-onprem-conn'
param connections_onprem_hub_conn_name string = 'onprem-hub-conn'
param virtualNetworks_onprem_vnet_name string = 'onprem-vnet'
param networkInterfaces_az_dns_nic_name string = 'az-dns-nic'
param virtualMachines_onprem_dns_vm_name string = 'onprem-dns-vm'
param bastionHosts_hub_bastion_host_name string = 'hub-bastion-host'
param networkInterfaces_az_mgmt_nic_name string = 'az-mgmt-nic'
param virtualMachines_onprem_mgmt_vm_name string = 'onprem-mgmt-vm'
param bastionHosts_onprem_bastion_host_name string = 'onprem-bastion-host'
param networkInterfaces_onprem_dns_nic_name string = 'onprem-dns-nic'
param networkInterfaces_onprem_mgmt_nic_name string = 'onprem-mgmt-nic'
param publicIPAddresses_hub_bastion_pip_name string = 'hub-bastion-pip'
param storageAccounts_stgmicrohackfiles_name string = 'stgazprivatelink'
param publicIPAddresses_onprem_bastion_pip_name string = 'onprem-bastion-pip'
param publicIPAddresses_hub_vpn_gateway_pip_name string = 'hub-vpn-gateway-pip'
param virtualNetworkGateways_hub_vpn_gateway_name string = 'hub-vpn-gateway'
param publicIPAddresses_onprem_vpn_gateway_pip_name string = 'onprem-vpn-gateway-pip'
param virtualNetworkGateways_onprem_vpn_gateway_name string = 'onprem-vpn-gateway'

@description('description')
@secure()
param adminPwd string

@description('description')
@secure()
param preSharedKey string

resource publicIPAddresses_hub_bastion_pip_name_resource 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: publicIPAddresses_hub_bastion_pip_name
  location: 'westeurope'
  tags: {
    deployment: 'bicep'
    environment: 'hub'
    microhack: 'privatelink-dns'
  }
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
    '2'
    '3'
  ]
  properties: {
    ipAddress: '20.82.54.94'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource publicIPAddresses_hub_vpn_gateway_pip_name_resource 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: publicIPAddresses_hub_vpn_gateway_pip_name
  location: 'westeurope'
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '20.93.153.49'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource publicIPAddresses_onprem_bastion_pip_name_resource 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: publicIPAddresses_onprem_bastion_pip_name
  location: 'westeurope'
  tags: {
    deployment: 'bicep'
    environment: 'onprem'
    microhack: 'privatelink-dns'
  }
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
    '2'
    '3'
  ]
  properties: {
    ipAddress: '20.82.52.123'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource publicIPAddresses_onprem_vpn_gateway_pip_name_resource 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: publicIPAddresses_onprem_vpn_gateway_pip_name
  location: 'westeurope'
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '20.86.163.117'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource virtualNetworks_onprem_vnet_name_resource 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: virtualNetworks_onprem_vnet_name
  location: 'westeurope'
  tags: {
    deployment: 'bicep'
    environment: 'onprem'
    microhack: 'privatelink-dns'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '192.168.0.0/16'
      ]
    }
    dhcpOptions: {
      dnsServers: [
        '192.168.0.4'
      ]
    }
    subnets: [
      {
        name: 'InfrastructureSubnet'
        properties: {
          addressPrefix: '192.168.0.0/24'
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '192.168.255.224/27'
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '192.168.1.0/27'
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource storageAccounts_stgmicrohackfiles_name_resource 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccounts_stgmicrohackfiles_name
  location: 'westeurope'
  sku: {
    name: 'Premium_LRS'
    tier: 'Premium'
  }
  kind: 'FileStorage'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: true
    allowSharedKeyAccess: true
    largeFileSharesState: 'Enabled'
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        table: {
          keyType: 'Account'
          enabled: true
        }
        queue: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

resource virtualMachines_az_dns_vm_name_resource 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: virtualMachines_az_dns_vm_name
  location: 'westeurope'
  tags: {
    deployment: 'bicep'
    environment: 'hub-spoke'
    microhack: 'privatelink-dns'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS3_v2'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: 'az-dns-osdisk'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        writeAcceleratorEnabled: false
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
        diskSizeGB: 127
      }
      dataDisks: []
    }
    osProfile: {
      computerName: virtualMachines_az_dns_vm_name
      adminUsername: 'azureadmin'
      adminPassword: adminPwd
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: false
        patchSettings: {
          patchMode: 'Manual'
        }
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_az_dns_nic_name_resource.id
          properties: {
            primary: false
          }
        }
      ]
    }
  }
}

resource virtualMachines_az_mgmt_vm_name_resource 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: virtualMachines_az_mgmt_vm_name
  location: 'westeurope'
  tags: {
    deployment: 'bicep'
    environment: 'spoke'
    microhack: 'privatelink-dns'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS3_v2'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: 'az-mgmt-osdisk'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        writeAcceleratorEnabled: false
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
        diskSizeGB: 127
      }
      dataDisks: []
    }
    osProfile: {
      computerName: virtualMachines_az_mgmt_vm_name
      adminUsername: 'azureadmin'
      adminPassword: adminPwd
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: false
        patchSettings: {
          patchMode: 'Manual'
        }
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_az_mgmt_nic_name_resource.id
          properties: {
            primary: false
          }
        }
      ]
    }
  }
}

resource virtualMachines_onprem_dns_vm_name_resource 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: virtualMachines_onprem_dns_vm_name
  location: 'westeurope'
  tags: {
    deployment: 'bicep'
    environment: 'onprem'
    microhack: 'privatelink-dns'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS3_v2'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: 'onprem-dns-osdisk'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        writeAcceleratorEnabled: false
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
        diskSizeGB: 127
      }
      dataDisks: []
    }
    osProfile: {
      computerName: virtualMachines_onprem_dns_vm_name
      adminUsername: 'azureadmin'
      adminPassword: adminPwd
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: false
        patchSettings: {
          patchMode: 'Manual'
        }
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_onprem_dns_nic_name_resource.id
          properties: {
            primary: false
          }
        }
      ]
    }
  }
}

resource virtualMachines_onprem_mgmt_vm_name_resource 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: virtualMachines_onprem_mgmt_vm_name
  location: 'westeurope'
  tags: {
    deployment: 'bicep'
    environment: 'onprem'
    microhack: 'privatelink-dns'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS3_v2'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: 'onprem-mgmt-osdisk'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        writeAcceleratorEnabled: false
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
        diskSizeGB: 127
      }
      dataDisks: []
    }
    osProfile: {
      computerName: virtualMachines_onprem_mgmt_vm_name
      adminUsername: 'azureadmin'
      adminPassword: adminPwd
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: false
        patchSettings: {
          patchMode: 'Manual'
        }
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_onprem_mgmt_nic_name_resource.id
          properties: {
            primary: false
          }
        }
      ]
    }
  }
}

resource virtualMachines_az_dns_vm_name_install_dns_az_dc 'Microsoft.Compute/virtualMachines/extensions@2020-12-01' = {
  name: '${virtualMachines_az_dns_vm_name_resource.name}/install-dns-az-dc'
  location: 'westeurope'
  properties: {
    autoUpgradeMinorVersion: false
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.9'
    settings: {
      commandToExecute: 'powershell.exe -ExecutionPolicy Unrestricted Install-WindowsFeature -Name DNS -IncludeAllSubFeature -IncludeManagementTools; exit 0'
    }
    protectedSettings: {}
  }
}

resource virtualMachines_onprem_dns_vm_name_install_dns_onprem_dc 'Microsoft.Compute/virtualMachines/extensions@2020-12-01' = {
  name: '${virtualMachines_onprem_dns_vm_name_resource.name}/install-dns-onprem-dc'
  location: 'westeurope'
  properties: {
    autoUpgradeMinorVersion: false
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.9'
    settings: {
      commandToExecute: 'powershell.exe -ExecutionPolicy Unrestricted Install-WindowsFeature -Name DNS -IncludeAllSubFeature -IncludeManagementTools; Add-DnsServerForwarder -IPAddress 8.8.8.8 -PassThru; exit 0'
    }
    protectedSettings: {}
  }
}

resource networkInterfaces_az_dns_nic_name_resource 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: networkInterfaces_az_dns_nic_name
  location: 'westeurope'
  tags: {
    deployment: 'bicep'
    environment: 'hub-spoke'
    microhack: 'privatelink-dns'
  }
  properties: {
    ipConfigurations: [
      {
        name: networkInterfaces_az_dns_nic_name
        properties: {
          privateIPAddress: '10.0.0.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_hub_vnet_name_DNSSubnet.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
  }
}

resource networkInterfaces_az_mgmt_nic_name_resource 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: networkInterfaces_az_mgmt_nic_name
  location: 'westeurope'
  tags: {
    deployment: 'bicep'
    environment: 'spoke'
    microhack: 'privatelink-dns'
  }
  properties: {
    ipConfigurations: [
      {
        name: networkInterfaces_az_mgmt_nic_name
        properties: {
          privateIPAddress: '10.1.0.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_spoke_vnet_name_InfrastructureSubnet.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
  }
}

resource networkInterfaces_onprem_dns_nic_name_resource 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: networkInterfaces_onprem_dns_nic_name
  location: 'westeurope'
  tags: {
    deployment: 'bicep'
    environment: 'onprem'
    microhack: 'privatelink-dns'
  }
  properties: {
    ipConfigurations: [
      {
        name: networkInterfaces_onprem_dns_nic_name
        properties: {
          privateIPAddress: '192.168.0.4'
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: virtualNetworks_onprem_vnet_name_InfrastructureSubnet.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
  }
}

resource networkInterfaces_onprem_mgmt_nic_name_resource 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: networkInterfaces_onprem_mgmt_nic_name
  location: 'westeurope'
  tags: {
    deployment: 'bicep'
    environment: 'onprem'
    microhack: 'privatelink-dns'
  }
  properties: {
    ipConfigurations: [
      {
        name: networkInterfaces_onprem_mgmt_nic_name
        properties: {
          privateIPAddress: '192.168.0.5'
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: virtualNetworks_onprem_vnet_name_InfrastructureSubnet.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
  }
}

resource virtualNetworks_hub_vnet_name_resource 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: virtualNetworks_hub_vnet_name
  location: 'westeurope'
  tags: {
    deployment: 'bicep'
    environment: 'hub-spoke'
    microhack: 'privatelink-dns'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    dhcpOptions: {
      dnsServers: []
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.0.255.224/27'
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'DNSSubnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.0.1.0/27'
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'PrivateEndpointSubnet'
        properties: {
          addressPrefix: '10.0.2.0/24'
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: [
      {
        name: 'hub-spoke-peer'
        properties: {
          peeringState: 'Connected'
          remoteVirtualNetwork: {
            id: virtualNetworks_spoke_vnet_name_resource.id
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: true
          allowGatewayTransit: true
          useRemoteGateways: false
          remoteAddressSpace: {
            addressPrefixes: [
              '10.1.0.0/16'
            ]
          }
        }
      }
    ]
    enableDdosProtection: false
  }
  dependsOn: []
}

resource virtualNetworks_spoke_vnet_name_resource 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: virtualNetworks_spoke_vnet_name
  location: 'westeurope'
  tags: {
    deployment: 'bicep'
    environment: 'spoke'
    microhack: 'privatelink-dns'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    dhcpOptions: {
      dnsServers: []
    }
    subnets: [
      {
        name: 'InfrastructureSubnet'
        properties: {
          addressPrefix: '10.1.0.0/24'
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.1.1.0/27'
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: [
      {
        name: 'spoke-hub-peer'
        properties: {
          peeringState: 'Connected'
          remoteVirtualNetwork: {
            id: virtualNetworks_hub_vnet_name_resource.id
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: true
          allowGatewayTransit: false
          useRemoteGateways: true
          remoteAddressSpace: {
            addressPrefixes: [
              '10.0.0.0/16'
            ]
          }
        }
      }
    ]
    enableDdosProtection: false
  }
}

resource virtualNetworks_hub_vnet_name_AzureBastionSubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: '${virtualNetworks_hub_vnet_name_resource.name}/AzureBastionSubnet'
  properties: {
    addressPrefix: '10.0.1.0/27'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetworks_onprem_vnet_name_AzureBastionSubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: '${virtualNetworks_onprem_vnet_name_resource.name}/AzureBastionSubnet'
  properties: {
    addressPrefix: '192.168.1.0/27'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetworks_hub_vnet_name_DNSSubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: '${virtualNetworks_hub_vnet_name_resource.name}/DNSSubnet'
  properties: {
    addressPrefix: '10.0.0.0/24'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetworks_hub_vnet_name_GatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: '${virtualNetworks_hub_vnet_name_resource.name}/GatewaySubnet'
  properties: {
    addressPrefix: '10.0.255.224/27'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetworks_onprem_vnet_name_GatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: '${virtualNetworks_onprem_vnet_name_resource.name}/GatewaySubnet'
  properties: {
    addressPrefix: '192.168.255.224/27'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetworks_onprem_vnet_name_InfrastructureSubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: '${virtualNetworks_onprem_vnet_name_resource.name}/InfrastructureSubnet'
  properties: {
    addressPrefix: '192.168.0.0/24'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetworks_spoke_vnet_name_InfrastructureSubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: '${virtualNetworks_spoke_vnet_name_resource.name}/InfrastructureSubnet'
  properties: {
    addressPrefix: '10.1.0.0/24'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetworks_hub_vnet_name_PrivateEndpointSubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: '${virtualNetworks_hub_vnet_name_resource.name}/PrivateEndpointSubnet'
  properties: {
    addressPrefix: '10.0.2.0/24'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource bastionHosts_hub_bastion_host_name_resource 'Microsoft.Network/bastionHosts@2020-11-01' = {
  name: bastionHosts_hub_bastion_host_name
  location: 'westeurope'
  tags: {
    deployment: 'bicep'
    environment: 'hub'
    microhack: 'privatelink-dns'
  }
  sku: {
    name: 'Basic'
  }
  properties: {
    dnsName: 'bst-7b917f73-c65c-4ca8-9e5e-1f548207c6a6.bastion.azure.com'
    ipConfigurations: [
      {
        name: bastionHosts_hub_bastion_host_name
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_hub_bastion_pip_name_resource.id
          }
          subnet: {
            id: virtualNetworks_hub_vnet_name_AzureBastionSubnet.id
          }
        }
      }
    ]
  }
}

resource bastionHosts_onprem_bastion_host_name_resource 'Microsoft.Network/bastionHosts@2020-11-01' = {
  name: bastionHosts_onprem_bastion_host_name
  location: 'westeurope'
  tags: {
    deployment: 'bicep'
    environment: 'onprem'
    microhack: 'privatelink-dns'
  }
  sku: {
    name: 'Basic'
  }
  properties: {
    dnsName: 'bst-37c5a080-3d46-4810-9269-683a2491a3b6.bastion.azure.com'
    ipConfigurations: [
      {
        name: bastionHosts_onprem_bastion_host_name
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_onprem_bastion_pip_name_resource.id
          }
          subnet: {
            id: virtualNetworks_onprem_vnet_name_AzureBastionSubnet.id
          }
        }
      }
    ]
  }
}

resource connections_hub_onprem_conn_name_resource 'Microsoft.Network/connections@2020-11-01' = {
  name: connections_hub_onprem_conn_name
  location: 'westeurope'
  properties: {
    virtualNetworkGateway1: {
      id: virtualNetworkGateways_hub_vpn_gateway_name_resource.id
    }
    virtualNetworkGateway2: {
      id: virtualNetworkGateways_onprem_vpn_gateway_name_resource.id
    }
    connectionType: 'Vnet2Vnet'
    connectionProtocol: 'IKEv2'
    routingWeight: 1
    enableBgp: false
    useLocalAzureIpAddress: false
    usePolicyBasedTrafficSelectors: false
    ipsecPolicies: []
    trafficSelectorPolicies: []
    expressRouteGatewayBypass: false
    dpdTimeoutSeconds: 0
    connectionMode: 'Default'
    sharedKey: preSharedKey
  }
}

resource connections_onprem_hub_conn_name_resource 'Microsoft.Network/connections@2020-11-01' = {
  name: connections_onprem_hub_conn_name
  location: 'westeurope'
  tags: {
    deployment: 'bicep'
    environment: 'hub-spoke'
    microhack: 'privatelink-dns'
  }
  properties: {
    virtualNetworkGateway1: {
      id: virtualNetworkGateways_onprem_vpn_gateway_name_resource.id
    }
    virtualNetworkGateway2: {
      id: virtualNetworkGateways_hub_vpn_gateway_name_resource.id
    }
    connectionType: 'Vnet2Vnet'
    connectionProtocol: 'IKEv2'
    routingWeight: 1
    enableBgp: false
    useLocalAzureIpAddress: false
    usePolicyBasedTrafficSelectors: false
    ipsecPolicies: []
    trafficSelectorPolicies: []
    expressRouteGatewayBypass: false
    dpdTimeoutSeconds: 0
    connectionMode: 'Default'
    sharedKey: preSharedKey
  }
}

resource virtualNetworkGateways_hub_vpn_gateway_name_resource 'Microsoft.Network/virtualNetworkGateways@2020-11-01' = {
  name: virtualNetworkGateways_hub_vpn_gateway_name
  location: 'westeurope'
  tags: {
    deployment: 'bicep'
    environment: 'hub-spoke'
    microhack: 'privatelink-dns'
  }
  properties: {
    enablePrivateIpAddress: false
    ipConfigurations: [
      {
        name: 'vnetGatewayConfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_hub_vpn_gateway_pip_name_resource.id
          }
          subnet: {
            id: virtualNetworks_hub_vnet_name_GatewaySubnet.id
          }
        }
      }
    ]
    sku: {
      name: 'VpnGw1'
      tier: 'VpnGw1'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: false
    activeActive: false
    vpnClientConfiguration: {
      vpnClientProtocols: [
        'OpenVPN'
        'IkeV2'
      ]
      vpnClientRootCertificates: []
      vpnClientRevokedCertificates: []
      radiusServers: []
      vpnClientIpsecPolicies: []
    }
    bgpSettings: {
      asn: 65515
      bgpPeeringAddress: '10.0.255.254'
      peerWeight: 0
      bgpPeeringAddresses: [
        {
          ipconfigurationId: '${virtualNetworkGateways_hub_vpn_gateway_name_resource.id}/ipConfigurations/vnetGatewayConfig'
          customBgpIpAddresses: []
        }
      ]
    }
    vpnGatewayGeneration: 'Generation1'
  }
}

resource virtualNetworkGateways_onprem_vpn_gateway_name_resource 'Microsoft.Network/virtualNetworkGateways@2020-11-01' = {
  name: virtualNetworkGateways_onprem_vpn_gateway_name
  location: 'westeurope'
  tags: {
    deployment: 'bicep'
    environment: 'onprem'
    microhack: 'privatelink-dns'
  }
  properties: {
    enablePrivateIpAddress: false
    ipConfigurations: [
      {
        name: 'vnetGatewayConfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_onprem_vpn_gateway_pip_name_resource.id
          }
          subnet: {
            id: virtualNetworks_onprem_vnet_name_GatewaySubnet.id
          }
        }
      }
    ]
    sku: {
      name: 'VpnGw1'
      tier: 'VpnGw1'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: false
    activeActive: false
    vpnClientConfiguration: {
      vpnClientProtocols: [
        'OpenVPN'
        'IkeV2'
      ]
      vpnClientRootCertificates: []
      vpnClientRevokedCertificates: []
      radiusServers: []
      vpnClientIpsecPolicies: []
    }
    bgpSettings: {
      asn: 65515
      bgpPeeringAddress: '192.168.255.254'
      peerWeight: 0
      bgpPeeringAddresses: [
        {
          ipconfigurationId: '${virtualNetworkGateways_onprem_vpn_gateway_name_resource.id}/ipConfigurations/vnetGatewayConfig'
          customBgpIpAddresses: []
        }
      ]
    }
    vpnGatewayGeneration: 'Generation1'
  }
}

resource virtualNetworks_hub_vnet_name_hub_spoke_peer 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' = {
  name: '${virtualNetworks_hub_vnet_name_resource.name}/hub-spoke-peer'
  properties: {
    peeringState: 'Connected'
    remoteVirtualNetwork: {
      id: virtualNetworks_spoke_vnet_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: false
    remoteAddressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
  }
}

resource virtualNetworks_spoke_vnet_name_spoke_hub_peer 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' = {
  name: '${virtualNetworks_spoke_vnet_name_resource.name}/spoke-hub-peer'
  properties: {
    peeringState: 'Connected'
    remoteVirtualNetwork: {
      id: virtualNetworks_hub_vnet_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: true
    remoteAddressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
}

resource storageAccounts_stgmicrohackfiles_name_default_data 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-04-01' = {
  name: '${storageAccounts_stgmicrohackfiles_name}/default/data'
  properties: {
    accessTier: 'Premium'
    shareQuota: 1024
    enabledProtocols: 'SMB'
  }
  dependsOn: [
    storageAccounts_stgmicrohackfiles_name_resource
  ]
}