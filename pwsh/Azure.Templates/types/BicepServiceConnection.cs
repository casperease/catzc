using System;
using System.Collections.Generic;

namespace Catzc.Azure.Templates;

// One derived service connection: a deployment identity of service-connections.yml in one subscription, the trust boundary.
public sealed class BicepServiceConnection
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The connection's name, from the subscription's coordinates and the identity's role. Always present.
    public string name { get; }

    // The service-connections.yml identity it realises, such as landing-zone. Always present.
    public string identity { get; }

    // The role segment of the name, such as lz. Always present.
    public string role { get; }

    // The azure.yml subscription it reaches. Always present.
    public string subscription { get; }

    // The roles.yml name of the Azure role it holds. Always present.
    public string azure_role { get; }

    // The identity's templates, in file order.
    public IReadOnlyList<string> templates { get; }

    // The identity's sentence, naming what the connection deploys. Always present.
    public string description { get; }

    public BicepServiceConnection(string name, string identity, string role, string subscription, string azure_role, IReadOnlyList<string> templates, string description)
    {
        if (string.IsNullOrWhiteSpace(name)) { throw new ArgumentException("BicepServiceConnection.name is required"); }
        if (string.IsNullOrWhiteSpace(identity)) { throw new ArgumentException("BicepServiceConnection.identity is required"); }
        if (string.IsNullOrWhiteSpace(subscription)) { throw new ArgumentException("BicepServiceConnection.subscription is required"); }
        this.name = name;
        this.identity = identity;
        this.role = role ?? "";
        this.subscription = subscription;
        this.azure_role = azure_role ?? "";
        this.templates = templates ?? Array.Empty<string>();
        this.description = description ?? "";
    }
}
