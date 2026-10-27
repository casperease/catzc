@description('Name of the SQL logical server whose logins and statements are audited.')
param serverName string

@description('Resource id of the Log Analytics workspace the audit log goes to.')
param workspaceId string

@description('Diagnostic setting name on the server\'s master database.')
param name string = 'audit-to-log-analytics'

resource server 'Microsoft.Sql/servers@2023-08-01' existing = {
  name: serverName
}

// Server-level auditing sends to Azure Monitor; the master database's diagnostic setting is where Azure Monitor picks the audit log up.
resource auditing 'Microsoft.Sql/servers/auditingSettings@2023-08-01' = {
  parent: server
  name: 'default'
  properties: {
    state: 'Enabled'
    isAzureMonitorTargetEnabled: true
    auditActionsAndGroups: [
      'SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP'
      'FAILED_DATABASE_AUTHENTICATION_GROUP'
      'BATCH_COMPLETED_GROUP'
    ]
  }
}

resource master 'Microsoft.Sql/servers/databases@2023-08-01' existing = {
  parent: server
  name: 'master'
}

resource auditLog 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: master
  name: name
  properties: {
    workspaceId: workspaceId
    logs: [
      {
        category: 'SQLSecurityAuditEvents'
        enabled: true
      }
    ]
  }
}
