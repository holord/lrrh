--local font = require "font"

local story = {}
local skills = {}
skills["animal handling"] = 0
skills["strength"] = 0
skills["perception"] = 0
skills["persuasion"] = 0
skills["witchcraft"] = 0

local click = false
local text
local message = nil
local ch -- Choice
local p = 20
local y 
local points = 2
local firstSetSkill = true

local function init()
    story.current = story.start
    skills = {}
    skills["animal handling"] = 0
    skills["strength"] = 0
    skills["perception"] = 0
    skills["persuasion"] = 0
    skills["witchcraft"] = 0

    click = false
    text = nil
    message = nil
    ch = nil
    p = 20
    points = 2
    firstSetSkill = true
end

love.graphics.setDefaultFilter("nearest", "nearest")
local redImage = love.graphics.newImage("red.png")
local wolfImage = love.graphics.newImage("wolf.png")

local function textdraw()
    local scale = love.graphics.getWidth() * love.graphics.getHeight() * 3 / (800 * 600)
    love.graphics.draw(redImage, 0, love.graphics.getHeight()-38*scale, 0, scale, scale)
    love.graphics.draw(wolfImage, love.graphics.getWidth()-25*scale, love.graphics.getHeight()-38*scale, 0, scale, scale)

    y = p
    if(message) then
        love.graphics.setColor(message.color)
        love.graphics.printf(message.text, p, y, love.graphics.getWidth() - p)

        local width, wrappedtext = font:getWrap(message.text, love.graphics.getWidth() - p)
        local yadd = font:getHeight() * (#wrappedtext + 0.75)

        y = y + yadd
        love.graphics.setColor(1, 1, 1)
    end

    love.graphics.printf(text, p, y, love.graphics.getWidth() - p)
end

local function choices() -- Button
    local width, wrappedtext = font:getWrap(text, love.graphics.getWidth() - p)
    local yadd = font:getHeight() * (#wrappedtext + 0.75)

    y = y + yadd + 10

    local res = nil
    for i, choice in ipairs(ch) do
        local x = p + 40

        local w = love.graphics.getWidth() - 1.4 * x - p
        local width, wrappedtext = font:getWrap(choice[2], w)
        local h = font:getHeight() * 1.25 * (#wrappedtext)

        local mx, my = love.mouse.getPosition()
        if(mx > x and mx < x + w and my > y and my < y + h) then
            love.graphics.setColor(0.1, 0.1, 0.1)
            if(love.mouse.isDown(1)) then
                click = true
                love.graphics.setColor(0, 0.2, 1)
            elseif(click) then
                res = choice[1]
                click = false
            end
            love.graphics.rectangle("fill", x - 10, y, w, h)

            love.graphics.setColor(1, 1, 1)
        end

        love.graphics.printf(choice[2], x, y, w)
        y = y + 10 + font:getHeight(choice[2])
    end

    if(not love.mouse.isDown(1)) then click = false end

    message = nil
    return res
end

story.menu = {}
story.menu.draw = function()
    text = "Little Red Riding Hood\nA text-based RPG"

    ch =
    {
        {"start", "Start game"},
        {"exit", "Exit"}
    }

    textdraw()
    local chosen = choices()

    if(chosen == "start") then
        story.current = story.start
    elseif(chosen == "exit") then
        love.event.quit()
    end
end

story.start = {}
story.start.draw = function()
    text = "Good morning Little Red Riding Hood! Have you slept well? A new day has just awoken, there is a lot to do around \z
    the house. What would you like to do?"

    ch =
    {
        {"cook", "Cook"},
        {"help", "Help your mother"},
        {"read", "Read"},
        {"visit", "Visit your grandmother"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "cook") then
        story.current = story.cook
    elseif(chosen == "help") then
        story.current = story.help
    elseif(chosen == "read") then
        story.current = story.read
    elseif(chosen == "visit") then
        story.current = story.visit
    end
end

-------- To do --------

story.cook = {}
story.cook.draw = function()
    text = "You get the water ready for a delicious soup. While the water starts bubbling you finely chop the vegetables and clean \z
    the hen your mother just killed. Soon you add everything to the water, in goes some seasoning too and you are done!"

    ch =
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "continue") then
        story.current = story.start
    end
end

story.help = {}
story.help.draw = function()
    text = "Your mother asks you to plant cabbage and tomatoes while she trims the trees. Since you don't really like working in \z
    the garden, you get through it quickly and sit down looking at the birds."

    ch =
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "continue") then
        story.current = story.start
    end
end

story.read = {}
story.read.draw = function()
    text = "The day hasn't started, yet you are already bored. You pick up your new book about wolves and read a few pages. Soon \z
    you put the book down with a horrified look on your face. From what you have read they are great hunters and are always \z
    thinking of cunning ways to obtain fresh meat. You wish you never meet one ever in your lifetime."

    ch =
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "continue") then
        story.current = story.start
    end
end

story.visit = {}
story.visit.draw = function()
    text = "You decide to go to your grandmother's house. She's been sick for the past week and can't get out of bed. You pack \z
    her food in a basket and head off to the heart of the woods where her house is."

    ch =
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "continue") then
        story.current = story.notebook
    end
end

story.notebook = {}
story.notebook.draw = function()
    text = "Suddenly you hear a voice calling after you. As you turn around you see your mother running after you and without a \z
    word she hands you a little notebook which you recognise immediately. Then she sends you off and walks back to the house."

    ch =
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "continue") then
        story.current = story.setSkill -- set skills
    end
end

-------- Special book from mother --------

-- 2 points to spend, the choice is yours
story.setSkill = {}
story.setSkill.draw = function()
    if(firstSetSkill) then
        text = "What you see now in your hands is a magic imbued notebook in which you see five categories. You recall a memory \z
        of your mother telling you once that you can gain inhuman power with the help of this little book. You promise yourself \z
        you will keep it safe and use it wisely. Now, what new powers would you like to learn?"
    else
        text = "What new powers would you like to learn?"
    end
    
    if(points == 0) then
        ch =
        {
            {"continue", "Continue"},
        }
    else
        ch =
        {
            {"animal handling", "Animal Handling "},
            {"strength", "Strength "},
            {"perception", "Perception "},
            {"persuasion", "Persuasion "},
            {"witchcraft", "Witchcraft "},
        }

        for i, skill in ipairs(ch) do
           skill[2] = skill[2] .. skills[skill[1]] .. "/2"
        end
    end

    textdraw()
    local chosen = choices()

    if(chosen == "continue" and firstSetSkill) then
        firstSetSkill = false
        story.current = story.forest
    elseif(chosen == "continue") then
        story.current = story.powers
    elseif(chosen and points > 0)then
        if(skills[chosen] < 2) then
            skills[chosen] = skills[chosen] + 1
            points = points - 1
        end
    end
end

-------- Picking flowers --------

-- In the following I broke up the text in order to narrate/ create tension between the lines
story.forest = {}
story.forest.draw = function()
    text = "Soon your house is out of sight but knowing the way you continue on without fear. You and your mother have done \z
    the trip several times and you know the path by heart. On your way you observe the beauty of the woods, listen to the song \z
    of birds and enjoy the breeze that strokes your cheeks."

    ch =
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "continue") then
        story.current = story.forest2
    end
end

story.forest2 = {}
story.forest2.draw = function()
    text = "You observe a patch of wild flowers off the path and decide your grandmother would love them. Although your mother \z
    has warned you not to stray off the path you still think some flowers could not harm anyone."

    ch =
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "continue") then
        story.current = story.meadow
    end
end

-------- First chance for survival--------

story.meadow = {}
story.meadow.draw = function()
    if(skills["perception"] == 0) then
        message = {}
        message.text = "Perception lvl. 1 fail"
        message.color = {0.75, 0, 0}
        text = "While you pick daisies you notice that it suddenly got darker but only in a circle around you. As you stand still \z
        you begin to hear something breathing behind you, too late you realise it could be a hungry wolf. You know any sudden \z
        movement could cost your life so you slowly stand up, your heart beating faster then ever and walk back towards the path."

        ch =
        {
            {"continue", "Continue"},
        }
    
        textdraw()
        local chosen = choices()
    
        if(chosen == "continue") then
            story.current = story.meadow2
        end
    elseif(skills["perception"]) then
        message = {}
        message.text = "Perception lvl. 1 success"
        message.color = {0, 0.75, 0}
        text = "While picking flowers you feel the presence of another. Your senses tell you you're in danger so with one great \z
        jump you avoid the attack and find yourself eye to eye with the hungry wolf. It growls at you..."

        ch =
        {
            {"continue", "Continue"},
        }

        textdraw()
        local chosen = choices()

        if(chosen == "continue") then
            story.current = story.dialogue
        end
    end
end

story.meadow2 = {}
story.meadow2.draw = function()
    text = "You can feel the beast's presence behind you, it must be hungry. When you finally step on the well-known cobblestones of \z
    the path, you hear a jaw clenching and a sudden warmth starts spreading all over your body."

    ch =
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "continue") then
        story.current = story.meadow3
    end
end

story.meadow3 = {}
story.meadow3.draw = function()
    text = "As you look down at your feet you see blood spilling everywhere and the wolf getting ready for another attack."
    
    ch =
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "continue") then
        story.current = story.meadow4
    end
end

story.meadow4 = {}
story.meadow4.draw = function()
    text = "The last things you see are its eyes and you know it is the end. You want to scream but no sound comes out, it ate you... \z
    THE END"
    
    ch =
    {
        {"restart", "Restart game"},
        {"exit", "Exit game"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "restart") then
        story.current = story.start
        init()
    elseif(chosen == "exit") then
        love.event.quit()
    end
end

story.dialogue = {}
story.dialogue.draw = function()
    text = "You reply: \"I am on my way to my grandmother's house\". It seems to consider your reply then growls again."
    
    ch =
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "continue") then
        story.current = story.dialogue2
    end
end

story.dialogue2 = {}
story.dialogue2.draw = function()
    text = "You say: \"She lives not far away from here, just after crossing the stream.\" The wolf suddenly runs off in the \z
    opposite direction but you give it no attention since you're not in danger anymore. You growl back at it, putting an end \z
    to the conversation, and head off towards your grandmother's."

    ch =
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "continue") then
        story.current = story.walk
    end
end

-------- Rest by the lake --------

story.walk = {}
story.walk.draw = function()
    text = "Slowly following the path you admire the beauty of your surroundings. Huge butterflies fly by, you hear woodpeckers \z
    working in the distance, flowers bloom all around and you know the forest is busy alive."

    ch =
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "continue") then
        story.current = story.walk2
    end
end

story.walk2 = {}
story.walk2.draw = function()
    text = "You look up to check the position of the sun and notice it's soon noon, no surprise you're hungry. Knowing the lake \z
    from which the stream starts is not far away, you head in the direction."

    ch =
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "continue") then
        story.current = story.walk3
    end
end

story.walk3 = {}
story.walk3.draw = function()
    text = "A couple of minutes later you find yourself at the feet of the great lake. You find a shady spot and have your \z
    elevenses. Sitting there the food doesn't taste good because you're still troubled by the earlier encounter with the wolf \z
    and you realise you're trembling."

    ch =
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "continue") then
        story.current = story.lake
    end
end

story.lake = {}
story.lake.draw = function()
    text = "You get ready to leave but before you head off you notice the notebook is nowhere to be found! A sudden fear spreads \z
    inside you."

    ch =
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "continue") then
        story.current = story.lake2
    end
end

story.lake2 = {}
story.lake2.draw = function()
    text = "After running around for minutes you sit back down feeling miserable. You can't believe you have already lost the \z
    precious thing. You start packing everything back in the basket. When you stand up you see a shiny spot in you peripheral \z
    vision. Turning around you lose it but after a time you notice it shining again in the sunlight."

    ch =
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "continue") then
        story.current = story.lake3
    end
end

story.lake3 = {}
story.lake3.draw = function()
    text = "You get closer and find your notebook opened in the grass. You pick it up fast. Turn it in your hands. Examine it. \z
    Nothing happened to it, you probably dropped it. You thank God you found it and in light of what has just happened, you decide \z
    spending 2 points on your skills before you lose it again."

    ch =
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "continue") then
        points = 2
        story.current = story.setSkill -- set skills
    end
end

-------- Twists --------

story.powers = {}
story.powers.draw = function()
    if(skills["witchcraft"] == 2) then
        -------- Being a witch --------
        message = {}
        message.text = "Witchraft lvl. 2 success"
        message.color = {0, 0.75, 0}
        text = "You decide you want to see how strong your witch skills are so you call out to the spririt of the woods and ask \z
        them to lend you all their power. As you feel the energy flowing through your veins, you concentrate on the hairy body of \z
        the wolf. Not a second later you locate it, deep in the forest."
        
        ch =
        {
            {"continue", "Continue"},
        }

        textdraw()
        local chosen = choices()

        if(chosen == "continue") then
            story.current = story.witch
        end
    elseif(skills["animal handling"] == 2 and skills["persuasion"] == 1) then
        -------- Preparation for the battle --------
        message = {}
        message.text = "Animal Handling lvl. 2 success\nPersuasion lvl. 1 success"
        message.color = {0, 0.75, 0}
        text = "You feel it's time to punish the wolf... You call out to the animals of the forest and form an allince against the \z
        wolf. You form a council with representatives of each type of animal in the troops. After hours of planning you finally \z
        come to a great plan of ambush."

        ch =
        {
            {"continue", "Continue"},
        }

        textdraw()
        local chosen = choices()

        if(chosen == "continue") then
            story.current = story.plan
        end
    else
        text = "Not long after crossing the stream you succesfully arrive to your grandmother's house. You take the key from under \z
        the doormat and open the front door. You set the table for a lunch for two and call after your grandmother. She doesn't \z
        answer... You know she usually sleeps in the afternoon but not before lunch so you go in to her room to check if everything's \z
        fine."

        ch =
        {
            {"continue", "Continue"},
        }

        textdraw()
        local chosen = choices()

        if(chosen == "continue") then
            story.current = story.house
        end
    end
end

-------- Witching --------

story.witch = {}
story.witch.draw = function()
    text = "You charm it with you energy and make it come to you. You see fiery anger in its eyes but you feel safe with you powers. \z
    Despite your powers the wolf opens its mouth, saliva dripping from it and you realise it still wants to eat you. The wolf gathers \z
    energy for an attack."

    ch =
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "continue") then
        story.current = story.witch2
    end
end

story.witch2 = {}
story.witch2.draw = function()
    text = "Noticing the momentum you grab hold of its tongue and pull it with all your might... and, there, in front of your eyes you \z
    find the wolf is nothing more than a pink, skinny abomination. You turned it inside out! It runs off in shame, never to be seen \z
    again... THE END"

    ch =
    {
        {"restart", "Restart game"},
        {"exit", "Exit game"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "restart") then
        story.current = story.start
        init()
    elseif(chosen == "exit") then
        love.event.quit()
    end
end

-------- The battle --------

story.plan = {}
story.plan.draw = function()
    text = "Your infantry will be made of foxes who rely on their speed and will attack the wolf in bursts. While they hold \z
    the front, cavalry of rodents on the back of elks will keep firing rocks at the beast to disturb its concentration. If \z
    any side of the army gets hurt and falls, a group of five brown bears will flank that side of the enemy. After the \z
    council you decide on holding the event the next day while the wolf drinks its morning water by the stream."

    ch =
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "continue") then
        story.current = story.battle
    end
end

story.battle = {}
story.battle.draw = function()
    text = "The next day, before sunrise everyone takes their position. You are in the front, ready to signal the attack. All you \z
    need is the wolf. But it is nowhere to be seen... You all start panicking."

    ch = 
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "continue") then
        story.current = story.battle2
    end
end

story.battle2 = {}
story.battle2.draw = function()
    text = "After some time it finally arrives and you signal the attack. Everyone jumps from their hideout, takes their position \z
    and the wolf is held tight. It is very annoyed and you can see it fights back. The battle seems like an eternity..."

    ch = 
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "continue") then
        story.current = story.battle3
    end
end

story.battle3 = {}
story.battle3.draw = function()
    text = "The wolf is a great fighter you notice, it keeps trying to create a hole in your defences and escape. Just when this \z
    happens the bears run from behind the trees while the cavalry and infantry closes in. Soon the wolf is captured!"

    ch = 
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "continue") then
        story.current = story.battle4
    end
end

story.battle4 = {}
story.battle4.draw = function()
    text = "You let the bears torture it for some time and when it is on its edge you signal for its last breath. In that moment the \z
    bears tear him apart with ease. It is cruelty, you admit, but it is necessary to deal with an enemy like the wolf. THE END"

    ch = 
    {
        {"restart", "Restart game"},
        {"exit", "Exit game"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "restart") then
        story.current = story.start
        init()
    elseif(chosen == "exit") then
        love.event.quit()
    end
end

-------- The grandmother's house --------

story.house = {}
story.house.draw = function()
    -------- Surprise --------
    text = "Upon entering the room a chill goes down your spine. Your poor grandmother is very sick you noticed... She is asleep \z
    but looks terrible. She has huge ears and eyes, her hands are very hairy and from her mouth big yellow teeth stick out. You \z
    can't not scream."

    ch = 
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()

    if(chosen == "continue") then
        story.current = story.houseBedroom
    end
end

story.houseBedroom = {}
story.houseBedroom.draw = function()
    if(skills["strength"] == 2) then
        -------- Beat the wolf up with a ladle --------
        message = {}
        message.text = "Strength lvl. 2 success"
        message.color = {0, 0.75, 0}
        text = "Your shriek wakes up your grandmother who turns out to be the wolf in disguise! You start running while it gets out \z
        of bed and not knowing what to do, you grab a ladle from the kitchen and turn to face the beast. My God, what were you \z
        thinking? A little girl wanting to beat up a hungry wolf with a kitchen ladle... But you don't back off, you are ready to \z
        face the beast."

        ch = 
        {
            {"continue", "Continue"},
        }

        textdraw()
        local chosen = choices()

        if(chosen == "continue") then
            story.current = story.houseLadle
        end
    else
        -------- Everyone dies --------
        text = "Your scream wakes up your grandmother who turns out to be the wolf in disguise! The sudden terror paralyses you \z
        and not being able to move, you break down crying before the wolf eats you. Through the falling tears you see the beast opening \z
        its mouth and down you go into its stomach, fulfilling the hunger of the big bad wolf. THE END"

        ch = 
        {
            {"restart", "Restart game"},
            {"exit", "Exit game"},
        }

        textdraw()
        local chosen = choices()

        if(chosen == "restart") then
            story.current = story.start
            init()
        elseif(chosen == "exit") then
            love.event.quit()
        end
    end
end

story.houseLadle = {}
story.houseLadle.draw = function()
    text = "Ladle in the hand, you dodge its first attack and try to hit back. You give it a whack to the head, you catch it \z
    unprepared. It becomes furious and scratches you with its claws. You feel great pain in your arm and become fed up with the \z
    wolf."

    ch =
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()
    if(chosen == "continue") then
        story.current = story.houseLadle2
    end
end

story.houseLadle2 = {}
story.houseLadle2.draw = function()
    text = "You enter a berserk mode, not experiencing any further pain, and beat it up clearly. You hit it as hard as you can in \z
    the chest and while it staggers you whack it once again in the head. It then falls prone on to the wooden floor, unconscious."
    
    ch =
    {
        {"continue", "Continue"},
    }

    textdraw()
    local chosen = choices()
    if(chosen == "continue") then
        story.current = story.houseLadle3
    end
end

story.houseLadle3 = {}
story.houseLadle3.draw = function()
    text = "This is all too much for you so you run back home and promise yourself you'll not leave home for a while. THE END"
    
    ch = 
    {
        {"restart", "Restart game"},
        {"exit", "Exit game"},
    }

    textdraw()
    local chosen = choices()
        
    if(chosen == "restart") then
        story.current = story.start
        init()
    elseif(chosen == "exit") then
        love.event.quit()
    end
end

return story
