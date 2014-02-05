--[[

	CCMail
	Mail client

--]]

local EventEmitter	= require "event.EventEmitter"
local Message		= require "ccmail.Message"

local Client = EventEmitter:subclass("ccmail.Client")
function Client:initialize(address, password)
	super.initialize(self, opts)

	self.address = assert(address, "Missing address.")
	self.password = assert(password, "Missing password.")

	self.username, self.hostname = self:parseAddress(self.address)
	assert(self.username, "Bad address format.")
	
	self.hostid = nil

	self.openedModems = {}
end

function Client:parseAddress(sAddress)
	if not sAddress then return nil end

	local at = string.find(sAddress, "@")
	if not at then return nil end

	local sUsername = string.sub(sAddress, 1, at - 1)
	local sHostname = string.sub(sAddress, at + 1)

	if string.len(sUsername) > 0 and string.len(sHostname) > 0 then
		return sUsername, sHostname
	end
end

-- Open modems
function Client:open()
	for _,side in ipairs(rs.getSides()) do
		if peripheral.getType(side) == "modem" and not rednet.isOpen(side) then
			rednet.open(side)
			self.openedModems[side] = true
		end
	end
end
-- Close modems
function Client:close()
	for side,_ in pairs(self.openedModems) do
		rednet.close(side)
	end
	self.openedModems = {}
end

-- Lookup mail host
function Client:lookupHost()
	if not self.hostid then
		self.hostid = rednet.lookup("mail", self.hostname)
	end
	return assert(self.hostid, "Host not found.")
end
-- Send authenticated mail message
function Client:sendAuth(tMessage)
	-- Append authentication details
	tMessage.sUsername = self.username
	tMessage.sPassword = self.password
	-- Send to host
	return rednet.send(self:lookupHost(), tMessage, "mail")
end
-- Await mail message response
function Client:awaitResponse(checkCallback)
    -- Wait for confirmation
    local timer = os.startTimer(3)
    while true do
        local sEvent, p1, p2, p3 = os.pullEvent()
        if sEvent == "rednet_message" then
            -- Check for response
            local nSenderID, tMessage, sProtocol = p1, p2, p3
            if sProtocol == "mail" and type(tMessage) == "table" then
				local result = { checkCallback(tMessage) }
				if result[1] ~= nil then
					return unpack(result)
				end
            end
        elseif sEvent == "timer" then
            -- Check for timeout
            if p1 == timer then
                error("Timed out.")
            end
        end
    end
end

-- Retrieve mail
function Client:get()
	-- Send request
	self:sendAuth({
		sType = "get"
	})
	-- Await response
	local tMail = self:awaitResponse(function(tMessage)
		if tMessage.sType == "mail"  then
			return tMessage.tMail
		elseif tMessage.sType == "login failed" then
			error(tMessage.sReason or "Failed.")
		end
	end)
	-- Make Message objects
	local tMessages = {}
	for i,m in ipairs(tMail) do
		tMessages[i] = Message:new(m)
	end
	return tMessages
end

-- Send mail
function Client:send(toAddress, subject, message)
	-- Send request
	local nMailID = math.random(1, 2147483647)
    self:sendAuth({
		sType = "send",
		nMailID = nMailID,
		sTo = toAddress,
		sSubject = subject,
		sMessage = message
    })
	-- Await response
	return self:awaitResponse(function(tMessage)
		if tMessage.sType == "send confirmed" and tMessage.nMailID == nMailID then
			return true
		elseif (tMessage.sType == "send failed" or tMessage.sType == "login failed") and tMessage.nMailID == nMailID then
			error(tMessage.sReason or "Failed.")
		end
	end)
end

-- Exports
return Client