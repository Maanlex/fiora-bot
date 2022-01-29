require 'yaml'
require 'logger'
require 'discordrb'
require 'httparty'
require 'json'

require_relative 'fiora/logger'
require_relative 'fiora/commands'
require_relative 'fiora/utility'

module Fiora
  WD = "lib/fiora/" # Working directory
  CONFIG = YAML.load_file('config/config.yaml')

  logger = FioraLogger.init
  logger.info("Config file loaded")

  BOT = Discordrb::Commands::CommandBot.new token: CONFIG['token'] , prefix: CONFIG['prefix'], name: "Fiora", help_command: false
  
  # Add every commands to the bot
  logger.info("Loading commands :")
  Dir[WD + "commands/*/*.rb"].each do |f| 
    load f
  end
  Commands.constants.each do |mod|
    logger.info("Module #{mod.to_s} :")
    current_mod = Commands.const_get(mod) 
    current_mod.constants.each do |mod2| 
      logger.info("\t#{mod2.to_s} loaded")
      BOT.include!(current_mod.const_get(mod2)) 
    end
  end
  logger.info("Successfully loaded commands")
  
  at_exit do
    logger.info("Stopping Fiora..\n") 
    BOT.stop
  end
  BOT.run
end
