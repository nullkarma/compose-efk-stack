#!/bin/bash

while getopts ":u:p:e:" opt; do
    case $opt in
        u) username=$OPTARG ;;
        p) password=$OPTARG ;;
        e) email=$OPTARG ;;
    esac
done

echo "set kibana password"

curl -s -H "Content-Type: application/json" -u elastic:elastic http://127.0.0.1:9200/_xpack/security/user/kibana/_password -d @- <<DATA
{
    "password": "kibana"
}
DATA

echo
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
