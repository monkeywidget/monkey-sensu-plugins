#!/usr/bin/env ruby

require 'socket'

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/metric/cli'

# Provides a Sensu metric for testing RabbitMQ/sensu integration
class HelloWorldGraphiteMetric < Sensu::Plugin::Metric::CLI::Graphite

  option :name,
         :short       => '-n <metric_name>',
         :description => 'metric name',
         :default     => 'hello.world.test',
         :required    => false

  option :value,
         :short       => '-v <metric_value>',
         :description => 'metric value',
         :default     => '166',
         :required    => false

  def run
    output config[:name], config[:value]
    ok
  end

end
