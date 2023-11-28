File = require("modules/file")




function ftos(number)
	return string.format("%.3f", number)
end


function getCurrentPosition()
	local currentPosition = Game.GetPlayer():GetWorldPosition()

	return "x: " .. ftos(currentPosition.x) .. " y: " .. ftos(currentPosition.y) .. " z: " .. ftos(currentPosition.z)
end


function trackShard(self, shards, itemData)
	local shardTDBID = itemData:GetID().id
	local shardData = self:GetShardData(shardTDBID)
	local shardName = shardData:GetTitle()
	local shardDescription = shardData:GetDescription()

	shards[TDBID.ToStringDEBUG(shardTDBID)] = {
		["Name"] = GetLocalizedText(shardName),
		["NameLocKey"] = shardName,
		["Description"] = GetLocalizedText(shardDescription),
		["DescriptionLocKey"] = shardDescription,
		["Location"] = getCurrentPosition()
	}
end




registerForEvent("onInit", function ()
	local shards = {}
	local shardsPath = "shards.json"

	if not File.fileExists(shardsPath) then
		File.writeJSON(shardsPath, shards)
	end

	shards = File.readJSON(shardsPath)
	
	Override("gameLootContainerBase", "OnItemRemoveddEvent", function (self, evt, wrappedMethod)
		wrappedMethod(evt)

		if evt.itemData:HasTag(StringToName("Shard")) then
			trackShard(self, shards, evt.itemData)
			File.writeJSON(shardsPath, shards)
		end
	end)
end)
