# Wocket - 0.0.1

* [Homepage](https://github.com/bradylove/wocket#readme)
* [Issues](https://github.com/bradylove/wocket/issues)

## Description

Wocket is a simple WebSocket server and client built on top of Celluloid::IO.
Currently only the server portion of Wocket is useable. I have been testing Wocket
using [http://autobahn.ws/testsuite](http://autobahn.ws/testsuite) and only have a handful of cases where I am seeing red.

## Install

    $ gem install wocket

## Examples
### Server

Save the following as a .rb file. Ex server.rb

    require 'wocket'
    server = Wocket::Server.new

    server.bind(:onopen) do |ws|
      puts "Client connected"
    end

    server.bind(:onmessage) do |ws, data, type|
      puts "Message received"
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

Then run it :)

     $ ruby server.rb

This will start wocket on port 9292. More details coming soon :)

### Client

Not yet available.

## Copyright

Copyright (c) 2013 Brady Love

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
