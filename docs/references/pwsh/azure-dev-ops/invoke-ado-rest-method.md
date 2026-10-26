# pwsh/Azure.DevOps/Invoke-AdoRestMethod.ps1

The function every Azure DevOps REST call goes through. It authenticates with the header from the authorization function and applies the
standard error handling.

## help

### synopsis

Calls an Azure DevOps REST API endpoint with authentication and standard error handling.

### description

Wraps Invoke-RestMethod with the dual-auth pattern (Get-AdoAuthorizationHeader), JSON content type for POST/PUT/PATCH, and response
unwrapping for list endpoints (extracts the .value array automatically).

Designed for the ADO REST API conventions:

- Bearer token authentication
- JSON request/response bodies
- List responses wrapped in { "count": N, "value": `[...]` }

### parameter `Uri`

The full API URL including api-version query parameter.

### parameter `Method`

HTTP method. Defaults to Get.

### parameter `Body`

Request body for POST/PUT/PATCH. Accepts a hashtable or array — serialized to JSON automatically.

### parameter `UnwrapValue`

For list endpoints, extract the .value array from the response instead of returning the wrapper. Defaults to true for GET requests.

### example 1

```powershell
$environments = Invoke-AdoRestMethod -Uri "$apiRoot/distributedtask/environments?api-version=7.1-preview.1&`$top=300"
```

### example 2

```powershell
$result = Invoke-AdoRestMethod -Uri $checksUrl -Method Post -Body @(
    @{ resourceId = $envId; resourceType = 'environment' }
)
```
