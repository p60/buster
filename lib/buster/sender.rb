module Buster
  class Sender
    def initialize(context)
      @context = context
    end

    def fire(name, props = {})
      bin = MessagePack.pack(props)
      sender.send_strings([name.to_s, bin])
      sender.close
    end

    private

    def sender
      s = @context.socket(ZMQ::DEALER)
      s.connect("inproc://routes")
      s
    end
  end
end
