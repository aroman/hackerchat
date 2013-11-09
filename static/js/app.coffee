# This is the main app file

socket = io.connect()

socket.on 'derp', (data) ->
  alert "Got this from the server: #{data}"
  socket.emit "derp", "Hello from the client"