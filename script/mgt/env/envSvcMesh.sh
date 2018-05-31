#!/bin/bash
#service mesh..
  #istio..
  chmod +x ./script/mgt/env/envSvcMesh/getlatestistio.sh >>/tmp/noise.out
  ./script/mgt/env/envSvcMesh/getlatestistio.sh >>/tmp/noise.out
  kubectl apply -f $HOME/istio-0.4.0/install/kubernetes/istio.yaml >>/tmp/noise.out
  kubectl apply -f $HOME/istio-0.4.0/install/kubernetes/addons/prometheus.yaml >>/tmp/noise.out
  kubectl apply -f $HOME/istio-0.4.0/install/kubernetes/addons/grafana.yaml >>/tmp/noise.out
  kubectl apply -f $HOME/istio-0.4.0/install/kubernetes/addons/zipkin.yaml >>/tmp/noise.out
  export PATH="$PATH:${HOME}/istio-0.4.0/bin"
  echo 'export PATH="$PATH:${HOME}/istio-0.4.0/bin"' >> $HOME/.bashrc
  #bookstore..
  kubectl apply -f <(istioctl kube-inject -f ${HOME}/istio-0.4.0/samples/bookinfo/kube/bookinfo.yaml) >>/tmp/noise.out
  #tools.. (tba)..
  #kubectl apply -f <(istioctl kube-inject -f istio-0.4.0/samples/sleep/sleep.yaml)
  #kubectl apply -f <(istioctl kube-inject -f istio-0.4.0/samples/httpbin/httpbin.yaml)