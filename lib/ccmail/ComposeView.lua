--[[

	CCMail
	Message compose view

--]]

local FlowContainer = require "ccgui.FlowContainer"
local TextElement	= require "ccgui.TextElement"
local TextArea		= require "ccgui.TextArea"
local TextInput		= require "ccgui.TextInput"
local Button		= require "ccgui.Button"
local VAlign		= require "ccgui.VAlign"

local ComposeField = FlowContainer:subclass("ccmail.ComposeField")
function ComposeField:initialize(opts)
	opts.horizontal = true
	
	super.initialize(self, opts)
	
	self.labelText = TextElement:new{
		text = assert(opts.label, "missing field label")
	}
	self.valueInput = TextInput:new{
		text = opts.value or "",
		stretch = true
	}
	self:add(self.labelText, self.valueInput)
end
function ComposeField:getValue()
	return self.valueInput:getText()
end
function ComposeField:setValue(value)
	self.valueInput:setText(value)
end

local ComposeView = FlowContainer:subclass("ccmail.ComposeView")
function ComposeView:initialize(opts)
	opts.horizontal = false
	
	super.initialize(self, opts)
	
	self.header = FlowContainer:new{
		horizontal = true
	}
	self.fields = FlowContainer:new{
		horizontal = false,
		stretch = true,
		padding = 1
	}
	self.toField = ComposeField:new{
		label = "     To: "
	}
	self.subjectField = ComposeField:new{
		label = "Subject: "
	}
	self.messageInput = TextArea:new{
		stretch = true
	}
	self.sendButton = Button:new{
		text = "Send",
		valign = VAlign.Middle
	}
	self.fields:add(self.toField, self.subjectField)
	self.header:add(self.fields, self.sendButton)
	self:add(self.header, self.messageInput)
	
	self.sendButton:on("buttonpress", self.sendPressed, self)
end

function ComposeView:getTo()
	return self.toField:getValue()
end
function ComposeView:getSubject()
	return self.subjectField:getValue()
end
function ComposeView:getMessage()
	return self.messageInput:getText()
end

function ComposeView:sendPressed()
	self:trigger("sendpress", self:getTo(), self:getSubject(), self:getMessage())
end

-- Exports
return ComposeView