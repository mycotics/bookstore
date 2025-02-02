require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)


class DataLayerMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)
    request = Rack::Request.new(env)

    if Thread.current[:data_layer]
      data_layer = Thread.current[:data_layer]
      Thread.current[:data_layer] = nil
      if (300..399).include?(status)
        cookie_value = CGI.escape(data_layer.to_json)
        add_cookie(headers, "data_layer", cookie_value)
      else
        headers['X-DataLayer'] = data_layer.to_json
      end
    else
      if (cookie_value = request.cookies["data_layer"])
        headers['X-DataLayer'] = cookie_value
        if status == 200
          delete_cookie(headers, "data_layer")
        end
      end
    end
    [status, headers, response]
  end

  private

  def add_cookie(headers, name, value)
    cookie_str = "#{name}=#{value}; path=/; HttpOnly"
    if headers['Set-Cookie']
      if headers['Set-Cookie'].is_a?(Array)
        headers['Set-Cookie'] << cookie_str
      else
        headers['Set-Cookie'] = [headers['Set-Cookie'], cookie_str]
      end
    else
      headers['Set-Cookie'] = cookie_str
    end
  end

  def delete_cookie(headers, name)
    cookie_str = "#{name}=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT"
    if headers['Set-Cookie']
      if headers['Set-Cookie'].is_a?(Array)
        headers['Set-Cookie'] << cookie_str
      else
        headers['Set-Cookie'] = [headers['Set-Cookie'], cookie_str]
      end
    else
      headers['Set-Cookie'] = cookie_str
    end
  end
end


module Bookstore
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.

    # require_relative '#{root}/lib/middleware/data_layer_middleware'

    # config.autoload_paths << "#{root}/lib/middleware"

    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])



    # puts Rails.root.join('lib', 'middleware')

    # config.middleware.use DataLayerMiddleware

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    # config.eager_load_paths << Rails.root.join("middleware")
    # config.autoload_paths << Rails.root.join('app', 'middleware')
    # config.eager_load_paths << Rails.root.join('app', 'middleware')

    # require Rails.root.join('middleware', 'data_layer_middleware')
    
    config.middleware.use DataLayerMiddleware

  end
end
