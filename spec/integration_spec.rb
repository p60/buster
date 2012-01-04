require 'spec_helper'

describe 'integration' do
  before :all do
    start_endpoint :mars
    start_endpoint :pluto
    Buster.local_endpoint = 'ipc://earth.ipc'
    Buster.routes[/mars/] = 'ipc://mars.ipc'
    Buster.routes[/pluto/] = 'ipc://pluto.ipc'
    Buster.routes[/station/] = 'ipc://station.ipc'
    Thread.new { Buster.start }
    sleep 1 #bus startup delay
  end

  after :all do
    Buster.stop
  end

  let(:mutex) { Mutex.new }
  let(:baton) { ConditionVariable.new }

  describe 'when sending a hello_mars' do
    before do
      Handler 'HelloEarth' do |props|
        mutex.synchronize do
          @response = props['name']
          baton.signal
        end
      end
    end

    it 'should respond in the mars uppercase style' do
      name = 'Major Tom'
      Buster.fire :hello_mars, :name => name
      mutex.synchronize do
        baton.wait(mutex, 1)
        @response.should == name.upcase
      end
    end
  end

  describe 'when sending a hello_pluto' do
    before do
      Handler 'HelloEarth' do |props|
        mutex.synchronize do
          @response = props['name']
          baton.signal
        end
      end
    end

    it 'should respond in the pluto reversed style' do
      name = 'Ground Control'
      Buster.fire :hello_pluto, :name => name
      mutex.synchronize do
        baton.wait(mutex, 1)
        @response.should == name.reverse
      end
    end
  end

  describe 'when sending to a powered down space station' do
    before do
      Handler 'TenFour' do |props|
        mutex.synchronize do
          @ten_foured = true
          baton.signal
        end
      end
    end

    it 'should receive response when the station powers up' do
      Buster.fire :adjust_station_temperature
      sleep 1 #Oh no! Station isn't started!
      start_endpoint :station
      mutex.synchronize do
        baton.wait(mutex, 1)
        @ten_foured.should == true
      end
    end
  end
end
