Enemy = {}
Enemy.__index = Enemy

function Enemy.new(name, dmg, health)
    local self = setmetatable({}, Enemy)

    self.name = name
    self.dmg = dmg
    self.health = health

    self.maxHealth = health
    self.maxDmg = dmg

    self.loopsSinceLastTurn = 100

    return self

end

function Enemy:doTurn(player)
    player.health = player.health - self.dmg
    self.loopsSinceLastTurn = 0
end



function Enemy:displayEnemy()
    love.graphics.setFont(GenericFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(self.name, (Screen.width/2) - (GenericFont:getWidth(self.name)/2), (Screen.height/2) - 100)
    love.graphics.print("health: " .. self.health, (Screen.width/2) - (GenericFont:getWidth(self.name)/2), (Screen.height/2) + GenericFontHeight - 100)
    
    if self.loopsSinceLastTurn < 100 then
        self.loopsSinceLastTurn = self.loopsSinceLastTurn + 1

        love.graphics.setColor(1, 0, 0)
        love.graphics.print(self.name .. " dealt " .. self.dmg .. " damage!!", (Screen.width/2) - (GenericFont:getWidth(self.name .. " dealt " .. self.dmg .. " damage!!")/2), (Screen.height/2) + GenericFontHeight)
    end

end