Player = {}
Player.__index = Player

function Player.new(deck, health, energy, startTurnDrawCount)
  local self = setmetatable({}, Player)
  self.deck = deck
  self.hand = {}
  self.drawPile = {}
  self.discardPile = {}

  self.health = health
  self.energy = energy
  self.startTurnDrawCount = startTurnDrawCount

  self.maxHealth = health
  self.maxEnergy = energy
  self.maxDraw = startTurnDrawCount
  self.maxHandSize = 6


  return self

end


function Player:enterCombat()
  -- self.drawPile = self.deck
  self.drawPile = self:shuffleCards(self.deck)
  self:drawCards(self.startTurnDrawCount)
end


function Player:drawCards(drawCount)
  local drawCount = drawCount or self.startTurnDrawCount
  if drawCount <= #self.drawPile then
    for _ = 1, drawCount do
      if #self.hand >= self.maxHandSize then break end
      table.insert(self.hand, self.drawPile[1])
      table.remove(self.drawPile, 1)
    end
    self:setHandPositions()
  else
    drawCount = drawCount - #self.drawPile
    for _ = 1, #self.drawPile do
      if #self.hand >= self.maxHandSize then break end
      table.insert(self.hand, self.drawPile[1])
      table.remove(self.drawPile, 1)
    end
    self.discardPile = self:shuffleCards(self.discardPile)
    self.drawPile = self.discardPile
    self.discardPile = {}
    self:drawCards(drawCount < #self.drawPile and drawCount or #self.drawPile)
  end
end


function Player:shuffleCards(inputArr)
  local shuffledArr = {}
  local randN = nil
  for _ = 1, #inputArr do
    randN = math.random(#inputArr)
    table.insert(shuffledArr, inputArr[randN])
    table.remove(inputArr, randN)
  end
  return shuffledArr
end


function Player:setHandPositions()
  for i = 1, #self.hand do
    self.hand[i].startX = 20 + (self.hand[i-1] and self.hand[i-1].startX+self.hand[i-1].minWidth or 0)
    self.hand[i].x = self.hand[i].startX
    self.hand[i].startY = Screen.height - 150
    self.hand[i].y = self.hand[i].startY
    self.hand[i].width = self.hand[i].minWidth
    self.hand[i].height = self.hand[i].minHeight
  end
end


function Player:endTurn()
  -- for _ = 1, #self.hand do
  --   table.insert(self.discardPile, self.hand[1])
  --   table.remove(self.hand, 1)
  -- end
  self.energy = self.maxEnergy
  self:drawCards(self.startTurnDrawCount)
end


function Player:displayHand()
  local fontTitle = love.graphics.newFont(20)
  local fontBody = love.graphics.newFont(14)
  local fontTitleHeight = fontTitle:getHeight()
  for i = 1, #self.hand do
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", self.hand[i].x, self.hand[i].y, self.hand[i].width, self.hand[i].height)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(fontTitle)
    love.graphics.print(self.hand[i].name, self.hand[i].x, self.hand[i].y)
    love.graphics.setFont(fontBody)
    love.graphics.print(self.hand[i].desc, self.hand[i].x, self.hand[i].y + fontTitleHeight + 10)
    love.graphics.print("cost: " .. self.hand[i].cost, self.hand[i].x, self.hand[i].y + (fontTitleHeight*2) + 10)
  end
end

function Player:displayStats()
  love.graphics.setFont(GenericFont)
  love.graphics.setColor(1, 1, 1)
  love.graphics.print("Health: " .. self.health, Screen.width - 200, Screen.height - 100)
  love.graphics.print("Energy: " .. self.energy, Screen.width - 200, Screen.height - 100 + GenericFontHeight)
end

function Player:doCard(card, enemy)
  enemy.health = enemy.health - card.dmg
  self.energy = self.energy - card.cost
end