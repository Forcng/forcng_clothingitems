fx_version 'cerulean'

game 'gta5'

author 'Forcng'
description 'discord.gg/forcng'
lua54 'yes'
version '1.8'

shared_scripts {
    '@ox_lib/init.lua',
    'sharedItems.lua',
    "@es_extended/imports.lua",
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

client_scripts {
    'client/*'
}
