module Buster
  class Host

    def initialize(routes, context, local_endpoint = nil)
      @local_endpoint = local_endpoint ||"inproc://local_endpoint"
      @context = context
      @router = Buster::Router.new(@context, routes)
      @poller = Buster::Poller.new
    end

    def start
      frontend = @context.socket(ZMQ::ROUTER)
      frontend.bind(@local_endpoint)

      backend = @context.socket(ZMQ::DEALER)
      backend.bind("inproc://workers")

      @router.connect_routes backend, @poller

      Buster::Worker.start_worker @context

      @poller.pipe frontend, backend
      @poller.pipe backend, frontend

      poll_thread = Thread.new { @poller.start }
      poll_thread.join

      @context.terminate
    end

    def stop
      @poller.stop
    end

  end
end
