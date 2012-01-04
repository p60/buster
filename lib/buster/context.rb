module Buster
  class Context

    attr_accessor :context

    def initialize(context)
      @context = context
      @sockets = []
    end

    def socket(type)
      socket = @context.socket(type)
      @sockets << socket
      socket
    end

    def terminate
      @sockets.reverse.each do |s|
        s.setsockopt(ZMQ::LINGER, 0)
        s.close
      end
      @context.terminate
    end
  end
end
