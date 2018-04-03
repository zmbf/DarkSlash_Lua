--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
local LuaFile =class("LuaFile")
function LuaFile:ctor()
end
function LuaFile:init(node,parent)
	self.node = node
	self.parent = parent
    --添加事件监听
   
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
function LuaFile:enter()
    
end
function LuaFile:entertransitionfinish()
    ----开启update函数 
    local function handler(interval)
         self:update(interval)
    end
    self.node:scheduleUpdateWithPriorityLua(handler,0)
end
function LuaFile:update(dt)
    
end
function LuaFile:exit()

end
function LuaFile:exittransitionstart()

end
function LuaFile:cleanup()

end
return LuaFile

