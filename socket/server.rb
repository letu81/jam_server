require 'socket'
require 'timeout'
require 'rubygems'
require 'json'
require 'rest-client'

class Server
    def initialize( port, ip )
        @server = TCPServer.open( ip, port )
        @port = port
        @connections = Hash.new
        @down_clients = Hash.new
        @up_clients = Hash.new
        @gateways = Hash.new
        @macs = Array.new
        @mobile_macs = Array.new
        @close_clients = Array.new
        @connections[:server] = @server
        @connections[:down_clients] = @down_clients
        @connections[:up_clients] = @up_clients
        @api_url = "http://192.168.0.105:3000"
        run
    end

    def run
        loop {
            Thread.start(@server.accept) do | client |
                ip = @server.addr.last
                p "start...#{client}=====ip:#{ip}"
                while msg = client.gets.chomp
                    rmsg = msg.gsub("\u0000", "").gsub(/^[.]+req/, "req").gsub("\"", "").gsub("}", "")
                    p msg
                    begin
                        res = {}
                        rmsg.split(/,/).each do |val|
                            k,v = val.strip.split(/:/)
                            k = k.include?("req") ? "req" : k
                            res[k] = v.nil? ? "" : v
                        end
                        mac = res['mac']
                        req = res['req']
                        cmd = res['cmd'].strip
                        dev_id = res['device_id']
                        dev_type = res['device_type']
                        reverse_req = req == "up" ? "down" : "up"
                        mobile_mac = res['mobile_mac']
                        data = res['data']
                        @macs << mac unless @macs.include?(mac)
                        @mobile_macs << mobile_mac unless @mobile_macs.include?(mobile_mac)
                        # {'222333' =>  {'clients' => { '1111' => client, '2222' => client} } }
                        if req == "down"
                            @down_clients[mac] ||= {}
                            @down_clients[mac]['clients'] ||= {}
                            if @down_clients[mac]['clients'][mobile_mac]
                                @close_clients << @down_clients[mac]['clients'][mobile_mac] 
                            end
                            @down_clients[mac]['clients'][mobile_mac] = client
                            if @up_clients[mac] && @up_clients[mac]['client']
                                begin
                                    if cmd == "heartbeat"
                                        p "send hearbeat to app"
                                        client.puts res.merge({'req' => 'up', 'status' => '1'}).to_json
                                    end
                                    p "sent msg to gateway: #{res}"
                                    if cmd == "sync_time"
                                        @up_clients[mac]['client'].puts res.merge({'data' => Time.new.strftime("%Y-%m-%d %H:%M:%S")}).to_json
                                    else
                                        @up_clients[mac]['client'].puts res.to_json
                                    end
                                rescue
                                    p "send hearbeat to app"
                                    client.puts res.merge({'cmd' => 'hearbeat', 'req' => 'up', 'status' => '2'}).to_json
                                end
                            else
                                client.puts res.merge({'req' => 'up', 'status' => '2'}).to_json
                            end
                        else
                            # {'222333' => {'client' => client, 'activtied_on' => '2017-03-01 12:21:32'} }
                            @up_clients[mac] ||= {}
                            if @up_clients[mac]['client']
                                if (@up_clients[mac]['activtied_on'] + 30) < Time.now
                                    @close_clients << @up_clients[mac]['client']
                                    @up_clients[mac]['client'] = client
                                end
                                @up_clients[mac]['activtied_on'] = Time.now
                            else
                                @up_clients[mac]['client'] = client
                                @up_clients[mac]['activtied_on'] = Time.now
                            end

                            p "receive msg from gateway:#{res}"

                            unless "hearbeat" == cmd
                                dev_id = dev_id.rjust(4, 'z') unless dev_id.length == 4
                                if @down_clients[mac] && @down_clients[mac]['clients'][mobile_mac]
                                    p "send msg to app:#{res}"
                                    begin
                                        @down_clients[mac]['clients'][mobile_mac].puts res
                                    rescue Exception => e
                                        @close_clients << @down_clients[mac]['clients'][mobile_mac] 
                                        p e.message
                                    end
                                end
                                cmd_arrs = ["card_open", "pwd_open", "finger_open", "low_power", "tamper", "door_bell", 
                                            "finger_add", "finger_del", "pwd_add", "pwd_del", "card_add", "card_del",
                                            "illegal_key", "illegal_try", "lctch_bolt", "dead_bolt"]
                                if cmd_arrs.include?(cmd)
                                    p "=========rest start: #{cmd}========="
                                    begin
                                        if data.strip.length > 0
                                            device_num = data.strip.gsub(data.strip[0,4], "").each_byte.map { |b| b.to_s(16) }.join.to_i(16)
                                            types = {:finger => 1, :password => 2, :card => 3}
                                            case cmd
                                            when cmd.include?("finger")
                                                RestClient.post "#{@api_url}/api/v1/devices/listen", {device_mac:mac, device_token:dev_id, device_cmd:cmd, lock_type:types[:finger], device_num:device_num}
                                            when cmd.include?("pwd")
                                                RestClient.post "#{@api_url}:3009/api/v1/devices/listen", {device_mac:mac, device_token:dev_id, device_cmd:cmd, lock_type:types[:password], device_num:device_num}
                                            when cmd.include?("card")
                                                RestClient.post "#{@api_url}:3009/api/v1/devices/listen", {device_mac:mac, device_token:dev_id, device_cmd:cmd, lock_type:types[:card], device_num:device_num}
                                            else
                                                RestClient.post "#{@api_url}:3009/api/v1/devices/listen", {device_mac:mac, device_token:dev_id, device_cmd:cmd}
                                            end
                                        else
                                            RestClient.post "#{@api_url}:3009/api/v1/devices/listen", {device_mac:mac, device_token:dev_id, device_cmd:cmd}
                                        end
                                    rescue Exception => e
                                        p e.message
                                        p "rest error...."
                                    end
                                    p "==========rest end==================="
                                end
                                sleep 2
                                @close_clients.each do |close_client|
                                    close_client.close
                                end
                            else
                                if @down_clients[mac] && @down_clients[mac]['clients'][mobile_mac]
                                    begin
                                        p "send msg to app:#{res}"
                                        @down_clients[mac]['clients'][mobile_mac].puts res
                                    rescue Exception => e
                                        @close_clients << @down_clients[mac]['clients'][mobile_mac]
                                        p e.message
                                    end
                                end
                                client.puts "server receive msg: #{res.to_json}"
                                begin
                                    if @gateways[mac].nil? || @gateways[mac]!=@port
                                        RestClient.post "#{@api_url}/api/v1/devices/port/update", {device_mac:mac, gateway_port:@port}
                                        @gateways[mac] = @port
                                    end
                                rescue Exception => e
                                    p e.message
                                    p "rest error...."
                                end
                            end
                        end
                    rescue
                        p "========json parse error== #{msg}=============="
                        client.puts res.to_json
                    end
                end
                @close_clients.each do |close_client|
                    close_client.close
                end
            end
        }.join
    end
end

Server.new( 3001, "192.168.0.105" )