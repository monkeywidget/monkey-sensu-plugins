#!/usr/bin/env ruby

require 'socket'

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/metric/cli'

# Provides a Sensu metric for testing RabbitMQ/sensu integration 
class HelloWorldJSONMetric < Sensu::Plugin::Metric::CLI::JSON

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

  option :tags,
         :short        => '-t <CSV tags_with_values>',
         :description  => 'CSV tags keys and values',
         :default      => nil,
         :required     => false

  # @param [String] tags_keyvalues : a maybe-nil String like "foo=bar,baz=garply"
  # @return [Hash] tags : like { foo: "bar", baz: "garply" } ... it will always include :host
  # @raise [ArgumentError] if keyvalue is missing or unparsable
  def parse_additional_tags(tags_keyvalues)
    tags = {}
    tags[:host] = Socket.gethostname

    return tags if tags_keyvalues.nil? || tags_keyvalues.empty?

    list_of_keyvalues = tags_keyvalues.split(',')

    list_of_keyvalues.each do |keyvalue|
      key, value = keyvalue.split('=')
      if key.nil? || key.empty? || value.nil? || value.empty?
        fail(ArgumentError, "missing key or value in (#{key}=#{value})")
      end
      tags[key.to_sym] = value
    end

    tags
  end

  def run

    metric_hash = {
        :name => config[:name],
        :value => config[:value],
        :tags => parse_additional_tags(config[:tags])
    }

    # output the metrics
    output metric_hash
    ok
  end

end
