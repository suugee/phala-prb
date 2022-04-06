curl --location --request POST 'http://path.to.monitor/ptp/proxy/Qmbz...RjpwY/CreatePool' \
--header 'Content-Type: application/json'
--data-raw '{
    "pools": [
        {
            "pid": 2,
            "name": "test2",
            "owner": {
                "mnemonic": "boss...chase"
            },
            "enabled": true,
            "realPhalaSs58": "3zieG9...1z5g"
        }
    ]
}'