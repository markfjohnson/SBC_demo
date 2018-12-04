#!/usr/bin/env bash
dcos marathon app add weblogic_demo.json
jmeter -t WebLogic_Benefits_Scale_test.jmx
