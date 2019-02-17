require_relative 'router/route'

module Simpler
  class Router

    def initialize
      @routes = []
    end

    def get(path, route_point)
      add_route(:get, path, route_point)
    end

    def post(path, route_point)
      add_route(:post, path, route_point)
    end

    def route_for(env)
      method = env['REQUEST_METHOD'].downcase.to_sym
      path = env['PATH_INFO']
      env['simpler.route_params'] = {}
      env_path = path.split('/')

      find_route = @routes.find { |route| route.match?(method, path) }

      return if find_route.nil?

      find_route.path.split('/').each.with_index do |piece, i|
        env['simpler.route_params'][piece.delete(':').to_sym] = env_path[i] if piece.match?(':')
      end

      find_route
    end

    private

    def add_route(method, path, route_point)
      route_point = route_point.split('#')
      controller = controller_from_string(route_point[0])
      action = route_point[1]
      route = Route.new(method, path, controller, action)

      @routes.push(route)
    end

    def controller_from_string(controller_name)
      Object.const_get("#{controller_name.capitalize}Controller")
    end

  end
end
