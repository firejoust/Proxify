require "socket"
require "option_parser"

def error (usage, message)
    puts "ERROR: #{message}\n"
    puts usage
    exit 1
end

def fatal (message)
    puts "FATAL: #{message}"
    exit 1
end

def client_inbound(client, remote)
    while (message = client.receive[0]).size > 0
        remote << message.not_nil! 
    end
rescue exception
    puts "[#{client.remote_address}] remotebound - #{exception}"
    client.close
    remote.close
end

def remote_inbound(client, remote)
    while (reply = remote.receive[0]).size > 0
        client << reply.not_nil!
    end
rescue exception
    puts "[#{remote.remote_address}] clientbound - #{exception}"
    client.close
    remote.close
end

usage = nil
bind_address = nil
remote_address = nil
bind_port = nil
remote_port = nil

OptionParser.parse do |parser|
    # set args behaviour
    parser.banner = "Usage: proxify [args]"
    parser.on "-a", "--bind-address <address>", "The address to listen on" { |address| bind_address = address }
    parser.on "-p", "--bind-port <port>", "The port to listen on" { |port| bind_port = port.to_u16? }
    parser.on "-A", "--remote-address <address>", "The address to forward to" { |address| remote_address = address }
    parser.on "-P", "--remote-port <port>", "The port to forward to" { |port| remote_port = port.to_u16? }

    usage = parser.to_s
    parser.invalid_option { error(usage, "Invalid argument specified") }
    parser.missing_option { error(usage, "All arguments must associate a value") }
end

# sufficient data has been specified
if bind_address.nil?
    error(usage, "Bind address must be specified")
elsif bind_port.nil?
    error(usage, "Bind port must be between 0-65535")
elsif remote_address.nil?
    error(usage, "Remote address must be specified")
elsif remote_port.nil?
    error(usage, "Remote port must be between 0-65535")
end

begin
    puts "Starting TCP stream on #{bind_address}:#{bind_port} -> #{remote_address}:#{remote_port}"
    local = TCPServer.new(bind_address.not_nil!, bind_port.not_nil!)

    while client = local.accept?
        puts "[#{client.remote_address}] New connection"
        remote = TCPSocket.new(remote_address.not_nil!, remote_port.not_nil!)
        spawn client_inbound(client, remote)
        spawn remote_inbound(client, remote)
    end
rescue exception
    fatal exception
end