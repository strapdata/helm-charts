# HELM Chart to create storageClass

HELM chart to create storageClass attached to an availability zone.

Install example for GCP:

```
helm install --name ssd-europe-west1-b --namespace kube-system --set zone=europe-west1-b,nameOverride=ssd-b strapdata/storageclass
```