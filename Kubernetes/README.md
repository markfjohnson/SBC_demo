# EXAMPLE: Deploy a Kubernetes Cluster

## Requirements
* A healthy DC/OS Cluster with at least 8 nodes
* 'kubernetes' user defined with password 'password'
* 'kubernetes-cluster1' service account is defined

## Steps to deploy a Kubernetes Cluster
### Add the Kubernetes Cluster Manager
1. Search for the Kubernetes Cluster Manager in the catalog
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k_1-1.png)

1. Select the Kubernetes Cluster manager and select review and run
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k_1-2.png)

1. Verify service account is blank, then select the Mesosphere Kubernetes Engine
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k_1-3.png)

1. Change the CPU count from 0.5 to 1, then click "review and run"
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k_1-4.png)

1. Click "Run Service" to begin the deployment
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k_1-5.png) 

![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k_1-6.png)


1. Verify the Kubernetes Cluster Manager has deployed
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k_1-7.png)

### Add a Kubernetes Cluster
1. Search for the Kubernetes Cluster option in the catalog
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-2-1.png)

1. Select the Kubernetes Cluster option and modify the default properties as shown in the screen prints below
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-2-2.png)


1. For the Kubernetes cluster service, specify the Service name as "kubernetes-cluster1", the "Service Account Name" as "kubernetes-cluster1" and the "Service Account Secret" to "kubernetes-cluster1/sa"
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-2-3.png)

1. Specify the Cpus to 1 as part of the "Kubernetes" section definition
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-2-4a.png)

1. Specify the kube-Cpus to 1 as part of the "Kubernetes" section definition.
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-2-4b.png)

1. Review the Calico CNI network section (You will not need to make any changes)
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-2-4c.png)

1. Change the etcd CPU count to 1
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-2-5.png)


1. Click review and run to confirm the properties are properly selected, then click on "Run Service"
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-2-6.png)


![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-2-7.png)

![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-2-8.png)

1. Click on the cluster name and explore the options while the cluster is deploying
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-2-9.png)

### Scale up the Kubernetes Cluster
1. Click the edit button for the kubernetes-cluster1, then select the 'kubernetes' section
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-3-0.png)

1. Change the node count from 1 to 5 as shown below
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-3-1.png)

1. Click review and run to confirm the properties are properly selected
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-3-2.png)

1. Click on the cluster name and then details to observe the additional 4 nodes getting added

1. Find and review the Kubernetes documentation on-line.

