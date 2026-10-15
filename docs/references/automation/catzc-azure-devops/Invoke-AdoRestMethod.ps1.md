---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/Invoke-AdoRestMethod.ps1.md
    kind: comment-page
    body_sha: "0d27b387b06d"
---

# automation/Catzc.Azure.DevOps/Invoke-AdoRestMethod.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Wraps Invoke-RestMethod with the dual-auth pattern (Get-AdoAuthorizationHeader),
JSON content type for POST/PUT/PATCH, and response unwrapping for list endpoints
(extracts the .value array automatically).

Designed for the ADO REST API conventions:
- Bearer token authentication
- JSON request/response bodies
- List responses wrapped in { "count": N, "value": [...] }
```

## comment:2

Section `.PARAMETER UnwrapValue` of the comment-based help.

```text
For list endpoints, extract the .value array from the response instead of returning the wrapper.
Defaults to true for GET requests.
```
