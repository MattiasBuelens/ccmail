--[[

	CCMail
	Message list item

--]]

local TextElement	= require "ccgui.TextElement"
local Pressable		= require "ccgui.Pressable"
local FlowContainer = require "ccgui.FlowContainer"

local MessageListItem = FlowContainer:subclass("ccmail.MessageListItem")
MessageListItem:uses(Pressable)

function MessageListItem:initialize(opts)
	opts.horizontal = false
	
	super.initialize(self, opts)
	self:pressInitialize(opts)
	
	self.message = assert(opts.message, "missing message")
	self.subjectText = TextElement:new{
		text = self.message.subject,
		foreground = opts.subjectForeground or colours.black
	}
	self.fromText = TextElement:new{
		text = self.message.from,
		foreground = opts.fromForeground or colours.grey
	}
	self:add(self.subjectText, self.fromText)
end

-- Exports
return MessageListItem