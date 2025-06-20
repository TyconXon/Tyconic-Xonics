--Creates an atlas for cards to use
SMODS.Atlas {
	-- Key for code to find it with
	key = "ModdedVanilla",
	-- The name of the file, for the code to pull the atlas from
	path = "spritesheet.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}


SMODS.Joker {
	key = 'tyconuno',
	loc_txt = {
		name = 'Uno',
		text = {
			"Gains {C:chips}+#2#{} chips if card ",
			"is similar to the last -",
			"resets otherwise.",
			"{C:inactive}({V:1}#3#{C:inactive} or #4#){}",
			"{C:inactive}(Currently {C:chips}+#1#{C:inactive} chips)"
		}
	},
	config = { extra = { chips = 0, chip_gain = 30, suit = "", rank = 0, rank_nice = "rank", card = {} } },
	rarity = 2,
    blueprint_compat = true,
	atlas = 'ModdedVanilla',
	pos = { x = 0, y = 0 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { 
            card.ability.extra.chips,
            card.ability.extra.chip_gain,
            card.ability.extra.suit or "suit", 
            card.ability.extra.rank_nice or "rank",
            colours = { G.C.SUITS[card.ability.extra.suit] } 
        } }
	end,
	calculate = function(self, card, context)

		if context.individual and context.cardarea == G.play then
			local doCount = false
			-- :get_id tests for the rank of the card. Other than 2-10, Jack is 11, Queen is 12, King is 13, and Ace is 14.
			if context.other_card:get_id() == card.ability.extra.rank or context.other_card:is_suit(card.ability.extra.suit)  then
				card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
				doCount = true
			else
				card.ability.extra.chips = 0
			end

            if not SMODS.has_no_rank(context.other_card) then
                card.ability.extra.suit = context.other_card.base.suit
                card.ability.extra.rank = context.other_card:get_id()
                card.ability.extra.card = context.other_card

                card.ability.extra.rank_nice = context.other_card:get_id()
                if context.other_card:get_id() > 10 then
                    if context.other_card:get_id() == 11 then card.ability.extra.rank_nice = "Jack"
                    elseif context.other_card:get_id() == 12 then card.ability.extra.rank_nice = "Queen"
                    elseif context.other_card:get_id() == 13 then card.ability.extra.rank_nice = "King"
                    elseif context.other_card:get_id() == 14 then card.ability.extra.rank_nice = "Ace"
                    else   card.ability.extra.rank_nice = card.ability.extra.rank end

                end
            end

			if doCount then
				return {
					chips = card.ability.extra.chips
				}
			end
		end

	end
}

-- Element of Pride 
SMODS.Joker {
    key = "tyconpride",
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    pos = { x = 1, y = 0 },
	atlas = 'ModdedVanilla',

    config = { extra = { xmult = 1.5 } },
    loc_txt = {
		name = 'Disorder of Vainglory',
		text = {
			"Each card held in hand of the",
			"same {C:important}rank and suit{} of each played card", 
            "gives {X:mult,C:white} x#1# {} mult"
		}
	},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local count = 0
            for _, playing_card in ipairs(G.hand.cards) do
                if (playing_card:is_suit(context.other_card.base.suit) or context.other_card:is_suit(playing_card.base.suit)) and playing_card:get_id() == context.other_card:get_id() then
                    count = count + 1
                end
            end
            if count ~= 0 then
                return {
                    xmult = card.ability.extra.xmult * count
                }
            end
        end
    end
}
-- Colour of Lust
SMODS.Joker {
    key = "tyconlust",
    blueprint_compat = true,
    rarity = 1,
    cost = 6,
    pos = { x = 2, y = 0 },
	atlas = 'ModdedVanilla',

    config = { extra = { chips = 50 } },
    loc_txt = {
		name = 'Colour of Lust',
		text = {
			"Each card held in hand of the",
			"same {C:important}suit{} of each played card", 
            "gives {C:chips}+#1#{} chips"
		}
	},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local count = 0
            for _, playing_card in ipairs(G.hand.cards) do
                if (playing_card:is_suit(context.other_card.base.suit) or context.other_card:is_suit(playing_card.base.suit)) then
                    count = count + 1
                end
            end
            if count ~= 0 then
                return {
                    chips = card.ability.extra.chips * count
                }
            end
        end
    end
}
-- Symbol of Envy
SMODS.Joker {
    key = "tyconenvy",
    blueprint_compat = true,
    rarity = 1,
    cost = 6,
    pos = { x = 0, y = 1 },
	atlas = 'ModdedVanilla',

    config = { extra = { mult = 10 } },
    loc_txt = {
		name = 'Symbol of Envy',
		text = {
			"Each card held in hand of the",
			"same {C:important}rank{} of each played card", 
            "gives {C:mult}+#1#{} mult"
		}
	},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local count = 0
            for _, playing_card in ipairs(G.hand.cards) do
                if playing_card:get_id() == context.other_card:get_id() then
                    count = count + 1
                end
            end
            if count ~= 0 then
                return {
                    mult = card.ability.extra.mult * count
                }
            end
        end
    end
}

function TXON_Flip()

    --Select all jokers
    local current_jokers = {}
    for _, joker in pairs(G.jokers.cards) do
        current_jokers[#current_jokers + 1] = joker
    end

    --Store the jokers
    local this_state = {}
    local flip_state = {}
    local terx = "ALIVE!"

    if G.GAME.modifiers.txon_tlaz.alive_not_dead then
        G.GAME.modifiers.txon_tlaz.alive.jokers = current_jokers
        this_state = G.GAME.modifiers.txon_tlaz.alive
        flip_state = G.GAME.modifiers.txon_tlaz.dead
        terx = "DEAD!"
    else
        G.GAME.modifiers.txon_tlaz.dead.jokers = current_jokers
        this_state = G.GAME.modifiers.txon_tlaz.dead
        flip_state = G.GAME.modifiers.txon_tlaz.alive

    end

    local _first_dissolve = nil

    --Destroy all the jokers
    G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = 0.75,
        func = function()
            for _, joker in pairs(current_jokers) do
                joker:start_dissolve(nil, _first_dissolve)
                _first_dissolve = true
            end
            return true
        end
    }))

    --Create the flipped jokers
    G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = 0.4,
        func = function()
            for _, joker in pairs(flip_state.jokers) do
                local copied_joker = copy_card(joker, nil, nil, nil, false)
                copied_joker:start_materialize()
                copied_joker:add_to_deck()
                G.jokers:emplace(copied_joker)
            end

            --Flip state
            G.GAME.modifiers.txon_tlaz.alive_not_dead = not G.GAME.modifiers.txon_tlaz.alive_not_dead
            if (G.GAME.modifiers.txon_tlaz.alive_not_dead) then
                play_sound('txon_flip', 1, 0.4)
            else
                play_sound('txon_unflip', 1, 0.4)
            end
            attention_text({
                        text = terx,
                        scale = 1.4,
                        hold = 2,
                        major = G.play,
                        align = 'cm',
                        offset = { x = 0, y = -2.7 },
            })
            return true
        end
    }))

end

-- Tainted Lazarus
SMODS.Back {
    key = "tlaz",
	atlas = 'ModdedVanilla',
    pos = { x = 2, y = 1 },
    unlocked = true,
    loc_txt = {
        name ="Tainted Lazarus",
        text={
            "FLIP between life and death.",
            "(Flip between two sets of",
            "player data after each blind,",
            "and gain a consumable each",
            "boss blind to manually do so)"
        },
    },
    loc_vars = function(self, info_queue, back)
        return { vars = {  } }
    end,
    config = {
        ante_scaling = 1,
        -- spawn_flip = function()
        --                 local _nah = SMODS.create_card({set = "Tarot", area = G.consumeables, key = "c_txon_flip"})
        --                 _nah:set_edition({negative = true})
        --                 _nah:add_to_deck()
        --                 G.consumeables:emplace(_nah)
        --                 return true
        --             end,
    },
    apply = function (self, back)
        G.GAME.modifiers.txon_tlaz = {
            alive_not_dead = true,
            ready = true,
            alive = {
                jokers = {

                },
                consumeables = {}
            },
            dead = {
                jokers = {

                },
                consumeables = {}
            },
            
        }
        G.E_MANAGER:add_event(Event({
                    func = function()
                        local _nah = SMODS.create_card({set = "Tarot", area = G.consumeables, key = "c_txon_flip"})
                        _nah:set_edition({negative = true})
                        _nah:add_to_deck()
                        G.consumeables:emplace(_nah)
                        return true
                    end,
                }))
    
    end,
    calculate = function(self, back, context)
        if context.end_of_round and context.individual and G.GAME.modifiers.txon_tlaz.ready then

            --add flip after boss
            if G.GAME.blind and G.GAME.blind.boss then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local _nah = SMODS.create_card({set = "Tarot", area = G.consumeables, key = "c_txon_flip"})
                        _nah:set_edition({negative = true})
                        _nah:add_to_deck()
                        G.consumeables:emplace(_nah)
                        return true
                    end,
                }))
            end

            --flip after blind
           TXON_Flip()

           G.GAME.modifiers.txon_tlaz.ready = false
        end
        if context.setting_blind then
           G.GAME.modifiers.txon_tlaz.ready = true
        end

    end,
   
}

-- flip consumable here

SMODS.Sound({
    key = "flip",
    path = "lazarusflipalive.wav",
})
SMODS.Sound({
    key = "unflip",
    path = "lazarusflipdead.wav",
})


SMODS.Consumable {
    key = 'flip',
    set = 'Tarot',
	atlas = 'ModdedVanilla',
    pos = { x = 0, y = 2},
    loc_txt = {
        name ="Flip",
        text={
            "Manually flip",
            "between life and death",
        },
    },
    config = {  },

    use = function (self, card, area, copier)
        if G.GAME.modifiers.txon_tlaz ~= nil then
            TXON_Flip()
            return true
        end
    end,

    in_pool = function (self, args) 
        if G.GAME.modifiers.txon_tlaz ~= nil then
            return true
        else
            return false
        end
    end,

    can_use = function(self, card)
        if G.GAME.modifiers.txon_tlaz ~= nil then
            if G.GAME.modifiers.txon_tlaz.alive_not_dead ~= true then
                self.pos.x = 1
            else
                self.pos.x = 0
            end
            return true
        else
            return false
        end
    end
    
}