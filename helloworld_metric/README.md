Hello World Metric
==================

In two flavors: Graphite and JSON

- has a default metric name 'hello.world.test'
-- you can specify a different one with -n
- has a default metric value '166'
-- you can specify a different one with -v
- in the JSON version only: you can send arbitrary tags with -t
- includes "host" with the hostname for free, even without this flag


Sample config file: Graphite
----------------------------

A config that sends

- metric 'zardoz.is.king'
- value 384
- every 60 seconds


     {
         "checks": {
             "test_zardoz_metric": {
                 "handler": "metric_store",
                 "type": "metric",
                 "standalone": true,
                 "command": "SENSU_HOME/checks/helloworld_metric/metric_helloworld_graphite.rb -n zardoz.is.king -v 384",
                 "output_type": "json",
                 "auto_tag_host": "yes",
                 "interval": 60,
                 "description": "Testing Sensu-RabbitMQ-OpenTSDB integration using metric name zardoz.is.king",
                 "subscribers": ["system"]
             }
         }
     }


Sample config file: JSON
------------------------

The benefits of using JSON is you can include arbitrary tags in the metric.

A config that sends

- metric 'the.yellow.sign'
- value 385
- tags:
ST
     - foo = bar
     - baz = garply
- every 60 seconds


     {
         "checks": {
             "test_have_you_seen_metric": {
                 "handler": "metric_store",
                 "type": "metric",
                 "standalone": true,
                 "command": "SENSU_HOME/checks/helloworld_metric/metric_helloworld_json.rb -n the.yellow.sign -v 385 -t foo=bar,baz=garply",
                 "output_type": "json",
                 "auto_tag_host": "yes",
                 "interval": 60,
                 "description": "Testing Sensu-RabbitMQ-OpenTSDB integration using metric name the.yellow.sign",
                 "subscribers": ["system"]
             }
         }
     }


See it working
--------------

- make sure the config is at /etc/sensu/conf.d
- make sure the ruby file is at the place specified in the sensu check config (.json)
- you can watch the log at


    $ sudo tail -F /var/log/sensu/sensu-client.log


- watch your OpenTSDB API, for example for metric "the.yellow.sign" -
    - http://opentsdbhostname/api/query?start=2000060m-ago&m=sum:the.yellow.sign

