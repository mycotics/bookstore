# class DataLayerMiddleware
#   def initialize(app)
#     @app = app
#   end
#
#   def call(env)
#     status, headers, response = @app.call(env)
#     if Thread.current[:data_layer]
#       headers["X-DataLayer"] = Thread.current[:data_layer].to_json
#       Rails.logger.info "Setting X-DataLayer header: #{headers['X-DataLayer']}"
#       Thread.current[:data_layer] = nil
#     end
#     [status, headers, response]
#   end
# end


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
