module Buster
  class Sender
    def initialize(context)
      @context = context
    end

    def fire(name, props = {})
      bin = MessagePack.pack(props)
      sender.send_strings([name.to_s, bin])
    end

    private

    def sender
      return Thread.current['sender_socket'] if Thread.current['sender_socket']

      s = Thread.current['sender_socket'] = @context.socket(ZMQ::DEALER)
      s.connect("inproc://routes")
      s
    end
  end
end
