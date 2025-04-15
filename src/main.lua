require("src/card")
require("src/player")
require("src/enemy")

math.randomseed(os.time())

Screen = {
    width = 1200,
    height = 900,
}

local enemyBaseStats = {dmg = 5, health = 40}
local myEnemy = Enemy.new("Sigma Bat", 5, 40)

local myPlayer = Player.new({
    Card.new("fireball", "deal 6 fire damage", 6, 2),
    Card.new("frostbite", "deal 4 frost damage", 4, 1),
    Card.new("poisson", "deal 2 food poison damage", 2, 0),
    Card.new("fireballz", "deal 6 fire damage", 6, 2),
    Card.new("frostbitez", "deal 4 frost damage", 4, 1),
    Card.new("poissonz", "deal 2 food poison damage", 2, 0),
    Card.new("eradicate", "deal 10 explosion damage", 10, 3)},
    40,
    3,
    3
)

local endTurnBtn = {
    x = Screen.width - 120,
    y = 0,
    width = 120,
    height = 90
}

local function isMouseOver(mx, my, x, y, w, h)
    if mx >= x and my >= y and mx <= x+w and my <= y+h then
        return true
    else
        return false
    end
end

myPlayer:enterCombat()

function love.load()
    love.window.setMode(Screen.width, Screen.height)

    GenericFont = love.graphics.newFont(20)
    GenericFontHeight = GenericFont:getHeight()
    love.graphics.setFont(GenericFont)

end

function love.update(dt)
    local mx, my = love.mouse.getPosition()
    local ismouseover = nil
    SelectedCardIndex = nil

    if myPlayer.health <= 0 then
        print "You Died."
        love.event.quit()
    elseif myEnemy.health <= 0 then
        print "Enemy Slain."
        enemyBaseStats.dmg = enemyBaseStats.dmg + 1
        enemyBaseStats.health = enemyBaseStats.health + 3
        myEnemy = Enemy.new("Sigma bat", enemyBaseStats.dmg, enemyBaseStats.health)
        love.event.quit()
    end

    for k, card in ipairs(myPlayer.hand) do
        ismouseover = isMouseOver(mx, my, card.x, card.y, card.width, card.height)
        if ismouseover then
            SelectedCardIndex = k
            if card.width < card.maxWidth then
                card:enlarge(Screen.height)
            end
        elseif card.width > card.minWidth then
            card:reduce(Screen.height)
        else
        end
    end

end

function love.mousepressed(mx, my, button)
    if button ~= 1 then
        return
    end
    if SelectedCardIndex and myPlayer.hand[SelectedCardIndex].cost <= myPlayer.energy then
        -- myPlayer.hand[SelectedCardIndex]:doCard()
        --enemy.health = enemy.health - myPlayer.hand[SelectedCardIndex].dmg
        myPlayer:doCard(myPlayer.hand[SelectedCardIndex], myEnemy)
        table.insert(myPlayer.discardPile, myPlayer.hand[SelectedCardIndex])
        table.remove(myPlayer.hand, SelectedCardIndex)
    elseif isMouseOver(mx, my, endTurnBtn.x, endTurnBtn.y, endTurnBtn.width, endTurnBtn.height) then
        myEnemy:doTurn(myPlayer)
        myPlayer:endTurn()
    end
end

function love.draw()
    myPlayer:displayHand()
    myPlayer:displayStats()
    myEnemy:displayEnemy()

    -- this bit should be ut in the enemy and the end turn btn class
    love.graphics.setFont(GenericFont)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", endTurnBtn.x, endTurnBtn.y, endTurnBtn.width, endTurnBtn.height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("End Turn", endTurnBtn.x, endTurnBtn.y)
    
end