--[[

	CCMail
	Message detail view

--]]

local FlowContainer = require "ccgui.FlowContainer"
local GridContainer = require "ccgui.GridContainer"
local TextElement	= require "ccgui.TextElement"
local TextViewer	= require "ccgui.TextViewer"
local Margins		= require "ccgui.geom.Margins"

local MessageView = FlowContainer:subclass("ccmail.MessageView")
function MessageView:initialize(opts)
	opts.horizontal = false
	opts.spacing = 1
	
	super.initialize(self, opts)
	
	self.fields = GridContainer:new{
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
	self.subjectLabel = TextElement:new{
		rowIndex = 1,
		colIndex = 1,
		text = "Subject:"
	}
	self.subjectText = TextElement:new{
		rowIndex = 1,
		colIndex = 2
	}
	self.fromLabel = TextElement:new{
		rowIndex = 2,
		colIndex = 1,
		text = "From:"
	}
	self.fromText = TextElement:new{
		rowIndex = 2,
		colIndex = 2
	}
	self.fields:add(self.subjectLabel, self.subjectText, self.fromLabel, self.fromText)
	
	self.messageText = TextViewer:new{
		stretch = true
	}
	self:add(self.fields, self.messageText)
	
	self:setMessage(opts.message)
end

function MessageView:setMessage(message)
	self.message = message
	self:updateMessage()
end
function MessageView:updateMessage()
	local message = self.message or nil
	self.subjectText:setText(message and message.subject or "")
	self.fromText:setText(message and message.from or "")
	self.messageText:setText(message and message.message or "")
	self:markRepaint()
end

-- Exports
return MessageView