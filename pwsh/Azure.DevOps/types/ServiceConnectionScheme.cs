namespace Catzc.Azure.DevOps;

// The one scheme a project's Azure service connection authenticates with: no other is written, so none holds a stored secret.
public static class ServiceConnectionScheme
{
    public const string Federated = "WorkloadIdentityFederation";
}
