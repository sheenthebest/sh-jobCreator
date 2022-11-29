fx_version 'cerulean'
game 'gta5'
author 'sheen'

shared_scripts {
    'config.lua',
}

client_scripts {
    'client/main.lua',
    'jobs/**.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}

lua54 'yes'
