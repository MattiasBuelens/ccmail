--[[

	CCMail
	Message compose view

--]]

local FlowContainer = require "ccgui.FlowContainer"
local GridContainer = require "ccgui.GridContainer"
local TextElement	= require "ccgui.TextElement"
local TextArea		= require "ccgui.TextArea"
local TextInput		= require "ccgui.TextInput"
local Button		= require "ccgui.Button"
local Align			= require "ccgui.Align"
local VAlign		= require "ccgui.VAlign"

local ComposeView = FlowContainer:subclass("ccmail.ComposeView")
function ComposeView:initialize(opts)
	opts.horizontal = false
	
	super.initialize(self, opts)
	
	self.header = FlowContainer:new{
		horizontal = true
	}
	self.fields = GridContainer:new{
		stretch = true,
		padding = 1,
		colSpacing = 1,
		colSpecs = {
			GridContainer.GridSpec:new(false),
			GridContainer.GridSpec:new(true)
		},
		rowSpecs = {
			GridContainer.GridSpec:new(false),
			GridContainer.GridSpec:new(false),
		}
	}
	self.toLabel = TextElement:new{
		rowIndex = 1,
		colIndex = 1,
		text = "To:",
		align = Align.Right
	}
	self.toField = TextInput:new{
		rowIndex = 1,
		colIndex = 2
	}
	self.subjectLabel = TextElement:new{
		rowIndex = 2,
		colIndex = 1,
		text = "Subject:",
		align = Align.Right
	}
	self.subjectField = TextInput:new{
		rowIndex = 2,
		colIndex = 2
	}
	self.fields:add(self.toLabel, self.toField, self.subjectLabel, self.subjectField)
	
	self.sendButton = Button:new{
		text = "Send",
		valign = VAlign.Middle
	}
	self.header:add(self.fields, self.sendButton)
	
	self.messageInput = TextArea:new{
		stretch = true
	}
	self:add(self.header, self.messageInput)
	
	self.sendButton:on("buttonpress", self.sendPressed, self)
end

function ComposeView:getTo()
	return self.toField:getText()
end
function ComposeView:getSubject()
	return self.subjectField:getText()
end
function ComposeView:getMessage()
	return self.messageInput:getText()
end

function ComposeView:sendPressed()
	self:trigger("sendpress", self:getTo(), self:getSubject(), self:getMessage())
end

-- Exports
return ComposeView