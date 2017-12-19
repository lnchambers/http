class Parser

  attr_reader :path,
              :verb,
              :host,
              :http,
              :params,
              :request,
              :all_params,
              :content_length

  def initialize(request)
    @request        = request
    @verb           = request[0].split[0]
    @host           = request[1].split[1]
    @all_params     = request[0].split[1]
    @http           = request[0].split[2]
    @content_length = request[3].split[1]
    @path           = request[0].split[1].split("?")[0]
    @params         = request[0].split[1].split("?")[1].split("=")[1] unless request[0].split[1].split("?")[1].nil?
  end
end
