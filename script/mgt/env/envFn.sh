#!/bin/bash
  TIMEOUT="250"
  #functions..
    #evaluate pod status..
    function kubectl::get_pod {
        local counter=0
        local statusP=""
        local statusC=""
            for ((counter=0; counter < ${TIMEOUT}; counter++)); do
                    statusP=$(kubectl --kubeconfig=${KUBECONFIG} get pod -n $1 | awk '/tiller/ {print $3}')
                    if [ "${statusP}" = "Running" ]; then
                        statusC=$(kubectl --kubeconfig=${KUBECONFIG} get pod -n $1 | awk '/tiller/ {print $2}')
                        if [ "${statusC}" = "1/1" ]; then
                                echo "All" $1 "pods & containers running ..."
                                break
                        else
                            sleep 5
                        fi
                    fi
            done
    }
  #helm..
  kubectl apply -f ./script/mgt/env/envFn/tiller-rbac.yaml >>/tmp/noise.out                                                            
  chmod +x ./script/mgt/env/envFn/get_helm.sh >>/tmp/noise.out
  timeout 60 ./script/mgt/env/envFn/get_helm.sh >>/tmp/noise.out
  sleep 60
  kubectl::get_pod kube-system
  helm init --service-account tiller >>/tmp/noise.out
  helm init --client-only >>/tmp/noise.out
  kubectl::get_pod kube-system
  #fn..
  git clone --quiet https://github.com/fnproject/fn-helm.git /tmp/cncf/fn-helm
  cp ./script/mgt/env/envFn/values.yaml /tmp/cncf/fn-helm/fn/ >>/tmp/noise.out

  cd /tmp/cncf/fn-helm
  
  helm dep build fn >>/tmp/noise.out
  helm install --name rel-01 fn >>/tmp/noise.out
  
  export PATH=$PATH:/usr/local/bin/
  echo 'export PATH="$PATH:/usr/local/bin/"' >> $HOME/.bashrc
  