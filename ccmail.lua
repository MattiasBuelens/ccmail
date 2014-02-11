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
local MainView			= require "ccmail.MainView"

local client
local scheduler = Scheduler:new()

local screen = ccgui.Page:new{
	stretch = true,
	horizontal = false,
	scheduler = scheduler,
	background = colours.white,
	_name = "screen"
}
local view = MainView:new{
	stretch = true
}
local statusBar = ccgui.TextElement:new{
	foreground = colours.white,
	background = colours.lightGrey,
	_name = "statusBar"
}
screen:add(view, statusBar)

function setStatus(text)
	statusBar.foreground = colours.white
	statusBar:setText(text or "")
end
function setError(err)
	statusBar.foreground = colours.red
	statusBar:setText(err or "Error")
end

function logout()
	local task = Thread:new(function()
		if client then
			client:close()
			client = nil
		end
		setStatus("Logged out")
	end, function(task, ok, err)
		view:setClient(nil)
		if not ok then
			setError(err)
		end
	end)
	task:start(scheduler)
end
function login(address, password)
	local task = Thread:new(function()
		client = Client:new(address, password)
		client:open()
		local messages = client:get()
		view:setClient(client)
		view:setMessages(messages)
		setStatus("Logged in as "..address)
	end, function(task, ok, err)
		if not ok then
			view:setClient(nil)
			setError(err)
		end
	end)
	task:start(scheduler)
end
function send(to, subject, message)
	local task = Thread:new(function()
		client:send(to, subject, message)
		setStatus("Sent to "..to)
	end, function(task, ok, err)
		if not ok then
			setError(err)
		end
	end)
	task:start(scheduler)
end

view:on("loginpress", function(address, password)
	logout()
	login(address, password)
end)
view:on("logoutpress", function()
	logout()
end)
view:on("sendpress", function(to, subject, message)
	send(to, subject, message)
end)
view:on("exitpress", function()
	logout()
	screen:stop()
end)

-- Setup
logout()

-- Run
screen:run()

-- Teardown
logout()
screen:reset()