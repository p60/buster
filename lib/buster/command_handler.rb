module Buster
  module CommandHandler
    attr_accessor :reply_action

    def reply(message_name, props = {})
      raise 'No reply_action available' unless self.reply_action

      reply_action.call(message_name, props)
    end
  end
end
