module Buster
  class Poller
    def initialize
      @poller = ZMQ::Poller.new
    end

    def start
      @run = true
      while @run
        @poller.poll(500)
        @poller.readables.each do |socket|
          action = @readable_actions[socket]
          action.call(socket) if action
        end
      end
    end

    def stop
      @run = false
    end

    def register(socket, &block)
      @poller.register(socket, ZMQ::POLLIN)
      readable_actions[socket] = block
    end

    def pipe(incoming, outgoing)
      register(incoming) do |s|
        s.recv_strings(msgs = [])
        outgoing.send_strings(msgs, ZMQ::NOBLOCK)
      end
    end

    private

    def readable_actions
      @readable_actions ||= {}
    end
  end
end
