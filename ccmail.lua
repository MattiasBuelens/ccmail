--[[

	CCMail
	Graphical mail client

--]]


local root = fs.combine(shell.getRunningProgram(), "../lib/")
dofile(fs.combine(root, "/compat.lua"))
package.root = root

local ccgui				= require "ccgui"
local Scheduler			= require "concurrent.Scheduler"
local Thread			= require "concurrent.Thread"
local Client			= require "ccmail.Client"
local LoginView			= require "ccmail.LoginView"
local MessageListItem	= require "ccmail.MessageListItem"
local MessageView		= require "ccmail.MessageView"

local client
local scheduler = Scheduler:new()

local screen = ccgui.Page:new{
	stretch = true,
	horizontal = false,
	scheduler = scheduler,
	background = colours.white,
	_name = "screen"
}

local menuBar = ccgui.menu.MenuBar:new{
	_name = "menuBar"
}
local menuFile = ccgui.menu.Menu:new{}
local btnLogout = menuFile:addButton("Log out")
local btnExit = menuFile:addButton("Exit")
menuBar:addMenu("CCMail", menuFile)

local loginView = LoginView:new{
	stretch = true,
	padding = 3
}

local inboxView = ccgui.FlowContainer:new{
	stretch = true,
	visible = false,
	horizontal = true
}
local messagesList = ccgui.FlowContainer:new{
	horizontal = false,
	_name = "messagesList"
}
local messagesScroll = ccgui.ScrollWrapper:new{
	horizontal = false,
	vertical = true,
	content = messagesList,
	_name = "messagesScroll"
}
local messageView = MessageView:new{
	stretch = true,
	_name = "messageView"
}
inboxView:add(messagesScroll, messageView)
screen:add(menuBar, loginView, inboxView)

function loadMessages()
	local messages = client:get()
	messagesList:removeAll()
	for i,message in ipairs(messages) do
		local item = MessageListItem:new{
			message = message
		}
		item:on("buttonpress", function()
			messageView:setMessage(message)
		end, item)
		messagesList:add(item)
	end
end
function logout()
	if client then
		client:close()
		client = nil
	end
	inboxView:hide()
	loginView:show()
end
function login()
	local address, password = loginView:getAddress(), loginView:getPassword()
	local task = Thread:new(function()
		client = Client:new(address, password)
		client:open()
		loadMessages()
		loginView:hide()
		inboxView:show()
	end, function(ok, err)
		if not ok then
			-- TODO Show in UI
			error(err)
		end
	end)
	task:start(scheduler)
end

loginView:on("loginpress", function()
	logout()
	login()
end)
btnLogout:on("buttonpress", function()
	logout()
end)
btnExit:on("buttonpress", function()
	logout()
	screen:stop()
end)

screen:run()

-- Restore
screen:reset()