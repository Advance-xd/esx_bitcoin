fx_version 'bodacious'
game 'gta5'



version '2.1'

ui_page 'client/html/UI.html'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/server.lua',
	'config.lua'
	
	

}

client_scripts {
	'client/client.lua',
	'config.lua'

}

files {
    'client/html/UI.html',
    'client/html/script.js',
    'client/html/style.css',
    'client/html/media/font/Futura-Bold.woff',
    'client/html/media/img/circle.png',
    'client/html/media/img/curve.png',
    'client/html/media/img/fingerprint.jpg',
    'client/html/media/img/logo-big.png',
    'client/html/media/img/logo-top.png',
}




