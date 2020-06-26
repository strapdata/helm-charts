# Elassandra Operator Chart

Elassandra Operator HELM 2 chart.

## Install the Elassandra Operator

```bash
helm install --namespace default --name elassandra-operator --wait strapdata/elassandra-operator
```

After installation succeeds, you can get a status of your deployment:

```bash
helm status elassandra-operator
```

By default, the elassandra operator starts with a maximum java heap of 512m, and with the following resources limit:

```yaml
resources:
  limits:
    cpu: 500m
    memory: 786Mi
  requests:
    cpu: 100m
    memory: 768Mi
```

You can adjust java settings by using the environment variable JAVA_TOOL_OPTIONS.

## Configuration

The following table lists the configurable parameters of the Elassandra Operator chart and their default values.

| Parameter                  | Description                                                  | Default                                                   |
| -----------------------    | ----------------------------------------------------------   | --------------------------------------------------------- |
| `image.repository`         | `elassandra-operator` image repository                       | `strapdata/elassandra-operator`                           |
| `image.tag`                | `elassandra-operator` image tag                              | `6.8.4.5`                                                 |
| `image.pullPolicy`         | Image pull policy                                            | `Always`                                                  |
| `image.pullSecrets`        | Image pull secrets                                           | `nil`                                                     |
| `replicas`                 | Number of `elassandra-operator` instance                     | `1`                                                       |
| `watchNamespace`           | Namespace in which this operator should manage resources     | `nil` (watch all namespaces)                              |
| `serverPort`               | HTTPS server port                                            | `443`                                                     |
| `managementPort`           | Management port                                              | `8081`                                                    |
| `jmxmpPort`                | JMXMP port                                                   | `7199`                                                    |
| `prometheusEnabled`        | Enable prometheus metrics                                    | `true`                                                    |
| `taskRetention`            | Elassandra task retention (Java duration)                    | `7D`                                                      |
| `env`                      | Additional environment variables                             | `nil`                                                     |
| `tls.key`                  | Operator TLS key (PEM base64 encoded)                        | ``                                                        |
| `tls.crt`                  | Operator TLS server certificate (PEM base64 encoded)         | ``                                                        |
| `tls.caBundle`             | Operator TLS CA bundle (PEM base64 encoded)                  | `tls.crt`                                                 |
| `ingress.enabled`          | Enables ingress for /seeds endpoint                          | `false`                                                   |
| `ingress.hosts`            | Ingress hosts                                                | `[]`                                                      |
| `ingress.annotations`      | Ingress annotations                                          | `{}`                                                      |
| `ingress.tls`              | Ingress TLS configuration                                    | `[]`                                                      |
| `nodeSelector`             | Node labels for pod assignment                               | `{}`                                                      |
| `rbacEnabled`              | Enable RBAC                                                  | `true`                                                    |
| `webhookEnabled`           | Enable webhook validation                                    | `true`                                                    |
| `webhook.failurePolicy`    | Webhook failure policy (**Fail** or **Ignore**)              | `Fail`                                                    |
| `webhook.timeoutSeconds`   | Webhook validation timeout in seconds                        | `15`                                                      |
| `tolerations`              | Toleration labels for pod assignment                         | `[]`                                                      |
| `affinity`                 | Affinity settings                                            | `{}`                                                      |

## TLS configuration

The elassandra operator expose HTTPS endpoints for:

* Kubernetes readiness check (/ready)
* Kubernetes webhook validation (/validation)
* Expose Cassandra seeds IP addresses (/seeds) to Elassandra nodes.

The operator TLS server certificate defined by **tls.crt** and **tls.key** must include a subjectAltName matching the FQDN of the operator service name 
(otherwise connection from elassandra nodes and the kubernetes API server to the operator will be rejected). 

The provided default server certificate only meet this condition when the operator is deployed in the **default** namespace. 
It was generated with the following command:

```bash
openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
  -keyout elassandra-operator.key -out elassandra-operator.crt -extensions san -config \
  <(echo "[req]"; 
    echo distinguished_name=req; 
    echo "[san]"; 
    echo subjectAltName=DNS:elassandra-operator.default.svc,DNS:elassandra-operator.default.svc.cluster.local,IP:127.0.0.1in    pod/strapkop-elassandra-operator-6b47cb8f54-95swg
    ) \
  -subj "/CN=localhost"
```

If you want to deploy the elassandra operator in another namespace, you must generate a server certificate and key matching your namespace.

The **tls.caBundle** is used to configure the caBundle field of the [ValidatingWebhookConfiguration](see https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/).
and by default, it contains the server certificate. 

The **tls.caBundle** is also used by elassandra nodes to trust connections to the remote Elassandra operators, in order to get the remote Cassandra seed IP addresses.
In such a case, the **tls.caBundle** must also include trust certificates of remote elassandra operators. 