module Buster
  class Router

    def initialize(context, routes = {})
      @context = context
      @routes = routes
    end

    def connect_routes(reply_socket, poller)
      local = @context.socket(ZMQ::DEALER)
      local.bind("inproc://routes")

      sockets = @routes.map do |pattern, uri|
        remote = @context.socket(ZMQ::DEALER)
        result = remote.connect(uri)

        poller.pipe remote, reply_socket
        [pattern, remote]
      end

      poller.register(local) do |s|
        s.recv_strings(msgs = [])
        message_name = msgs[0]
        #TODO: More robust routing
        remote = sockets.detect([nil,nil]){|x| x[0].match message_name}[1]
        if remote.nil?
          puts "No remote matching '#{message_name}'"
          return
        end
        remote.send_strings(msgs)
      end
    end
  end
end
