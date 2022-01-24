module Fiora
  module FioraLogger
    def self.init
      logger = Logger.new(STDOUT)
      logger.level = Logger::DEBUG
      logger.datetime_format = '%d-%m-%Y %H:%M:%S'
      logger.formatter = proc do |severity, datetime, progname, msg|
        "[#{datetime}] : #{msg}\n"
      end
      return logger
    end
  end
end