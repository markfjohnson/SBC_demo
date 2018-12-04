#EXAMPLE #3: Monitor a running application under load

## Pre-requisites
* A DC/OS Cluster in a healthy state with at least 5 agents and Marathon-lb also installed.
* Prometheus and Grafana have been installed on this cluster using the instructions found [here](https://github.com/markfjohnson/dcos112-metrics/tree/master/Installation).
* Install JMeter on a client machine with access to your DC/OS Cluster

## Steps to Load a legacy WebLogic application and start a simple load test
1. Enter the 'Service' option and click on the + character at the top right corner of the screen to create a new service.
XXX Create new service screen insert here

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

1. Click

1. Confirm that the task "weblogic-benefits-app2.dept-a" has a state of "R"
    ```aidl
    dcos task | grep weblogic
 
    NAME                           HOST         USER   STATE  ID                                                                  MESOS ID                                      REGION          ZONE
    weblogic-benefits-app2.dept-a  10.0.3.164   root     R    dept-a_weblogic-benefits-app2.f1eefeae-f299-11e8-b919-368064a59738  fb3f6a7d-e14d-4aa2-9ce0-e6bf5b60176b-S6   aws/us-west-2  aws/us-west-2b
    ```

1. Startup JMeter 

    ```aidl
    jmeter -t WebLogic_Benefits_Scale_test.jmx
    ```
    Starting JMeter will result in the JMeter GUI app to start.  As part of the JMeter startuyp the process will automatically load our simple test script.
    
1. Set the Public IP
    Get the cluster's public IP address, so that you can set the Server IP address into the JMeter test plan as shown below.
    ![](https://github.com/markfjohnson/dcos112-metrics/raw/master/weblogic-load-test/images/SetPublic_servername.png)
    
1. Run the JMeter load test by pressing the Green start button.  Pressing the start button initiates the testing.  Then, click on the Summary Report optin in the test plan to see the test results.
    ![](https://github.com/markfjohnson/dcos112-metrics/raw/master/weblogic-load-test/images/jmeter_summary.png)
    
 
 ## Review DC/OS metrics for the WebLogic Benefits application in Grafana
 1. Open your browser and open the url http://{public IP}:9094.  The user id and password is admin/admin.
     ![](https://github.com/markfjohnson/dcos112-metrics/raw/master/weblogic-load-test/images/grafana_login.png)
 
 1. Import the sample dashboard for the WebLogic Benefits application
    ![](https://github.com/markfjohnson/dcos112-metrics/raw/master/weblogic-load-test/images/grafana_import.png)
    
 1. You will now be able to see just the network, memory and CPU utilization for the Benefits application under load
    ![](https://github.com/markfjohnson/dcos112-metrics/raw/master/weblogic-load-test/images/grafana_dashboard.png)
