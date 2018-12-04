#EXAMPLE: J2EE Legacy Migration

## Pre-requisites
* A DC/OS Cluster in a healthy state with at least 5 agents and Marathon-lb also installed.
* Prometheus and Grafana have been installed on this cluster using the instructions found [here](https://github.com/markfjohnson/dcos112-metrics/tree/master/Installation).
* Install JMeter on a client machine with access to your DC/OS Cluster

## Steps to Load a legacy WebLogic application and start a simple load test

### Install Marathon-Load balancer
1. Select catalog and then search for "marathon-lb"
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/marathonlb-cat.png)

1. Change maximumovercapacity=1 and minhealthcapacity=0
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/mlb-default-properties.png)

1. Click "review and run"
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/mlb-review.png)

1. Confirm that the Marathon-LB service has successfully deployed and is healthy
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/mlb-ok.png)

### Migrate the WebLogic Benefits Application
1. Enter the 'Service' option and click on the + character at the top right corner of the screen to create a new service.
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/Services_add.png)

1. Copy the following into your clipboard
```$xslt
{
  "env": {
    "DOMAIN_NAME": "base_domain",
    "CLUSTER_NAME": "DockerCluster",
    "APP_NAME": "benefits",
    "ADMIN_PORT": "7001",
    "ADMIN_PASS": "Welcome1",
    "DOMAIN_HOME": "/u01/oracle/user_projects/domains/base_domain",
    "APP_PKG_FILE": "benefits.war",
    "ADMIN_NAME": "weblogic"
  },
  "labels": {
    "HAPROXY_GROUP": "external"
  },
  "id": "/dept-a/weblogic-benefits-app2",
  "backoffFactor": 1.15,
  "backoffSeconds": 1,
  "cmd": "env | sort && ls -lt /u01/oracle && pwd && mv /mnt/mesos/sandbox/benefits.war /u01/oracle/benefits.war && wlst /u01/oracle/app-deploy.py && startWebLogic.sh",
  "container": {
    "portMappings": [
      {
        "containerPort": 8001,
        "hostPort": 0,
        "labels": {
          "VIP_0": "/weblogic-app:8001"
        },
        "protocol": "tcp",
        "servicePort": 10100,
        "name": "weblogic-management-server"
      },
      {
        "containerPort": 5556,
        "hostPort": 0,
        "labels": {
          "VIP_1": "/weblogic-app:5556"
        },
        "protocol": "tcp",
        "servicePort": 10101,
        "name": "weblogic-administration-server"
      },
      {
        "containerPort": 7001,
        "hostPort": 0,
        "labels": {
          "VIP_2": "/weblogic-app:7001"
        },
        "protocol": "tcp",
        "servicePort": 10102,
        "name": "weblogic-node-manager"
      }
    ],
    "type": "MESOS",
    "volumes": [],
    "docker": {
      "image": "tkrausjr/1221-appdeploy:v2",
      "forcePullImage": false,
      "parameters": []
    }
  },
  "cpus": 1,
  "disk": 0,
  "fetch": [
    {
      "uri": "http://www.oracle.com/webfolder/technetwork/tutorials/obe/fmw/wls/12c/03-DeployApps/files/benefits.war",
      "extract": false,
      "executable": false,
      "cache": false
    }
  ],
  "healthChecks": [
    {
      "gracePeriodSeconds": 300,
      "ignoreHttp1xx": false,
      "intervalSeconds": 25,
      "maxConsecutiveFailures": 3,
      "portIndex": 0,
      "timeoutSeconds": 20,
      "delaySeconds": 15,
      "protocol": "HTTP",
      "path": "/benefits/"
    }
  ],
  "instances": 1,
  "maxLaunchDelaySeconds": 3600,
  "mem": 2048,
  "gpus": 0,
  "networks": [
    {
      "mode": "container/bridge"
    }
  ],
  "requirePorts": false,
  "upgradeStrategy": {
    "maximumOverCapacity": 1,
    "minimumHealthCapacity": 1
  },
  "killSelection": "YOUNGEST_FIRST",
  "unreachableStrategy": {
    "inactiveAfterSeconds": 0,
    "expungeAfterSeconds": 0
  },
  "constraints": []
}
```

1. Open the JSON editor and paste the JSON file copied from the earlier step
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/json_editor.png)

1. Click "Review & Run" to verify all the properties are correctly set prior to initiating the service deployment
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/review_service.png)

1. Verify the service is deployed when the status is reporting healthy
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/deploy_weblogic.png)

## Scale the application to 2 instances
1. Verify only one application instance
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/base_wls_1_instance.png)

1. Select the 3 dot menu, then the scale menu option
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/wls_scale_menu.png)

1. Specify scale of 2
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/scale_2.png)

1. Verify the second application instance is started.  NOTE: marathon-lb automatically takes care of the network configuration for the external load balancing.
![](https://github.com/markfjohnson/SBC_demo/blob/master/Legacy/images/wls_2_instances.png)

1. Review the Mesosphere documentation

