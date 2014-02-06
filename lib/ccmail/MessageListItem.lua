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
	
	-- Radio group
	self.radioGroup = opts.radioGroup
	assert(self.radioGroup ~= nil, "missing required radio group")
	self.radioGroup:add(self)
	
	-- Radio on/off styles
	self.radioOnStyle = opts.radioOnStyle or {
		background = colours.yellow
	}
	self.radioOffStyle = opts.radioOffStyle or {
		background = colours.white
	}
	self:radioUpdateStyle()
	
	self:on("select", self.radioUpdateStyle, self)
	self:on("unselect", self.radioUpdateStyle, self)
	
	-- Select on click
	self:on("buttonpress", self.select, self)
end

function MessageListItem:isSelected()
	return self.radioGroup:isSelected(self)
end

function MessageListItem:select()
	self.radioGroup:select(self)
end

function MessageListItem:radioUpdateStyle()
	local style = self:isSelected() and self.radioOnStyle or self.radioOffStyle
	for k,v in pairs(style) do
		self[k] = v
	end
	self:markRepaint()
end

-- Exports
return MessageListItem