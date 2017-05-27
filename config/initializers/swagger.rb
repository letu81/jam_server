GrapeSwaggerRails.options.url = '/api/v1/doc'
GrapeSwaggerRails.options.before_filter_proc = proc {
  GrapeSwaggerRails.options.app_url = 'http://0.0.0.0:3000'
}