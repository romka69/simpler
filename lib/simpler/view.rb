require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      #template = File.read(template_path)

      #ERB.new(template).result(binding)

      ERB.new(template_path).result(binding)
    end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

    def template_path
      #path = template || [controller.name, action].join('/')

      if template.nil?
        path = [controller.name, action].join('/')

        File.read(Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb"))
      else
        template.values.join
      end
    end

  end
end
