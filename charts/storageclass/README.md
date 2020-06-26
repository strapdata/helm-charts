# HELM Chart to create storageClass

HELM chart to define Kubernetes storageClass bound to an availability zone.

Install example for GCP:

```
helm install --name ssd-europe-west1-b --namespace kube-system \
    --set parameters.type="pd-ssd" \
    --set provisioner="kubernetes.io/gce-pd" \
    --set zone=europe-west1-b \
    --set nameOverride=ssd-b \
    strapdata/storageclass
```

Install example for Azure:

```
helm install --name ssd-northeurope-1 --namespace kube-system \
    --set parameters.kind="Managed" \
    --set parameters.cachingmode="ReadOnly" \
    --set parameters.storageaccounttype="StandardSSD_LRS" \
    --set provisioner="kubernetes.io/azure-disk" \
    --set zone=northeurope-1 \
    --set nameOverride=ssd-northeurope-1 \
    strapdata/storageclass
```