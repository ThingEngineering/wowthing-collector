local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('EmissaryQuests')


Module.db = {}


local CQL_GetBountiesForMapID = C_QuestLog.GetBountiesForMapID
local CTQ_GetQuestTimeLeftSeconds = C_TaskQuest.GetQuestTimeLeftSeconds

local ONE_DAY = 1 * 24 * 60 * 60
local TWO_DAYS = 2 * 24 * 60 * 60


function Module:OnEnable()
    WWTCSaved.emissaryQuests = WWTCSaved.emissaryQuests or {}
end

function Module:OnEnteringWorld()
    C_Timer.After(10, function() self:UpdateEmissaryQuests() end)
end

function Module:UpdateEmissaryQuests()
    local now = time()
    WWTCSaved.scanTimes.emissaries = now
    
    for _, expansion in ipairs(self.db.expansions) do
        WWTCSaved.emissaryQuests[expansion.id] = WWTCSaved.emissaryQuests[expansion.id] or { '', '', '' }
        local expansionQuests = WWTCSaved.emissaryQuests[expansion.id]

        local bounties = CQL_GetBountiesForMapID(expansion.uiMapId)
        if bounties ~= nil then
            for _, bounty in ipairs(bounties) do
                local timeRemaining = CTQ_GetQuestTimeLeftSeconds(bounty.questID)
                local questReset = Addon:RoundToNearest(now + timeRemaining, 60)
                local questString = (self.db.questMap[bounty.questID] or bounty.questID) .. ':' .. questReset

                if timeRemaining < ONE_DAY then
                    expansionQuests[1] = questString
                elseif timeRemaining < TWO_DAYS then
                    expansionQuests[2] = questString
                else
                    expansionQuests[3] = questString
                end
            end
        end
    end
end
