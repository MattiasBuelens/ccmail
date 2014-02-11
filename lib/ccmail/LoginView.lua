--[[

	CCMail
	Login view

--]]

local FlowContainer = require "ccgui.FlowContainer"
local GridContainer = require "ccgui.GridContainer"
local TextElement	= require "ccgui.TextElement"
local TextInput		= require "ccgui.TextInput"
local PasswordInput	= require "ccgui.PasswordInput"
local Button		= require "ccgui.Button"
local Align			= require "ccgui.Align"
local Margins		= require "ccgui.geom.Margins"

local LoginView = FlowContainer:subclass("ccmail.LoginView")
function LoginView:initialize(opts)
	opts.horizontal = false
	opts.spacing = 1
	
	super.initialize(self, opts)
	
	self.fields = GridContainer:new{
		colSpacing = 1,
		rowSpacing = 1,
		colSpecs = {
			GridContainer.GridSpec:new(false),
			GridContainer.GridSpec:new(true)
		},
		rowSpecs = {
			GridContainer.GridSpec:new(false),
			GridContainer.GridSpec:new(false),
		}
	}
	
	self.addressLabel = TextElement:new{
		rowIndex = 1,
		colIndex = 1,
		text = "Address:",
		align = Align.Right
	}
	self.addressField = TextInput:new{
		rowIndex = 1,
		colIndex = 2
	}
	self.passwordLabel = TextElement:new{
		rowIndex = 2,
		colIndex = 1,
		text = "Password:",
		align = Align.Right
	}
	self.passwordField = PasswordInput:new{
		rowIndex = 2,
		colIndex = 2
	}
	self.fields:add(self.addressLabel, self.addressField, self.passwordLabel, self.passwordField)
	
	self.loginButton = Button:new{
		text = "Log in",
		align = Align.Center
	}
	self:add(self.fields, self.loginButton)
	
	self.loginButton:on("buttonpress", self.loginButtonPressed, self)
end

function LoginView:getAddress()
	return self.addressField:getText()
end
function LoginView:getPassword()
	return self.passwordField:getText()
end
function LoginView:loginButtonPressed()
	self:trigger("loginpress", self:getAddress(), self:getPassword())
end

-- Exports
return LoginView