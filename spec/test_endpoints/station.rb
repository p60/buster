require File.expand_path('../../spec_helper.rb', __FILE__)

class AdjustStationTemperatureHandler
  include Buster::CommandHandler

  def execute(props)
    reply :ten_four
  end
end

trap("TERM") { Buster.stop }

Buster.local_endpoint = 'ipc://station.ipc'
Buster.start
