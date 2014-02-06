--[[

	CCMail
	Message box view

--]]

local FlowContainer		= require "ccgui.FlowContainer"
local ScrollWrapper		= require "ccgui.ScrollWrapper"
local MessageView		= require "ccmail.MessageView"
local MessageListItem	= require "ccmail.MessageListItem"

local BoxView = FlowContainer:subclass("ccmail.BoxView")
function BoxView:initialize(opts)
	opts.horizontal = true
	
	super.initialize(self, opts)
	
	self.messagesList = ccgui.FlowContainer:new{
		horizontal = false
	}
	self.messagesScroll = ccgui.ScrollWrapper:new{
		horizontal = false,
		vertical = true,
		content = self.messagesList
	}
	self.messageView = MessageView:new{
		stretch = true
	}
	
	self:add(self.messagesScroll, self.messageView)
end

function BoxView:setMessages(messages)
	self.messagesList:removeAll()
	for i,message in ipairs(messages) do
		local item = MessageListItem:new{
			message = message
		}
		item:on("buttonpress", function()
			self.messageView:setMessage(message)
		end, self)
		self.messagesList:add(item)
	end
	self.messageView:setMessage(messages[1])
	self:markRepaint()
end

-- Exports
return BoxView