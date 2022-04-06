curl --location --request POST 'http://path.to.monitor/ptp/proxy/Qmbz...RjpwY/CreateWorker' \
--header 'Content-Type: application/json' \
--data-raw '{
    "workers": [
        {
            "pid": 2,
            "name": "test-node-1",
            "endpoint": "http://path.to.worker1:8000",
            "enabled": true,
            "stake": "4000000000000000"
        },
        {
            "pid": 2,
            "name": "test-node-2",
            "endpoint": "http://path.to.worker2:8000",
            "enabled": true,
            "stake": "4000000000000000"
        }
    ]
}'