--[[

	CCMail
	Login view

--]]

local FlowContainer = require "ccgui.FlowContainer"
local TextElement	= require "ccgui.TextElement"
local TextInput		= require "ccgui.TextInput"
local Button		= require "ccgui.Button"
local Align			= require "ccgui.Align"
local Margins		= require "ccgui.geom.Margins"

local LoginField = FlowContainer:subclass("ccmail.LoginField")
function LoginField:initialize(opts)
	opts.horizontal = true
	
	super.initialize(self, opts)
	
	self.labelText = TextElement:new{
		text = assert(opts.label, "missing field label")
	}
	self.valueInput = TextInput:new{
		text = opts.value or "",
		stretch = true
	}
	self:add(self.labelText, self.valueInput)
end
function LoginField:getValue()
	return self.valueInput:getText()
end
function LoginField:setValue(value)
	self.valueInput:setText(value)
end

local LoginView = FlowContainer:subclass("ccmail.LoginView")
function LoginView:initialize(opts)
	opts.horizontal = false
	opts.spacing = 1
	
	super.initialize(self, opts)
	
	self.addressField = LoginField:new{
		label = "Address:  "
	}
	self.passwordField = LoginField:new{
		label = "Password: "
	}
	self.loginButton = Button:new{
		text = "Log in",
		align = Align.Center
	}
	self:add(self.addressField, self.passwordField, self.loginButton)
	
	self.loginButton:on("buttonpress", self.loginButtonPressed, self)
end

function LoginView:getAddress()
	return self.addressField:getValue()
end
function LoginView:getPassword()
	return self.passwordField:getValue()
end
function LoginView:loginButtonPressed()
	self:trigger("loginpress")
end

-- Exports
return LoginView