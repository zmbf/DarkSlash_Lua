local SortMng =class("SortMng")
function SortMng:ctor()
end
function SortMng:initData()
    self.frameCount = 0
end
function SortMng:init(node)
    --创建场景 添加事件监听
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
function SortMng:enter()
end
function SortMng:entertransitionfinish()
    self:initData()
      ----开启update函数 
    local function handler(interval)
         self:update(interval)
    end
    self.node:scheduleUpdateWithPriorityLua(handler,0)
    
--    local test ={}
--    local child =self.node:getChildByName('player')
--    for k, v in pairs(getmetatable(child)) do
--       table.insert(test,k)
--    end
--    排序
--    table.sort(test,function(a,b)
--        return  a<b
--    end)
--    for k,v in pairs(test) do
--        print(v,getmetatable(child)[v])
--    end
end
function SortMng:update(dt)
    self.frameCount=self.frameCount+1;
    if(self.frameCount % 6 == 0) then
       self:sortChildByY()
    end
end
function SortMng:sortChildByY()
     local listChild ={}
     local listToSort = self.node:getChildren()
     for k,v in ipairs(listToSort) do
        table.insert(listChild,v)
     end
     table.sort(listChild,function (a, b)
         return b:getPositionY() - a:getPositionY()
     end)
     for k,v in pairs(listChild) do
         local node = v;
         if (node:isVisible()) then --处于激活状态
             node:setLocalZOrder(k);
         end
     end
end
function SortMng:exit()

end
function SortMng:exittransitionstart()

end
function SortMng:cleanup()

end
return SortMng

