require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

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

    require Rails.root.join('app', 'middleware', 'data_layer_middleware')

    config.middleware.use DataLayerMiddleware

  end
end
