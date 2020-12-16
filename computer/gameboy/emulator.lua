monitor = peripheral.wrap("monitor_0")
monitor.setTextScale(0.5)
monitor.clear()
monitor.setCursorPos(1,1)
--require("jit.opt")
--print(term.getSize())
--if pcall(require, "jit.opt") then
--  require("jit.opt").start("maxmcode=8192", "maxtrace=2000")
--end
gb = require("/gameboy")

 
--beginning = fil:seek()
file = fs.open("/games/pokemon.gb", "rb")
size = fs.getSize("/games/pokemon.gb")
print(size)
file_data = file.readAll()
gameboy = gb.new{}
gameboy:initialize()
gameboy:reset()
 
 
palette = {[0]={255, 255, 255}, [1]={192, 192, 192}, [2]={128, 128, 128}, [3]={0, 0, 0}}
colorMapping = {[16777215]=colors.white, [0]=colors.black, [12632256]=colors.lightGray, [421072]=colors.gray, [8421504]=colors.yellow}
gameboy.graphics.palette_dmg_colors = palette
monitor.setPaletteColor(colors.yellow, 0.5, 0.5, 0.5)
gameboy.cartridge.load(file_data,size)
gameboy:reset()
function handleKeyInput()
  local event, key, isHeld = os.pullEvent("key")
  if key == keys.x then
    gameboy.input.keys["A"] = 1
  elseif key == keys.z then
    gameboy.input.keys["B"] = 1
  elseif key == keys.up then
    gameboy.input.keys["Up"] = 1
  elseif key == keys.down then
    gameboy.input.keys["Down"] = 1
  elseif key == keys.left then
    gameboy.input.keys["Left"] = 1
  elseif key == keys.right then
    gameboy.input.keys["Right"] = 1
  elseif key == keys.enter then
    gameboy.input.keys["Start"] = 1
  else
    for k, v in pairs(gameboy.input.keys) do
      gameboy.input.keys[k] = 0
    end
  end
  gameboy.input.update()
end
 
function update()
  
  local pixels = gameboy.graphics.game_screen
  for i = 0, 159, 2 do
    for j = 0, 143, 2 do
      local pixel = pixels[j][i]
      monitor.setCursorPos(i/2+1,j/2+1)
      tColor = colors.rgb8(pixel[1]/255, pixel[2]/255, pixel[3]/255)
      if colorMapping[tColor] ~= nil then
        monitor.setBackgroundColor(colorMapping[tColor])
      else
        monitor.setBackgroundColor(colors.red)
      end
      monitor.write(" ")
    end
  end
  sleep(0.01)
  --handleKeyInput()
  --print(gameboy.graphics.palette_dmg_colors)
  gameboy:run_until_vblank()
end
--gameboy.cartridge.load(file_data, size)
 
while true do 
  update()
end
