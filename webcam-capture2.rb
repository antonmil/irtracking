#!/usr/bin/env ruby

require 'socket'
require 'base64'
require 'net/http'

class WebCamera
 BOUNDARY = "--myboundary\n"
 def initialize(host, port=80, user="webcam", pass="panasonic")
   @sock = TCPSocket.new(host,port)
   auth = ["#{user}:#{pass}"].pack("m").chomp!
   @sock.write "GET /nphMotionJpeg?Resolution=640x480&Quality=Standard HTTP/1.0\r\n"
   @sock.write "Authorization: Basic #{auth}\r\n"
   @sock.write "\r\n"
   for i in 0...4
     @sock.gets # dummy
   end
 end
 def fetch
   l = @sock.readline(BOUNDARY)
   l.sub!(/^Content-type: image\/jpeg\n\n/,'')
   l.sub!(/\n#{BOUNDARY}$/,'')
   return l
 end
end

# wc = WebCamera.new('133.87.136.178',80,'webcam','panasonic')
wc = WebCamera.new('133.87.136.179',80,'webcam','panasonic')
loop do
 t = Time.now
 # filename = t.strftime("data/webcams/c2/%Y%m%d-%H%M%S.jpg")
 filename = t.strftime("data/webcams/c2/%Y%m%d-%H%M%S-%1N.jpg")
 File.open(filename, "w").binmode.write(wc.fetch)
end