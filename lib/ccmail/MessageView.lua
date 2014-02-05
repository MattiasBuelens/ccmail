--[[

	CCMail
	Message detail view

--]]

local FlowContainer = require "ccgui.FlowContainer"
local TextElement	= require "ccgui.TextElement"
local TextViewer	= require "ccgui.TextViewer"
local Margins		= require "ccgui.geom.Margins"

local MessageField = FlowContainer:subclass("ccmail.MessageField")
function MessageField:initialize(opts)
	opts.horizontal = true
	
	super.initialize(self, opts)
	
	self.labelText = TextElement:new{
		text = assert(opts.label, "missing field label")
	}
	self.valueText = TextElement:new{
		text = opts.value or "",
		stretch = true
	}
	self:add(self.labelText, self.valueText)
end
function MessageField:setValue(value)
	self.valueText:setText(value)
end

local MessageView = FlowContainer:subclass("ccmail.MessageView")
function MessageView:initialize(opts)
	opts.horizontal = false
	
	super.initialize(self, opts)
	
	self.fields = FlowContainer:new{
		horizontal = false,
		padding = Margins:new(0, 0, 1)
	}
	self.subjectField = MessageField:new{
		label = "Subject: "
	}
	self.fromField = MessageField:new{
		label = "From: "
	}
	self.messageText = TextViewer:new{
		stretch = true
	}
	self.fields:add(self.subjectField, self.fromField)
	self:add(self.fields, self.messageText)
	
	self:setMessage(opts.message)
end

function MessageView:setMessage(message)
	self.message = message
	self:updateMessage()
end
function MessageView:updateMessage()
	local message = self.message or nil
	self.subjectField:setValue(message and message.subject or "")
	self.fromField:setValue(message and message.from or "")
	self.messageText:setText(message and message.message or "")
end

-- Exports
return MessageView