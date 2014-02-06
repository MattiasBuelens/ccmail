--[[

	CCMail
	Main view

--]]

local FlowContainer = require "ccgui.FlowContainer"
local TabContainer	= require "ccgui.TabContainer"
local Button		= require "ccgui.Button"
local TextElement	= require "ccgui.TextElement"
local LoginView		= require "ccmail.LoginView"
local BoxView		= require "ccmail.BoxView"
local ComposeView	= require "ccmail.ComposeView"

local MainView = TabContainer:subclass("ccmail.MainView")
function MainView:initialize(opts)
	opts.horizontal = false
	opts.tabPadding = ccgui.geom.Margins:new(1, 1, 0)
	opts.tabSpacing = 1
	opts.tabBackground = colours.lightBlue
	opts.tabOpts = {
		tabOnStyle = {
			foreground = colours.black,
			background = colours.white
		},
		tabOffStyle = {
			foreground = colours.grey,
			background = colours.lightGrey
		}
	}
	
	super.initialize(self, opts)
	
	self.header = FlowContainer:new{
		horizontal = true
	}
	self.headerStretch = TextElement:new{
		stretch = true,
		background = self.tabBackground
	}
	self.headerButtons = FlowContainer:new{
		horizontal = true,
		padding = self.tabPadding,
		spacing = self.tabSpacing,
		background = self.tabBackground
	}
	self.logoutButton = Button:new{
		text = "Log out"
	}
	self.exitButton = Button:new{
		text = "Exit"
	}
	self.headerButtons:add(self.logoutButton, self.exitButton)
	
	self.loginView = LoginView:new{
		padding = 3
	}
	self.inboxView = BoxView:new{}
	self.composeView = ComposeView:new{}
	
	-- Move tab bar into header
	self:remove(self.tabBar)
	self.header:add(self.tabBar, self.headerStretch, self.headerButtons)
	self:add(self.header)
	self:move(self.header, 1)
	
	self.loginView:on("loginpress", self.loginPressed, self)
	self.composeView:on("sendpress", self.sendPressed, self)
	self.logoutButton:on("buttonpress", self.logoutPressed, self)
	self.exitButton:on("buttonpress", self.exitPressed, self)
	
	self:setClient(opts.client or nil)
end

function MainView:hasClient()
	return self:getClient() ~= nil
end
function MainView:getClient()
	return self.client
end
function MainView:setClient(client)
	self.client = client
	self:updateClient()
end
function MainView:updateClient()
	local loggedIn = self:hasClient()
	if loggedIn then
		self.exitButton:hide()
		self.logoutButton:show()
		self:addTab("Inbox", self.inboxView)
		self:addTab("Compose", self.composeView)
		self:removeTab(self.loginView)
	else
		self.logoutButton:hide()
		self.exitButton:show()
		self:addTab("Log in", self.loginView)
		self:removeTab(self.inboxView)
		self:removeTab(self.composeView)
	end
	self.header:markRepaint()
end

function MainView:setMessages(messages)
	self.inboxView:setMessages(messages)
end

function MainView:loginPressed(...)
	self:trigger("loginpress", ...)
end
function MainView:sendPressed(...)
	self:trigger("sendpress", ...)
end
function MainView:logoutPressed()
	self:trigger("logoutpress")
end
function MainView:exitPressed()
	self:trigger("exitpress")
end

-- Exports
return MainView