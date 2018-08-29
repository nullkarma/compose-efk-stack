#!/bin/bash

function usage {
    echo "$0 -u username -p password -e email_addr"
}

while getopts ":u:p:e:h" opt; do
    case $opt in
        u) username=$OPTARG ;;
        p) password=$OPTARG ;;
        e) email=$OPTARG ;;
        h) usage; exit ;;
    esac
done

echo "set kibana password"

curl -s -H "Content-Type: application/json" -u elastic:elastic http://127.0.0.1:9200/_xpack/security/user/kibana/_password -d @- <<DATA
{
    "password": "kibana"
}
DATA

echo
username=${username:-demouser}
password=${password:-demouser}
email=${email:-demo@example.com}

echo "create user $username"

curl -s -X POST -H "Content-Type: application/json" -u elastic:elastic http://127.0.0.1:9200/_xpack/security/user/$username -d @- <<DATA
{
    "full_name": "$username",
    "password": "$password",
    "email": "$email",
    "roles": [
        "superuser"
    ]
}
DATA

echo

echo "create fluentd role"

curl -s -X POST -H "Content-Type: application/json" -u elastic:elastic http://127.0.0.1:9200/_xpack/security/role/fluentd_system -d @- <<DATA
{
    "cluster": [
        "manage_index_templates",
        "monitor"
    ],
    "indices": [
        {
            "names": ["*"],
            "privileges": ["create_index", "index"]
        }
    ]
}
DATA

echo
echo "create user fluentd"

curl -s -X POST -H "Content-Type: application/json" -u elastic:elastic http://127.0.0.1:9200/_xpack/security/user/fluentd -d @- <<DATA
{
    "full_name": "fluentd",
    "password": "fluentd",
    "email": "fluend@internal",
    "roles": [
        "fluentd_system"
    ]
}
DATA

echo
