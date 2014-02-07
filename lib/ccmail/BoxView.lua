--[[

	CCMail
	Message box view

--]]

local FlowContainer		= require "ccgui.FlowContainer"
local ScrollWrapper		= require "ccgui.ScrollWrapper"
local RadioGroup		= require "ccgui.RadioGroup"
local MessageView		= require "ccmail.MessageView"
local MessageListItem	= require "ccmail.MessageListItem"

local BoxView = FlowContainer:subclass("ccmail.BoxView")
function BoxView:initialize(opts)
	opts.horizontal = true
	
	super.initialize(self, opts)
	
	self.messageItems = {}
	self.messagesRadio = ccgui.RadioGroup:new{}
	self.messagesList = ccgui.FlowContainer:new{
		horizontal = false
	}
	self.messagesScroll = ccgui.ScrollWrapper:new{
		horizontal = false,
		vertical = true,
		stretch = 1,
		content = self.messagesList
	}
	self.messageView = MessageView:new{
		stretch = 2
	}
	
	self:add(self.messagesScroll, self.messageView)
end

function BoxView:setMessages(messages)
	-- Remove old items
	self.messagesList:removeAll()
	self.messageItems = {}
	-- Add new items
	for i,message in ipairs(messages) do
		local item = MessageListItem:new{
			message = message,
			radioGroup = self.messagesRadio
		}
		self.messageItems[i] = item
		item:on("select", function()
			self.messageView:setMessage(message)
		end, self)
		self.messagesList:add(item)
	end
	-- Select first item
	if self.messageItems[1] then
		self.messageItems[1]:select()
	end
	self:markRepaint()
end

-- Exports
return BoxView