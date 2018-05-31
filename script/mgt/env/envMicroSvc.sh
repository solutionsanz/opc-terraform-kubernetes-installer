#!/bin/bash
#microservices..
  #weavescope..
  kubectl apply -f ./script/mgt/env/envMicroSvc/scope.yaml >>/tmp/noise.out
  #weavesocks..
  git clone --quiet https://github.com/microservices-demo/microservices-demo /tmp/cncf/microservices-demo >>/tmp/noise.out
  kubectl create namespace sock-shop >>/tmp/noise.out
  kubectl create -f /tmp/cncf/microservices-demo/deploy/kubernetes/complete-demo.yaml >>/tmp/noise.out
