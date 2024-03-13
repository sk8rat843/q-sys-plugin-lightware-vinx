-- Local Structure for holding State
LW3 = {
  Host = "",
  Port = 6107,
  Rx = ""
}

-- Build TCP Client
conn = TcpSocket.New()
conn.ReadTimeout = 0
conn.WriteTimeout = 0
conn.ReconnectTimeout = 5

-- Create and setup the Communications Timeout
timerComms = Timer.New()
timerComms.EventHandler = function(timer)
  timer:Stop()
  Controls.online.Boolean = false
  print("Connection Timed Out")
  conn:Disconnect()
  fnConnect()
end

-- Create and setup Polling
timerPoll = Timer.New()

timerPoll.EventHandler = function(timer)
  fnPoll()
end

function fnInitPoll()
  timerPoll:Stop()
  timerPoll:Start(20)
end

function fnPoll()
  -- No need for Polling - tested device returns UpTime each second
  --fnSend("GET", "/.*")
end

-- Data Sending Helper Function
function fnSend(cmd, arg)
  -- Build Packet
  local toSend = cmd .. " " .. arg
  -- Send to device
  print("-->LW::" .. toSend)
  conn:Write(toSend .. "\x0D\x0A")
  -- Reset Polling
  fnInitPoll()
end

function make_switch(inp, outp)
  fnSend("SET", string.format("/SYS/MB/PHY.VideoChannelId=%i", inp))
end

-- Setup Utility Callbacks as required
conn.Connected = function(conn)
  print("TCP socket is connected")

  -- Get Meta Data
  fnSend("GET", "/.*")

  -- Get and Subscribe to System State Data
  fnSend("GET", "/SYS")
  fnSend("OPEN", "/SYS")

  -- Enable Routing from this Module
  fnSend("SET", "/MANAGEMENT/MULTICAST.MulticastMode=true")
  fnSend("SET", "/SYS/MB/GPIO.DipSwitchEnable=false")

  -- Get and Subscribe to Video Routing Data
  fnSend("GET", "/SYS/MB/PHY.VideoChannelId")
  fnSend("OPEN", "/SYS/MB/PHY.VideoChannelId")
  fnSend("GET", "/MEDIA/VIDEO/I1")
  fnSend("OPEN", "/MEDIA/VIDEO/I1")
  -- Get and Subscribe to Input Sync Data (Encoders Only)
  fnSend("GET", "/MEDIA/VIDEO/I1")
  fnSend("OPEN", "/MEDIA/VIDEO/I1")
  if(string.find(model, "210")) then
      fnSend("GET", "/MEDIA/VIDEO/I2")
      fnSend("OPEN", "/MEDIA/VIDEO/I2")
  end
  make_switch(Controls["video_channel_id"].String)
end
conn.Reconnect = function(conn)
  print("TCP socket is reconnecting to " .. LW3.Host)
end
conn.Closed = function(conn)
  print("TCP socket was closed by the remote end")
end
conn.Error = function(conn, err)
  print("TCP socket had an error:" .. err)
end
conn.Timeout = function(conn, err)
  print("TCP socket timed out:" .. err)
end

-- Helper Function - Open TCP Connection
function fnConnect()
  print("TCP Socket Connecting")
  -- Open Connection
  conn:Connect(LW3.Host, LW3.Port)
  -- Set IP address value
  if Controls.ip_address then
      Controls.ip_address.String = LW3.Host
  end
end

local function split(str, delim)
  local result = {}
  for part in str:gmatch("[^" .. delim .. "]+") do
      result[#result + 1] = part
  end
  return result
end

-- Setup Data Callbacks as required
conn.Data = function(conn)
  -- Read out lines from the buffer
  line = conn:ReadLine(TcpSocket.EOL.Any)
  while (line ~= nil) do
      --print(line)
      -- Remove the header
      x = line:find(" ")
      if x ~= nil then
          line = line:sub(x + 1)
      end
      -- Get Path if "." is present
      x = line:find("%.")
      y = line:find("%=")
      if x ~= nil and y ~= nil then
          path = line:sub(1, x - 1)
          func = line:sub(x + 1, y - 1)
          val = line:sub(y + 1)
          -- Select Command Path'
          if path == "/" then -- Root
              -- System Status
              -- Part Number
              if func == "ProductPartNumber" then
              --Controls.PartNumber.String = val
              end
              -- Serial Number
              if func == "SerialNumber" then
                  Controls.serial_number.String = val
              end
              -- Product Name
              if func == "ProductName" then
                  Controls.model.String = val
              end
          elseif path == "/SYS" then -- Management Status
              -- Uptime
              if func == "UpTime" then
                  --Controls.UpTime.Value = val
                  -- Stop and restart Comms timer
                  timerComms:Stop()
                  if Controls.online then -- Check for when developing in a Control Script block
                      Controls.online.Boolean = true
                  end
                  timerComms:Start(30)
              end
          elseif path == "/SYS/MB/PHY" then -- Video Stream ID
              if(func == "VideoChannelId") then
                  print("VideoChannelId: " .. val)
                  Controls["video_channel_id"].String = val
              end
          elseif path == "/MEDIA/VIDEO/I1" then -- Input 01
              if(funct == "SignalPresent") then
                  Controls["input_01_sync"].Boolean = val == "1"
              end
          elseif path == "/MEDIA/VIDEO/I2" then -- Input 02
              if(funct == "SignalPresent") then
                  Controls["input_02_sync"].Boolean = val == "1"
              end
          end
      end
      -- Read a new line
      line = conn:ReadLine(TcpSocket.EOL.Any)
  end
end

-- Set IP address from Properties if present
if Properties then
  if Properties["IP Address"].Value ~= "" then
      LW3.Host = Properties["IP Address"].Value
      fnConnect()
  else
      print("IP Address Property Not Set")
  end
end
Controls["ip_address"].EventHandler = function()
  LW3.Host = Controls["ip_address"].String
  fnConnect()
end
Controls["video_channel_id"].EventHandler = function()
  make_switch(Controls["video_channel_id"].String)
end