StateMachine = Class{}

function StateMachine:init(states)
    self.empty = {
        enter = function () end,
        exit = function () end,
        update = function () end,
        render = function () end
    }
    self.states = states or {}
    self.current = self.empty
end

function StateMachine:change(statename, enterParams)
    assert(self.states[statename]) --checks if requested state is valid
    self.current:exit() --exit current state
    self.current = self.states[statename]() --creates/initialize new object of new state and lets current hold it
    self.current:enter(enterParams) --enter 
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end