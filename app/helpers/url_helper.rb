module UrlHelper
  def add_query_params(url, params)
    parsed_uri = URI(url)

    if parsed_uri.query
      query_params = URI.decode_www_form(parsed_uri.query)
    else
      query_params = []
    end

    params.each_pair do |k, v|
      query_params << [k.to_s, v]
    end

    parsed_uri.query = URI.encode_www_form(query_params)
    parsed_uri.to_s
  end
end
