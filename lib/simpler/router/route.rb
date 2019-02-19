module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :path

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @path_regexp = path_regexp(@path)
      end

      def match?(method, path)
        @method == method && correct_path?(path)
      end

      def route_param(env)
        # params = {}
        request = Rack::Request.new(env)
        path = env['PATH_INFO']
        env_path = path.split('/')
        request_path = @path.split('/')

        # request_path.each.with_index do |piece, i|
        #   params[piece.delete(':').to_sym] = env_path[i] if piece.match?(':')
        # end

        # params.merge(request.params)

        route_params = request_path.each.with_index.with_object({}) do |(each, i), params|
          params[each.delete(':').to_sym] = env_path[i] if each.include?(':')
        end

        route_params.merge(request.params)
      end

      private

      def path_regexp(path)
        handler_path = path.split('/')
        handler_path.map { |piece| piece.replace('.*') if piece.match?(':') }
        handler_path.join('/')
      end

      def correct_path?(path)
        length_ok?(path) && (/^#{@path_regexp}$/).match?(path)
      end

      def length_ok?(path)
        @path.split('/').length == path.split('/').length
      end

    end
  end
end
