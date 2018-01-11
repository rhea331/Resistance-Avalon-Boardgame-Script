-- Tabletop simulator The Resistance Avalon, Scripted Roles + Lancelot
-- Made by Red Robot and Swiftcheese
-- http://steamcommunity.com/sharedfiles/filedetails/?id=816216857

--[[ Global Variables --]]
--Setting up the start button
start_button = {}
start_button_guid = 'c16794'

--Setting up all the boards of different sizes
five_board = {}
five_board_guid = 'f6027b'
six_board = {}
six_board_guid = '74cc28'
seven_board = {}
seven_board_guid = '4a8b42'
--I don't have the ninth and tenth boards but the eight is mostly the same
eight_board = {}
eight_board_guid = '5fb4ae'

--Setting up the decks and role cards
--Decks
arthur_deck = {}
arthur_deck_guid = '18f8a7'
mordred_deck = {}
mordred_deck_guid = '1b644e'
lancelot_deck = {}
lancelot_deck_guid = '3e775f'
--Role cards
merlin_card = {}
merlin_card_guid = 'edf463'
assassin_card = {}
assassin_card_guid = 'b87f2f'
percival_card = {}
percival_card_guid = '64e82b'
morgana_card = {}
morgana_card_guid = '5fe648'
oberon_card = {}
oberon_card_guid = '72d3dc'
mordred_card = {}
mordred_card_guid = '1f357e'
lancelot_arthur = {}
lancelot_arthur_guid = '60a1c1'
lancelot_mordred = {}
lancelot_mordred_guid = '389985'

arthur_max = 0
mordred_max = 0

--Setting up the yes and no vote cards
yes_deck = {}
yes_deck_guid = 'd258bd'
no_deck = {}
no_deck_guid = '8b3daf'

--leader token
leader_token = {}
leader_token_guid = '9df5e8'

--Setting up hidden zones
select_zone = {}
select_zone_guid = '765404'
trash_zone = {}
trash_zone_guid = '49803a'
trash_zone_votes = {}
trash_zone_votes_guid = '90bee8'
move_zone= {}
move_zone_guid = '73dfb0'

num_players = 0
timNum = 0
roles = {}

setNotes('Drag role cards into the white box and press START to begin.')

--[[ The OnLoad function. Called when a game finishes loading. --]]
function onload()
    --Setting up the button (that deals the roles out when pressed
    start_button = getObjectFromGUID(start_button_guid)

    local button = {}
    button.click_function = "startGame"
    button.label = 'Start'
    button.function_owner = nil
    --Not sure where this is going yet, let's put it in and see
    button.position = {0, 0, 0}
    button.rotation = {0,90,0}
    button.width = 1600
    button.height = 1200
    button.font_size = 500

    --Creates a button object called button with the properties above
    start_button.createButton(button)

    --Setting up the boards and cards, linking them with the guids
    five_board = getObjectFromGUID(five_board_guid)
    six_board = getObjectFromGUID(six_board_guid)
    seven_board = getObjectFromGUID(seven_board_guid)
    eight_board = getObjectFromGUID(eight_board_guid)

    --Setting up the decks and cards now
    arthur_deck = getObjectFromGUID(arthur_deck_guid)
    mordred_deck = getObjectFromGUID(mordred_deck_guid)
    lancelot_deck = getObjectFromGUID(lancelot_deck_guid)
    merlin_card = getObjectFromGUID(merlin_card_guid)
    assassin_card = getObjectFromGUID(assassin_card_guid)
    percival_card = getObjectFromGUID(percival_card_guid)
    morgana_card = getObjectFromGUID(morgana_card_guid)
    oberon_card = getObjectFromGUID(oberon_card_guid)
    mordred_card = getObjectFromGUID(mordred_card_guid)
    lancelot_arthur_card = getObjectFromGUID(lancelot_arthur_guid)
    lancelot_mordred_card = getObjectFromGUID(lancelot_mordred_guid)

    --Setting up yes and no votes
    yes_deck = getObjectFromGUID(yes_deck_guid)
    no_deck = getObjectFromGUID(no_deck_guid)

    --leader token

    leader_token = getObjectFromGUID(leader_token_guid)

    --Setting up hidden zones that select/delete cards
    --view these zones with the zone script option the right clicking
    --the guids will be put into chat
    select_zone = getObjectFromGUID(select_zone_guid)
    trash_zone = getObjectFromGUID(trash_zone_guid)
    move_zone = getObjectFromGUID(move_zone_guid)
    trash_zone_votes = getObjectFromGUID(trash_zone_votes_guid)
end

--Setup Function

function startGame()
    local np =  getSeatedPlayers()
    setup(#np)
    return 1
end

function setup (np)
    if np > 4 and np < 11 then
        --We need to find out what/how many cards are in the select zone
        arthur_count = 0
        lancelot_count = 0
        getMax(np)
        local inZone = select_zone.getObjects()
        for i, j in ipairs(inZone) do
            if(j.getDescription() == 'Arthur') then
                arthur_count = arthur_count + 1
            end
        end
        --Checking if there are too many arthurs
        if (arthur_count > arthur_max) then
            print('Too many Servants of Arthur! Remove some.')
            return 1
        --Checking if there are too many on mordred side
        elseif((#inZone - arthur_count) > mordred_max) then
            print('Too many Minions of Mordred! Remove some.')
            return 1
            --It's an invalid game if there is only 1 lancelot, so we need to check for it
        else
            for i, j in ipairs(inZone) do
                if(j.getName() == 'Lancelot: Arthur' or j.getName() == 'Lancelot: Mordred' ) then
                    lancelot_count = lancelot_count + 1
                end
            end
            if(lancelot_count == 1) then
                print('You must play with both, or no Lancelot characters')
                return 1
            else
                players = getSeatedPlayers()
                validGame()
                return 1
            end
        end
    end
end



    --figuring out the max arthur and mordred on each team
function boardSetup(np)
    if(np == 5) then
        destroyObject(six_board)
        destroyObject(seven_board)
        destroyObject(eight_board)
        five_board.setPosition({0, 1, 5})
        five_board.lock()
    elseif(np == 6) then
        destroyObject(five_board)
        destroyObject(seven_board)
        destroyObject(eight_board)
        six_board.setPosition({0, 1, 5})
        six_board.lock()
    elseif(np == 7) then
        destroyObject(five_board)
        destroyObject(six_board)
        destroyObject(eight_board)
        seven_board.setPosition({0, 1, 5})
        seven_board.lock()
    elseif(np == 8) then
        destroyObject(five_board)
        destroyObject(six_board)
        destroyObject(seven_board)
        eight_board.setPosition({0, 1, 5})
        eight_board.lock()
    elseif(np == 9) then
        destroyObject(five_board)
        destroyObject(six_board)
        destroyObject(seven_board)
        eight_board.setPosition({0, 1, 5})
        eight_board.lock()
    else
        destroyObject(five_board)
        destroyObject(six_board)
        destroyObject(seven_board)
        eight_board.setPosition({0, 1, 5})
        eight_board.lock()
    end
    return 1
end


function validGame()
    destroyObject(start_button)

    setNotes('There are ' .. arthur_max .. '[0000FF][b] Servants of Arthur [/b][-] and ' .. mordred_max .. '[FF0000][b] Minions of Mordred.[/b][-]')
    --Setting the max number of servants and minions
    --Moving the cards in select zone to move zone
    --setting up parameters for the cards to move to
    local params = {}
    --params.position = {-30, 1.5, -15}
    params.position = {0, 1.5, 0}

    --Moving the normal cards into the move zone
    arthur_deck.shuffle()
    mordred_deck.shuffle()
    lancelot_deck.shuffle()
    local inZone = select_zone.getObjects()
    mordred_count = #inZone - arthur_count
    --This number depends on the max number of mordred
    while(mordred_count < mordred_max) do
        mordred_deck.takeObject(params)
        mordred_count = mordred_count + 1
    end
    --This number depends on the max number of arthur
    while(arthur_count < arthur_max) do
        arthur_deck.takeObject(params)
        arthur_count = arthur_count + 1
    end
    for i, j in ipairs(inZone) do
        j.flip()
    end
    number_of_cards_in_zone = #inZone
    sleep(1, 'grabRoles')
end


    --this fucntion will bring the cards together
function grabRoles()
    local inZone = select_zone.getObjects()
    for i, j in ipairs(inZone) do
        j.setPosition{0, 1.5, 0}
        --j.setPosition({-30, 1.5, -15})
    end
    sleep(1, 'shuffleCards')
    return 1
end

function shuffleCards()
    local inZone = move_zone.getObjects()
    inZone[1].shuffle()
    sleep(1, 'dealCards')
    return 1
end

function dealCards()
    local inZone = move_zone.getObjects()
    for i, j in ipairs(players) do
        local tempCard = inZone[1].dealToColorWithOffset({0,0,0}, false, j)
        if tempCard == nil then
            print ('nil')
        end

        if(tempCard.getName() == 'Servant') then
            roles[j] = 'Servant'
        elseif(tempCard.getName() == 'Minion') then
            roles[j] = 'Minion'
        elseif(tempCard.getName() == 'Assassin') then
            roles[j] = 'Assassin'
        elseif(tempCard.getName() == 'Morgana') then
            roles[j] = 'Morgana'
        elseif(tempCard.getName() == 'Percival') then
            roles[j] = 'Percival'
        elseif(tempCard.getName() == 'Merlin') then
            roles[j] = 'Merlin'
        elseif(tempCard.getName() == 'Oberon') then
            roles[j] = 'Oberon'
        elseif(tempCard.getName() == 'Mordred') then
            roles[j] = 'Mordred'
        elseif(tempCard.getName() == 'Lancelot: Mordred') then
            roles[j] = 'Lancelot: Mordred'
        elseif(tempCard.getName() == 'Lancelot: Arthur') then
            roles[j] = 'Lancelot: Arthur'
        end

    end
    yes_deck.dealToAll(1)
    no_deck.dealToAll(1)
    sleep(1, 'identity')
    return 1
end


function identity()

    inZone = trash_zone.getObjects()
    for i, j in ipairs(inZone) do
        destroyObject(j)
    end

    inZone = trash_zone_votes.getObjects()
    for i, j in ipairs(inZone) do
        destroyObject(j)
    end

    local minions = {}

    --setting up players with role info

    --this is called minions but everyone uses this thing, needs a lot of cleanup
    for i, j in pairs(roles) do
        if j == 'Minion' then
            minions[i] = j
        --The assassin in is the minions object because she is functionally identical
        elseif j == 'Assassin' then
            minions[i] = j
        elseif j == "Merlin" then
            minions[i] = j
        elseif j == "Percival" then
            minions[i] = j
        --morgana is also treated as a minion, then distinguished by her name
        elseif j == "Morgana" then
            minions[i] = j
        --same with mordred
        elseif j == "Mordred" then
            minions[i] = j
        --and oberon
        elseif j == "Oberon" then
            minions[i]  = j
        elseif j == "Lancelot: Mordred" then
            minions[i] = j
        elseif j == "Lancelot: Arthur" then
            minions[i] = j
        elseif j == "Servant" then
            minions[i] = j
        end
    end

    --This for loop gives out all the secret messages before the game starts
    -- i is the player color and j is the player's role
    -- it is called 'minions' but contains all the cards
    for i, j in pairs(minions) do
        if  j  ~= 'Merlin' and j ~= 'Percival' and j ~= 'Lancelot: Arthur' and j ~= 'Servant' then
            hcol = stringColorToRGB(i)
            --special messages more every evil character
            if j == 'Assassin' then
                printToColor('You are the Assassin! Find and kill Merlin if 3 Missions Succeed!', i ,  {hcol["r"], hcol["g"], hcol["b"]} )
            end
            if j == 'Morgana' then
                printToColor('You are Morgana! You appear as Merlin to decieve Percival! ', i ,  {hcol["r"], hcol["g"], hcol["b"]} )
            end
            if j == 'Mordred' then
                printToColor('You are Mordred! You are unknown to Merlin! ', i ,  {hcol["r"], hcol["g"], hcol["b"]} )
            end
            if j == 'Oberon' then
                printToColor('You are Oberon! You are evil, but you do not know your allies! ', i ,  {hcol["r"], hcol["g"], hcol["b"]} )
            end
            if j == 'Lancelot: Mordred' then
                printToColor('You are Lancelot Mordred! You dont know your allies but they know you. You change sides if a swap card is drawn in the Lancelot deck! ', i ,  {hcol["r"], hcol["g"], hcol["b"]} )
            end
            --Continues on with the regular message
            printToColor('You are a Minion of Mordred!', i ,  {hcol["r"], hcol["g"], hcol["b"]} )
            --Checks the minions object for any allies, excludes the exceptions
            for k, l in pairs(minions) do
                if k ~= i and l ~= 'Oberon' and  l ~= 'Merlin' and j ~= 'Oberon' and  l ~= 'Percival' and j ~= 'Lancelot: Mordred' and l ~= 'Lancelot: Arthur' and l ~= 'Servant' then
                    hcol = stringColorToRGB(k)
                    printToColor( k .. ' is a Minion, too!', i, {hcol["r"], hcol["g"], hcol["b"]})
                end
            end
        elseif j == 'Merlin' then
            hcol = stringColorToRGB(i)
            printToColor('You are Merlin! You know evil, but you must avoid being assassinated', i ,  {hcol["r"], hcol["g"], hcol["b"]} )
            for k, l in pairs(minions) do
                local hcol = {}
                if k ~= i and  l ~= 'Percival' and l ~= 'Mordred' and l ~= 'Lancelot: Arthur' and l ~= 'Servant' then
                    hcol = stringColorToRGB(k)
                    printToColor( k .. ' is a Minion!', i, {hcol["r"], hcol["g"], hcol["b"]})
                end
            end
        elseif j == 'Percival' then
            hcol = stringColorToRGB(i)
            printToColor('You are Percival! You know Merlin, but Morgana may try to mislead you.', i ,  {hcol["r"], hcol["g"], hcol["b"]} )
            for k, l in pairs(minions) do
                local hcol = {}
                if l == 'Merlin' or l == 'Morgana' then
                    hcol = stringColorToRGB(k)
                    printToColor( k .. ' is Merlin. . . maybe.', i, {hcol["r"], hcol["g"], hcol["b"]})
                end
            end
        elseif j == 'Lancelot: Arthur' then
            hcol = stringColorToRGB(i)
            printToColor('You are Lancelot Arthur! You change sides if a swap role card is drawn from the Lancelot Deck!', i ,  {hcol["r"], hcol["g"], hcol["b"]} )
        else
            hcol = stringColorToRGB(i)
            printToColor('You are a Servant of Arthur! Protect Merlin and dont be fooled by the Minions of Mordred!', i ,  {hcol["r"], hcol["g"], hcol["b"]} )
        end
    end
    --this is the end of the script lol all of the end stuff happens here
    boardSetup(mordred_max + arthur_max)
    randomLeader()
end

--finds the max number of mordred/arthur per team, there's probably a way
--to do this that doesn't involve manually checking but I cbf
function getMax(np)
    if(np > 4 and np < 11) then
        if(np == 5) then
            arthur_max = 3
            mordred_max = 2
        elseif(np == 6) then
            arthur_max = 4
            mordred_max = 2
        elseif(np == 7) then
            arthur_max = 4
            mordred_max = 3
        elseif(np == 8) then
            arthur_max = 5
            mordred_max = 3
        elseif(np == 9) then
            arthur_max = 6
            mordred_max = 3
        else
            arthur_max = 6
            mordred_max = 4
        end
        return true
    else
        print('Not Enough Players!')
        return false
    end
end

--gives the leader token to a random playah
function randomLeader()
    players = getSeatedPlayers()
    leader = math.random(#players)
    playerHand = getPlayerHandPositionAndRotation(players[leader])
    leader_token.setPosition({playerHand['pos_x'], playerHand['pos_y'], playerHand['pos_z']})
    position = leader_token.getPosition()
    print(players[leader] .. ' is the first leader!' )
end




function sleep(n, to_do)
    Timer.destroy('t' .. timNum)
    timNum = timNum + 1
    timer = {}
    timer.identifier = 't' .. timNum
    timer.delay = n
    timer.function_name = to_do
    timer.repetitions = 1
    Timer.create(timer)
end
