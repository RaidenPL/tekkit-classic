-- milk.lua

-- Konfiguracja
local config = {
    bucketSlot = 1,        -- slot na wiadro
    delay = 60,            -- czas między próbami (sekundy)
    cowDirection = "down", -- gdzie stoi krowa: "down", "front", "up"
    chestDirection = "up", -- gdzie jest skrzynia: "up", "back", "front", "down"
}

function log(txt)
    print("["..os.time().."] "..txt)
end

function tryGetBucket()
    turtle.select(config.bucketSlot)
    if turtle.getItemCount(config.bucketSlot) == 0 then
        if config.chestDirection == "up" then
            return turtle.suckUp()
        elseif config.chestDirection == "down" then
            return turtle.suckDown()
        elseif config.chestDirection == "front" then
            return turtle.suck()
        elseif config.chestDirection == "back" then
            turtle.turnLeft()
            turtle.turnLeft()
            local success = turtle.suck()
            turtle.turnLeft()
            turtle.turnLeft()
            return success
        end
    end
    return true
end

function tryMilk()
    turtle.select(config.bucketSlot)
    if config.cowDirection == "down" then
        return turtle.placeDown()
    elseif config.cowDirection == "front" then
        return turtle.place()
    elseif config.cowDirection == "up" then
        return turtle.placeUp()
    end
    return false
end

function tryDropMilk()
    if config.chestDirection == "up" then
        return turtle.dropUp()
    elseif config.chestDirection == "down" then
        return turtle.dropDown()
    elseif config.chestDirection == "front" then
        return turtle.drop()
    elseif config.chestDirection == "back" then
        turtle.turnLeft()
        turtle.turnLeft()
        local success = turtle.drop()
        turtle.turnLeft()
        turtle.turnLeft()
        return success
    end
end

-- Główna pętla
while true do
    if not tryGetBucket() then
        log("❌ Brak pustych wiader!")
        sleep(config.delay)
    elseif tryMilk() then
        log("✅ Wydojono!")
        if not tryDropMilk() then
            log("⚠️ Nie udało się odłożyć mleka!")
        end
    else
        log("⏳ Nie udało się wydoić.")
    end
    sleep(config.delay)
end
