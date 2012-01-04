%w{host sender worker poller command_handler router context version}.each { |r| require "buster/#{r}" }

require 'ffi-rzmq'
require 'msgpack'

module Buster
  class << self
    attr_accessor :local_endpoint

    def routes
      @routes ||= {}
    end

    def start
      raise "Bus is already started" if @host
      @host = Buster::Host.new(routes, context, self.local_endpoint)
      @host.start
    end

    def stop
      raise "Bus is not running" unless @host
      @host.stop
      @host = nil
    end

    def fire(name, props = {})
      sender.fire(name, props)
    end

    private

    def sender
      @sender ||= Buster::Sender.new(context)
    end

    def context
      @context ||= Buster::Context.new(ZMQ::Context.create)
    end
  end
end
