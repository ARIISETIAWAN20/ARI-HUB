-- Script untuk mengeksekusi ScAri.lua langsung dari GitHub
-- Pastikan executor mendukung loadstring dan HttpGet

local success, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ARIISETIAWAN20/ScAri/main/ScAri.lua"))()
end)

if success then
    print("ScAri.lua berhasil dijalankan!")
else
    warn("Gagal menjalankan ScAri.lua: ", err)
end
