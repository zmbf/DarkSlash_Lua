
cc.FileUtils:getInstance():setPopupNotify(false)
require "config"
require('socket.core')
require "cocos.init" 
local SceneMenuMain = require "classes/SceneMenuMain"
local ScenePlay = require "classes/ScenePlay"

local function main()

--     for k, v in pairs( getmetatable(start)) do
--          print(k, v)
--     end
     cc.FileUtils:getInstance():addSearchPath('res/creator')
   --  SceneMenuMain.create()    --主目录
     ScenePlay.create() 
   -- require("app.MyApp"):create():run()
   -- dump(cc.disable_global)
   --dump("start ")
   --dump(start())
    --local ss = new start()

--    cc.FileUtils:getInstance():addSearchPath('res/creator')

--    local creatorReader = creator.CreatorReader:createWithFilename ('scenes/StartGame.ccreator')
--    creatorReader:setup()
--    local myscene 
--    = creatorReader:getSceneGraph() 

--    local function onSceneEvent(event)
--        if event == "enter" then
--            for k, v in pairs( getmetatable(myscene:getChildByName ('Canvas'):getChildByName ('menuAnim'):getChildByName('btnGroups'))) do
--                 print(k, v)
--            end
--            myscene:getChildByName ('Canvas'):getChildByName ('menuAnim'):getChildByName('btnGroups'):pause()
--            local child = myscene:getChildByName ('Canvas'):getChildByName ('menuAnim')      
--            local temp = creatorReader:getAnimationManager ()   

           -- dump(myscene:getChildByName ('Canvas'):getChildByName ('menuAnim'):getChildByName('btnGroups'))
           -- myscene:getChildByName ('Canvas'):getChildByName ('menuAnim'):getChildByName('btnGroups'):runAction(cc.MoveTo:create(2,cc.p(900,0)))
           -- cc.Director:getInstance():getActionManager():pauseTarget(myscene:getChildByName ('Canvas'):getChildByName('menuAnim'):getChildByName('btnGroups'));
--            local co = coroutine.create (function ()
--                print(11)
--                local lable = cc.Label:createWithSystemFont (os.time ()
--                , "Arial", 20)
--                myscene:addChild (lable)
--                lable:move (display.cx, display.cy + 200)
--            end)
--            coroutine.resume (co)
--            local spschedule = cc.Sprite:create ()
--            myscene:addChild (spschedule)
--            spschedule:runAction(cc.Sequence:create(cc.DelayTime:create(4),cc.CallFunc:create(function(args)
--                temp:playAnimationClip(child,"menuAnim") 
--            end)))
--           for k, v in pairs( getmetatable(creatorReader:getAnimationManager())) do
--                print(k, v)
--           end

--            local callbackEntry   
--            callbackEntry = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(dt)  
--                temp:playAnimationClip (child, "menuAnim") --??????
----                for k, v in pairs( getmetatable(temp)) do
----                     print(k, v)
----                end
--                local registerBtnSche
--                registerBtnSche = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(dt)

--                    cc.Director:getInstance ():getScheduler ():unscheduleScriptEntry (registerBtnSche)
--                end,3.5,false)
--                cc.Director:getInstance ():getScheduler ():unscheduleScriptEntry (callbackEntry)
--            end, 0.5, false)
--            local temp = creatorReader:getAnimationManager () 
--            local child = myscene:getChildByName ('Canvas'):getChildByName ('menuAnim') 
--            child:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(function()
--                temp:playAnimationClip(child,"menuAnim")
--            end),cc.DelayTime:create(1.0),cc.CallFunc:create(function()
--               local btnGroups =  child:getChildByName('btnGroups')
--               local btnPlay = btnGroups:getChildByName('btn_play')
--               btnPlay:addTouchEventListener(function(sender,eventType)
--                     if eventType == ccui.TouchEventType.began then
--                          cc.Director:getInstance():endToLua()
--                          print("begin")
--                     elseif eventType == ccui.TouchEventType.moved then
--                          print("moved")
--                     elseif eventType == ccui.TouchEventType.ended then
--                         btnPlay:setTouchEnabled(false)	
--                     elseif eventType == ccui.TouchEventType.canceled then
--                         print("canceled")
--                     end

--               end)
--            end)))
--        elseif event == "enterTransitionFinish" then
--        -- dump(cc.FileUtils:getInstance():getSearchPaths())
--        elseif event == "exit" then

--        elseif event == "exitTransitionStart" then

--        elseif event == "cleanup" then

--        end
--    end
--    myscene:registerScriptHandler(onSceneEvent)
----     for k, v in pairs( getmetatable(myscene:getChildByName('Canvas'))) do
----          print(k, v)
----     end
--   -- myscene:getChildByName('Canvas'):setScale(0.2)
--    cc.Director:getInstance():replaceScene (myscene)
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
