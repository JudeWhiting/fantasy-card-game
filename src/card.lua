Card = {}
Card.__index = Card

function Card.new(name, desc, dmg, cost)

    local self = setmetatable({}, Card)
    self.name = name
    self.desc = desc
    self.dmg = dmg
    self.cost = cost

    self.x = nil
    self.y = nil
    self.startX = nil
    self.startY = nil
    self.width = 150
    self.height = 200
    self.minWidth = 150
    self.minHeight = 200
    self.maxWidth = 180
    self.maxHeight = 240
    
    return self
end

function Card:enlarge(screenHeight)
    self.width = self.width + ((self.maxWidth - self.minWidth)/10)
    self.height = self.height + ((self.maxHeight - self.minHeight)/10)
    self.x = self.x - ((self.maxWidth - self.minWidth)/20)
    self.y = self.y - (((self.maxHeight - self.minHeight)/10) + (((self.startY + self.minHeight) - screenHeight)/10))
end

function Card:reduce(screenHeight)
    self.width = self.width - ((self.maxWidth - self.minWidth)/10)
    self.height = self.height - ((self.maxHeight - self.minHeight)/10)
    self.x = self.x + ((self.maxWidth - self.minWidth)/20)
    self.y = self.y + (((self.maxHeight - self.minHeight)/10) + (((self.startY + self.minHeight) - screenHeight)/10))
end