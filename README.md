# Strapdata HELM Charts repository

## Add this HELM repository

	helm repo add strapdata https://charts.strapdata.com	

## Install Elassandra from this HELM repository

	helm install strapdata/elassandra --name=my-elassandra
	helm install --namespaces "defaut" --set image.repo=strapdata/elassandra --set image.tag=6.2.3.7 strapdata/elassandra

## Update reprository

	helm repo index . --url https://charts.strapdata.com
