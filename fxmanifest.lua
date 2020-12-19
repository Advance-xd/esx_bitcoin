fx_version 'bodacious'
game 'gta5'



version '1.0'



server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/server.lua',
	'config.lua'
	
	

}

client_scripts {
	'client/client.lua',
	'config.lua'

}




