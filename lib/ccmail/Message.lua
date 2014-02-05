--[[

	CCMail
	Mail message

--]]

local Object = require "objectlua.Object"

local Message = Object:subclass("ccmail.Message")
function Message:initialize(tMessage)
	self.id = tMessage.nID
	self.from = tMessage.sFrom
	self.subject = tMessage.sSubject
	self.message = tMessage.sMessage
	self.read = tMessage.bRead or false
end
function Message:__tostring()
	return "Message["
		.. "#" .. tostring(self.id)
		.. ",f=" .. tostring(self.from)
		.. ",s=" .. tostring(self.subject)
		.. "]"
end

-- Exports
return Message