local playerFX =class("playerFX")
function playerFX:ctor()
end
function playerFX:init(node)
    --添加事件监听
    self.node = node
    local function onSceneEvent(event)  
        if event == "enter" then
           self:enter()
        elseif event == "enterTransitionFinish" then
            
           self:entertransitionfinish()

        elseif event == "exit" then

           self:exit()

        elseif event == "exitTransitionStart" then

           self:exittransitionstart()

        elseif event == "cleanup" then

           self:cleanup()

        end
    end
    node:registerScriptHandler(onSceneEvent)
end
function playerFX:enter()
    
end
function playerFX:entertransitionfinish()
    ----开启update函数 
    local function handler(interval)
         self:update(interval)
    end
    self.node:scheduleUpdateWithPriorityLua(handler,0)
end
function playerFX:update(dt)
    
end
function playerFX:exit()

end
function playerFX:exittransitionstart()

end
function playerFX:cleanup()

end
return playerFX

