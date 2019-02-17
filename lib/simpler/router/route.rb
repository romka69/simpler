module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :path

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(method, path)
        init_path = parse_path(@path)
        @method == method && length_ok?(path) && (/^#{init_path}$/).match?(path)
      end

      private

      def parse_path(path)
        handler_path = path.split('/')
        handler_path.map { |piece| piece.replace('.*') if piece.match?(':') }
        handler_path.join('/')
      end

      def length_ok?(path)
        @path.split('/').length == path.split('/').length
      end

    end
  end
end
