module Buster
  class Worker
    def initialize(context)
      @context = context
    end

    def run
      worker = @context.socket(ZMQ::DEALER)
      worker.connect("inproc://workers")
      while true
        worker.recv_strings(msgs = [])
        return if msgs.length < 2

        body = MessagePack.unpack(msgs.pop)
        message_name = msgs.pop
        reply_id = msgs.pop

        handler = find_handler message_name
        if handler.nil?
          puts "No handler found for #{message_name}"
          return
        end

        handler.reply_action = lambda do |name,props|
          worker.send_strings([reply_id, name.to_s, MessagePack.pack(props)])
        end

        handler.execute body
      end
      worker.close
    end


    def self.start_worker(context)
      worker = Worker.new(context)
      t = Thread.new { worker.run }
      t.run
    end

    private

    def find_handler(name)
     camelized = name.split(/[^a-z0-9]/i).map{|w| w.capitalize}.join
     const_name = "#{camelized}Handler"
     Object.const_get(const_name).new if Object.const_defined?(const_name)
    end

  end
end
