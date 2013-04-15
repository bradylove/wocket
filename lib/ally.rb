module Ally
  ROOT = File.expand_path(File.dirname(__FILE__))

  autoload :Bindable,  File.join(ROOT, 'ally', 'bindable')
  autoload :Server,    File.join(ROOT, 'ally', 'server')
  autoload :VERSION,   File.join(ROOT, 'ally', 'version')
  autoload :WebSocket, File.join(ROOT, 'ally', 'websocket')
end
