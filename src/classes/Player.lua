
local player =class("player")

function player:ctor()
end
function player:init(node,parentClass)
	self.parentClass = parentClass
    self.game = self.parentClass.game
	self.animationManager = self.parentClass.creatorReader:getAnimationManager()
    --添加事件监听
    self.node = node
    local function onSceneEvent(event)  
        if event == "enter" then
           self:enter(game)
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
function player:enter()
    self:initData()
end
function player:entertransitionfinish()
    ----开启update函数 
    local function handler(interval)
         self:update(interval)
    end
    self.node:scheduleUpdateWithPriorityLua(handler,0)
end
function player:update(dt)
     local this = self
     if (self.isAlive == false) 
	 then
            return
	 end
	
     if (self.isAttacking) 
	 then
            if (self.isAtkGoingOut and self:shouldStopAttacking() ) 
			then
                self.node:stopAllActions()
                self.onAtkFinished(self)
            end
     end

     if (self.inputEnabled and self.moveToPos and this.isTouchHold(self)) 
	 then
            local dir = cc.pSub(self.moveToPos, self.node:getPosition())
            local rad = cc.pToAngle(dir)
            local deg = cc.radiansToDegrees(rad)
            self.spArrow:setRotation(90-deg)
--            this.node.emit('update-dir', {
--                dir: cc.pNormalize(dir)
--            })
     end
end
function player:exit()

end
function player:exittransitionstart()

end
function player:cleanup()

end
function player:initData(game)
    self.fxTrail = self.node:getChildByName("trail")
    self.spArrow = self.node:getChildByName("arrow")
	self.node:setVisible(true)
    self.sfAtkDirs = {
        cc.SpriteFrameCache:getInstance():getSpriteFrame('p1_attack_u.png'),
        cc.SpriteFrameCache:getInstance():getSpriteFrame('p1_attack_66_up.png'),
        cc.SpriteFrameCache:getInstance():getSpriteFrame('p1_attack_45_up.png'),
        cc.SpriteFrameCache:getInstance():getSpriteFrame('p1_attack_22_up.png'),
        cc.SpriteFrameCache:getInstance():getSpriteFrame('p1_attack_r.png'),
        cc.SpriteFrameCache:getInstance():getSpriteFrame('p1_attack_22_down.png'),
        cc.SpriteFrameCache:getInstance():getSpriteFrame('p1_attack_45_down.png'),
        cc.SpriteFrameCache:getInstance():getSpriteFrame('p1_attack_45_down.png'),
        cc.SpriteFrameCache:getInstance():getSpriteFrame('p1_attack_66_down.png'),
        cc.SpriteFrameCache:getInstance():getSpriteFrame('p1_attack_d.png'),
   }
    self.attachPoints = {
        cc.p(3.6,88.2),
        cc.p(23,89.6),
        cc.p(33.2,79.3),
        cc.p(38.3,64.2),
        cc.p(47.5,46.4),
        cc.p(34.8,15.8),
        cc.p(30.7,1.5),
        cc.p(20,0.9),
        cc.p(-3.5,1.9)
    }
    self.sfPostAtks = {cc.SpriteFrameCache:getInstance():getSpriteFrame('p1_stand_u.png'),cc.SpriteFrameCache:getInstance():getSpriteFrame('p1_stand_r.png'),cc.SpriteFrameCache:getInstance():getSpriteFrame('p1_stand_d.png')}
    self.spPlayer = self.node:getChildByName("sprite")
    self.spSlash = self.node:getChildByName("sprite"):getChildByName("slash")
    self.hurtRadius = 30
    self.touchThreshold =  0.3
    self.touchMoveThreshold = 50
    self.atkDist =  300
    self.atkDuration = 0.2
    self.atkStun = 0.1
    self.invincible = false
    --cc.SpriteFrameCache:getInstance():addSpriteFrames("creator/atlas/player.plist","creator/atlas/player.png")
    --local test = cc.SpriteFrameCache:getInstance():getSpriteFrame('p1_stand_u.png')
 
    self.anim = self.node:getChildByName("sprite")
    self.inputEnabled = false
    self.isAttacking = false
    self.isAlive = true
    self.nextPoseSF = null
    self:registerInput()
    
    self.spArrow:setVisible(false)
    self.atkTargetPos = cc.p(0,0)
    self.isAtkGoingOut = false
    --待测试
    self.validAtkRect = cc.rect(25, 25, (self.node:getParent():getBoundingBox().width- 25), (self.node:getParent():getBoundingBox().height - 25))
    
    self.oneSlashKills = 0
    --animationManager:playAnimationClip(menuAnim,"menuAnim")
end
function player:registerInput()
      local listener = cc.EventListenerTouchOneByOne:create() 
      listener:registerScriptHandler(function(touch,event)
--       if self.inputEnabled == false
--       then
--          return true
--       end
         local touchLoc = touch:getLocation()
         self.touchBeganLoc = touchLoc
         self.moveToPos = self.node:getParent():convertToNodeSpaceAR(touchLoc)
         self.touchStartTime = socket.gettime()
         return true
      end,cc.Handler.EVENT_TOUCH_BEGAN) 
      listener:registerScriptHandler(function(touch,event)
--         if self.inputEnabled == false
--         then
--             return
--         end
         local touchLoc = touch:getLocation()
         self.spArrow:setVisible(true)
         self.moveToPos = self.node:getParent():convertToNodeSpaceAR(touchLoc)
         if cc.pGetDistance(self.touchBeganLoc, touchLoc) > self.touchMoveThreshold
         then
              self.hasMoved = true
         end


      end,cc.Handler.EVENT_TOUCH_MOVED) 
      listener:registerScriptHandler(function(touch,event)
--         if self.inputEnabled == false 
--         then
--             return
--         end
           self.spArrow:setVisible(false)
           self.moveToPos = nil
--			 self.node.emit('update-dir', {
--                    dir: null
--                })
           local isHold = self:isTouchHold(self)
           if not self.hasMoved and not isHold  --不是移动
           then
              local touchLoc = touch:getLocation()
              local atkPos = self.node:getParent():convertToNodeSpace(touchLoc)
			  --向量方向 
              local atkDir = cc.pSub(atkPos, cc.p(self.node:getPosition()))

			  -- 点击位置向量Normalize * 攻击距离   与 人物位置的  向量和			
              self.atkTargetPos = cc.pAdd(cc.p(self.node:getPosition()), self:pMult(cc.pNormalize(atkDir), self.atkDist) )
              --  self.atkTargetPos 1136*640 内
              local atkPosWorld = self.node:getParent():convertToWorldSpace(self.atkTargetPos)
              if not cc.rectContainsPoint(self.validAtkRect, atkPosWorld) 
              then
                  self.isAtkGoingOut = true
              else 
                  self.isAtkGoingOut = false
              end
                    --self.node.emit('freeze')
              self.oneSlashKills = 0
              self:attackOnTarget(atkDir, self.atkTargetPos)
            end
            self.hasMoved = false
      end,cc.Handler.EVENT_TOUCH_ENDED)
      listener:registerScriptHandler(function(touch,event)
      
      end,cc.Handler.EVENT_TOUCH_CANCELLED)
     
      cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener,self.node)
end
function player:pMult(point, floatVar)
    return cc.p(point.x * floatVar, point.y * floatVar)
end
function player:isTouchHold()
     local timeDiff = socket.gettime() - self.touchStartTime
     return ( timeDiff >= self.touchThreshold)
end
--返回两个向量之间带正负号的弧度
function player:pAngleSigned(a, b)
    local a2 = cc.pNormalize(a)
    local b2 = cc.pNormalize(b)							--cc.pDot 两个向量之间进行点乘
    local angle = math.atan2(a2.x * b2.y - a2.y * b2.x, cc.pDot(a2, b2))
    if math.abs(angle) < tonumber('1.192092896e-07')
    then
        return 0.0
    end
    return angle
end
function player:radiansToDegrees(angle)
     return angle * (180 /math.pi)
end

function player:attackOnTarget (atkDir, targetPos)
       local deg = self:radiansToDegrees(self:pAngleSigned(cc.p(0, 1), cc.p(atkDir)))
       local angleDivider = {0, 12, 35, 56, 79, 101, 124, 146, 168, 180}
       local slashPos = null
	   --获取 atkSF  和   self.nextPoseSF 的 SpriteFrame
       local getAtkSF = function(mag, sfAtkDirs)
            local atkSF = null
            for i = 2, table.getn(angleDivider),1 do
                local min = angleDivider[i - 1]
                local max = angleDivider[i]
                if mag <= max and mag > min
                then
                    atkSF = sfAtkDirs[i - 1]
                    self.nextPoseSF = self.sfPostAtks[math.floor(( i - 1 )/3)]
                    slashPos = self.attachPoints[i - 1]
                    return atkSF
                end
            end
            if atkSF == null
            then
                print('cannot find correct attack pose sprite frame! mag: ' + mag)
                return null
            end
        end

        local mag = math.abs(deg)
        if deg <= 0
        then
            self.spPlayer:setScaleX(1)
            self.spPlayer:setSpriteFrame(getAtkSF(mag, self.sfAtkDirs))
            --self.spPlayer.spriteFrame = getAtkSF(mag, self.sfAtkDirs)
        else 
            self.spPlayer:setScaleX(-1)
            self.spPlayer:setSpriteFrame(getAtkSF(mag, self.sfAtkDirs))
           -- self.spPlayer.spriteFrame = getAtkSF(mag, self.sfAtkDirs)
        end
        local moveAction = cc.EaseQuinticActionOut:create(cc.MoveTo:create(self.atkDuration, cc.p(targetPos)))
        local delay = cc.DelayTime:create(self.atkStun)
		local this = self
        local callback = cc.CallFunc:create(handler(self,self.onAtkFinished))
        self.node:runAction(cc.Sequence:create(moveAction, delay, callback))

        self.spSlash:setPosition(cc.p(slashPos.x+self.spSlash:getParent():getAnchorPointInPoints().x,slashPos.y+self.spSlash:getParent():getAnchorPointInPoints().y))
        self.spSlash:setRotation(mag)
        self.spSlash:setVisible(true)
        --self.spSlash:getComponent(cc.Animation).play('slash')
		self.animationManager:playAnimationClip(self.spSlash,"slash")

        self.inputEnabled = false
        self.isAttacking = true
end
function player:onAtkFinished()
		if self.nextPoseSF
		then
            self.spPlayer:setSpriteFrame(self.nextPoseSF)
        end
       
        self.spSlash:setVisible(false)
        self.inputEnabled = true
        self.isAttacking = false
        self.isAtkGoingOut = false
        if self.oneSlashKills >= 3 
		then
            --this.game.inGameUI.showKills(this.oneSlashKills)
        end
end
function player:addKills()
	self.oneSlashKills = self.oneSlashKills+1
	--this.game.inGameUI.addCombo()
end
function player:revive ()
	local hideCB = cc.callFunc(function()
            self.node:setVisible(false)
        end,self)
       local action = cc.sequence(cc.delayTime(0.6), hideCB)
end
function player:dead()
	if self.invincible
	then
		return
	end
	--this.node.emit('freeze')
    self.isAlive = false
    self.isAttacking = false
    self.inputEnabled = false
    --this.anim.play('dead')
end

function player:corpse()
	 --this.anim.play('corpse')
     --this.scheduleOnce(self.death, 0.7)
	 local schedule
	 schedule = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
		self.death()
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedule)
	 end, 0.7, false)
end
function player:death()
	--this.game.death()
end
function player:shouldStopAttacking()
        if not self
        then
			return
		end
		local curWorldPos = cc.p(self.node:getParent():convertToWorldSpace(cc.p(self.node:getPosition())))
        local targetWorldPos = cc.p(self.node:getParent():convertToWorldSpace(cc.p(self.atkTargetPos)))
        if ( (curWorldPos.x < self.validAtkRect.x and targetWorldPos.x < self.validAtkRect.x) or
            (curWorldPos.x > self.validAtkRect.x+self.validAtkRect.width and targetWorldPos.x > self.validAtkRect.x+self.validAtkRect.width) or
            (curWorldPos.y < self.validAtkRect.y and targetWorldPos.y < self.validAtkRect.y) or
            (curWorldPos.y > self.validAtkRect.y+self.validAtkRect.height and targetWorldPos.y > self.validAtkRect.y+self.validAtkRect.height)  ) 
		then
            return true      
        else 
            return false
        end
end
return player

