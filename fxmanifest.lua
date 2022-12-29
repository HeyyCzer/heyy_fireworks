fx_version "cerulean"
game "gta5"

shared_script "@vrp/lib/Utils.lua"
shared_script "@vrp/config/Native.lua"

files "src/patterns/*.txt"

client_scripts {
	"src/client.lua"
}

server_scripts {
	"src/patternReader.lua",
	"src/server.lua",
}
