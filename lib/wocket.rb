module Wocket
  ROOT = File.expand_path(File.dirname(__FILE__))

  autoload :Bindable,   File.join(ROOT, 'wocket', 'bindable')
  autoload :Server,     File.join(ROOT, 'wocket', 'server')
  autoload :StatusCode, File.join(ROOT, 'wocket', 'status_code')
  autoload :VERSION,    File.join(ROOT, 'wocket', 'version')
  autoload :WebSocket,  File.join(ROOT, 'wocket', 'websocket')
end
