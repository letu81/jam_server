#encoding: utf-8

require 'socket'

class Server
    def initialize( port, ip )
        @server = TCPServer.open( ip, port )
        run
    end
    
    def run
        loop {
            Thread.start(@server.accept) do | client |
                while msg = client.gets.chomp
                    p msg
                    client.puts msg
                end
                client.close
            end
        }.join
    end
end

Server.new( 6009, "127.0.0.1" )