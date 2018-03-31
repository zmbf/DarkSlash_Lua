local start =class("SceneMenuMain")
local ScenePlay = require "classes/ScenePlay"
function start:ctor()
  self:onCreate()
end
function start:onCreate()
    self.creatorReader = creator.CreatorReader:createWithFilename ('scenes/StartGame.ccreator')
    self.creatorReader:setup()
    self.myScene = self.creatorReader:getSceneGraph()
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
  self.myScene:registerScriptHandler(onSceneEvent)
  cc.Director:getInstance():replaceScene (self.myScene)
end
function start:enter()

end
function start:entertransitionfinish()
     local animationManager = self.creatorReader:getAnimationManager()  
     local nodeForAction = cc.Sprite:create ()
     self.myScene:addChild (nodeForAction)
     nodeForAction:runAction(cc.Sequence:create(cc.DelayTime:create(0.25),cc.CallFunc:create(function(args)
         local menuAnim = self.myScene:getChildByName ('Canvas'):getChildByName ('menuAnim') 
         animationManager:playAnimationClip(menuAnim,"menuAnim")
     end),cc.DelayTime:create(0.3),cc.CallFunc:create(function()
            local child = self.myScene:getChildByName ('Canvas'):getChildByName ('menuAnim') 
            local btnGroups =  child:getChildByName('btnGroups')
            local btnPlay = btnGroups:getChildByName('btn_play')
            btnPlay:addTouchEventListener(function(sender,eventType)
                  if eventType == ccui.TouchEventType.began then
                       -- cc.Director:getInstance():endToLua()
                       print("begin")
                  elseif eventType == ccui.TouchEventType.moved then
                       print("moved")
                  elseif eventType == ccui.TouchEventType.ended then                   
                      btnPlay:setTouchEnabled(false)	
                      ScenePlay.create()               
                  elseif eventType == ccui.TouchEventType.canceled then
                      print("canceled")
                  end
            
            end) 
     end)))
end
function start:exit()

end
function start:exittransitionstart()

end
function start:cleanup()

end
return start
