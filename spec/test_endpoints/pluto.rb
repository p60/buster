require File.expand_path('../../spec_helper.rb', __FILE__)

class HelloPlutoHandler
  include Buster::CommandHandler

  def execute(props)
    reply :hello_earth, 'name' => props['name'].reverse
  end
end

trap("TERM") { Buster.stop }

Buster.local_endpoint = 'ipc://pluto.ipc'
Buster.start
