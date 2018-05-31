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
    echo " Example: [true false true true true]"
    echo "****************************************"
    exit 1
    
fi

MonitoringDashboards=$1
Fn=$2
SocksShopDemo=$3
CheesesDemo=$4
ServiceMeshDemo=$5

#######################################################################
#################### Setting up Cloud Native Technologies

echo "MGT :: Remote-Exec :: Configure Environments ..."
    #dashboard, monitoring, & metrics..
        if [ $1 = "true" ]; then
            echo "ENV-1 :: Updating K8s Dashboard, Monitoring & Metrics ..."
            ./script/mgt/env/envDashMonMet.sh
        echo "Waiting for kube-system pods (dasboard & dependencies) to be up and running ..."
        kubectl::get_pod kube-system
        fi
    #microservices..
        if [ $SocksShopDemo = "true" ]; then
            echo "ENV-2 :: Installing Microservices Environment ..."
            ./script/mgt/env/envMicroSvc.sh
        echo "Waiting for sock-shop pods (microservices application) to be up and running ..."
        kubectl::get_pod sock-shop
        fi
    #ingress controller..
        if [ $CheesesDemo = "true" ]; then
            echo "ENV-3 :: Installing Traefik Ingress Controller ..."
            ./script/mgt/env/envIngress.sh
        echo "Waiting for kube-system pods to be up and running ..."
        kubectl::get_pod kube-system
        fi
    #fn..
        if [ $Fn = "true" ]; then
            echo "ENV-4 :: Installing Fn ..."
            ./script/mgt/env/envFn.sh
        echo "Waiting for default pods to be up and running ..."
        kubectl::get_pod default
        fi
    #service mesh..
        if [ $ServiceMeshDemo = "true" ]; then
            echo "ENV-5 :: Installing Service Mesh Control Plane ..."
            ./script/mgt/env/envSvcMesh.sh
        echo "Waiting for istio-system & default pods to be up and running ..."
        kubectl::get_pod istio-system
        kubectl::get_pod default
        fi
echo "MGT :: Remote-Exec :: Configure Environments ... :: Done ..."