# Strapdata HELM Charts [![Build Status](https://travis-ci.org/strapdata/helm-charts.svg?branch=master)](https://travis-ci.org/strapdata/helm-charts)

[![Strapdata Logo](strapdata-logolong.png)](http://www.strapdata.io)

## Usage

Add this HELM repository

	helm repo add strapdata https://charts.strapdata.com	

Update this HELM repository

	helm repo update

## Install charts

Install Elassandra from this HELM repository:

	helm install --namespace "defaut" --set image.repo=strapdata/elassandra --set image.tag=6.2.3.11 strapdata/elassandra

Install Fluentbit with an Elasticsearch pipeline + template for an optimized storage with Elassandra

```bash
helm install --name my-fluentbit --set trackOffsets="true",\
backend.type="es",backend.es.host="elassandra-elasticsearch.default.svc.cluster.local",backend.es.time_key="es_time",backend.es.pipeline="fluentbit",\
parsers.enabled=true,parsers.json[0].name="docker",parsers.json[0].timeKey="time",parsers.json[0].timeFormat="%Y-%m-%dT%H:%M:%S.%L",parsers.json[0].timeKeep="Off" ./stable/fluent-bit
```
