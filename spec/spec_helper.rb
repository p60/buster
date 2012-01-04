require 'rubygems'
require 'bundler/setup'

$:.unshift File.expand_path('../../lib', __FILE__)
require 'buster'

Bundler.require :development

Dir[File.join(File.dirname(__FILE__), 'support', '*.rb')].each { |d| require d }

Thread.abort_on_exception = true

$endpoint_pids = []

RSpec.configure do |config|
  config.mock_with :rspec

  config.after(:all) do
    $endpoint_pids.each { |p| Process.kill("TERM", p) }
  end
end

def Handler(name, &block)
  const_name = "#{name}Handler"
  if Object.const_defined?(const_name)
    klass = Object.const_get(const_name)
  else
    klass = Class.new do
      include Buster::CommandHandler

      def execute(props)
        @@execute_action.call(props,self)
      end

      def self.execute_action=(action)
        @@execute_action = action
      end
    end
    Object.const_set(const_name, klass)
  end

  klass.execute_action = block

  klass
end

def start_endpoint(name)
  pid =  Process.spawn("ruby #{File.join(File.dirname(__FILE__),'test_endpoints', "#{name}.rb")}")
  $endpoint_pids << pid

end
