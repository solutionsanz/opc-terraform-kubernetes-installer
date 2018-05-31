#######################################################################
# Deploy Cloud native Technologies into curated Kubernetes cluster.
# This version created by Carlos Rodriguez Iturria (https://www.linkedin.com/in/citurria/)
# Based on Cameron Senese's scripts: https://github.com/cameronsenese/opc-terraform-kubernetes-installer
#######################################################################
#################### Reading and validating passed parameters:


if [ "$#" -ne 5 ]; then

    echo "**************************************** Error: "
    echo " Illegal number of parameters."
    echo " Mark as true or false for the following components that you wish to deploy"
    echo " Order: [MonitoringDashboards Fn SocksShopDemo CheesesDemo ServiceMeshDemo]"
    echo " Example: ./curate-k8s.sh true false true true true"
    echo "****************************************"
    exit 1
    
fi

MonitoringDashboards=$1
Fn=$2
SocksShopDemo=$3
CheesesDemo=$4
ServiceMeshDemo=$5

wait=10s

#######################################################################
#################### Setting up Cloud Native Technologies

# Reseting temp folder:
rm -rf /tmp/cncf

echo "MGT :: Remote-Exec :: Configure Environments ..."
    #dashboard, monitoring, & metrics..
        if [ $1 = "true" ]; then
            echo "ENV-1 :: Updating K8s Dashboard, Monitoring & Metrics ..."
            chmod 755 ./script/mgt/env/envDashMonMet.sh && ./script/mgt/env/envDashMonMet.sh
        echo "Waiting for kube-system pods (dasboard & dependencies) to be up and running ..."
        #kubectl::get_pod kube-system
        fi
    #microservices..
        if [ $SocksShopDemo = "true" ]; then
            echo "ENV-2 :: Installing Microservices Environment ..."
            chmod 755 ./script/mgt/env/envMicroSvc.sh && ./script/mgt/env/envMicroSvc.sh
        echo "Waiting for sock-shop pods (microservices application) to be up and running ..."
        #kubectl::get_pod sock-shop
        sleep $wait
        fi
    #ingress controller..
        if [ $CheesesDemo = "true" ]; then
            echo "ENV-3 :: Installing Traefik Ingress Controller ..."
            chmod 755 ./script/mgt/env/envIngress.sh && ./script/mgt/env/envIngress.sh
        echo "Waiting for kube-system pods to be up and running ..."
        #kubectl::get_pod kube-system
        sleep $wait
        fi
    #fn..
        if [ $Fn = "true" ]; then
            echo "ENV-4 :: Installing Fn ..."
            chmod 755 ./script/mgt/env/envFn.sh && ./script/mgt/env/envFn.sh
        echo "Waiting for default pods to be up and running ..."
        #kubectl::get_pod default
        sleep $wait
        fi
    #service mesh..
        if [ $ServiceMeshDemo = "true" ]; then
            echo "ENV-5 :: Installing Service Mesh Control Plane ..."
            chmod 755 ./script/mgt/env/envSvcMesh.sh && ./script/mgt/env/envSvcMesh.sh
        echo "Waiting for istio-system & default pods to be up and running ..."
        #kubectl::get_pod istio-system
        #kubectl::get_pod default
        sleep $wait
        fi
echo "MGT :: Remote-Exec :: Configure Environments ... :: Done ..."