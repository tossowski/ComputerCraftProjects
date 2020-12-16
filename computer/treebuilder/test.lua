inv = require("/tools/inventory")
blacklist = {[1]="minecraft:diamond_pickaxe", [2]="enderstorage:ender_storage"}
inv.dropAll("front", blacklist)
