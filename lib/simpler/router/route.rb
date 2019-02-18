module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :path

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @init_path = path_regexp(@path)
      end

      def match?(method, path)
        @method == method && correct_path?(path)
      end

      def route_param(env)
        params = {}
        path = env['PATH_INFO']
        env_path = path.split('/')
        request_path = @path.split('/')

        request_path.each.with_index do |piece, i|
          params[piece.delete(':').to_sym] = env_path[i] if piece.match?(':')
        end

        params
      end

      private

      def path_regexp(path)
        handler_path = path.split('/')
        handler_path.map { |piece| piece.replace('.*') if piece.match?(':') }
        handler_path.join('/')
      end

      def correct_path?(path)
        length_ok?(path) && (/^#{@init_path}$/).match?(path)
      end

      def length_ok?(path)
        @path.split('/').length == path.split('/').length
      end

    end
  end
end
