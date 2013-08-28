require 'json'
require 'time'
require 'fileutils'
require 'rack'

OUTDIR = File.expand_path('requests', File.dirname(__FILE__))
FileUtils.mkdir_p(OUTDIR)

run ->(env) do
  Rack::Request.new(env).params  # parses params and adds them to evn

  if env['CONTENT_TYPE'] =~ %r{application/json}
    env['request.request.json_body'] = JSON.parse(env['rack.input'].read)
  end

  File.open(File.join(OUTDIR, "#{Time.now.iso8601}.json"), 'w') {|f|
    f << JSON.pretty_generate(env)
  }

  [200, {'Content-Type' => 'text/html'}, ['']]
end

