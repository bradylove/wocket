require 'wocket'

server = Wocket::Server.new

server.bind(:onopen) do |ws|
  puts "Client connected"
end

server.bind(:onmessage) do |ws, data, type|
  puts "Message received"

  ws.push data, type
end

server.bind(:onerror) do |ws, code, reason|
  puts "ERROR: Code: #{code}, Reason: #{reason}"
end

server.bind(:onclose) do |ws, code, reason|
  puts "Connection closed: #{code} - #{reason}"
end

server.start

trap("INT") { server.terminate; exit }
sleep
