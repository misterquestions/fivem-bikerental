fx_version 'bodacious'
game 'gta5'

author 'MisterQuestions'
description 'A resource that allows bike renting for certain amount of time'
version '1.0.0'

dependencies {
  'warmenu'
}

-- Load core first
client_script 'core_client.lua'

-- Libraries & tools
client_script '@warmenu/warmenu.lua'
client_script 'tools/markers_client.lua'
client_script 'tools/utils_client.lua'

-- Actual scripts
client_script 'bikes_client.lua'
client_script 'car_client.lua'