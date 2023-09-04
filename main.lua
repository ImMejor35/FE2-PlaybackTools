-- Preparation
local function HttpLoad(url)
 return loadstring(game:HttpGetAsync(url))
end
local function SafeCall(GameFunc, ...)
  setthreadcontext(2)
  GameFunc(...)
  setthreadcontext(8)
end
HttpLoad("https://raw.github.com/ImMejor35/FE2-PlaybackTools/tested/prep.lua")()
