GrapeSwaggerRails.options.url = '/api/v1/doc'
GrapeSwaggerRails.options.before_filter_proc = proc {
  GrapeSwaggerRails.options.app_url = 'http://192.168.0.105:3000'
}