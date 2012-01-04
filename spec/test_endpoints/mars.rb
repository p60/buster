require File.expand_path('../../spec_helper.rb', __FILE__)

class HelloMarsHandler
  include Buster::CommandHandler

  def execute(props)
    reply :hello_earth, 'name' => props['name'].upcase
  end
end

trap("TERM") { Buster.stop }

Buster.local_endpoint = 'ipc://mars.ipc'
Buster.start
