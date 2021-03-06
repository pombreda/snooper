# -*- coding: utf-8 -*-
# Author::    Will Speak  (@willspeak)
# Copyright:: Copyright (c) 2013 Will Speak
# License::   Snooper is open source! See LICENCE.md for more details.

module Snooper
  require 'snooper/version'

  module Options
    require 'optparse'

    ##
    # Public: Command Line Options
    ParsedOptions = Struct.new :config_path, :command, :poll

    ##
    # Public: Parse the command line
    #
    # arguments - The list of string arguments to be parsed
    #
    # Returns an Options struct containing :base_path and :command
    def self.parse(arguments)
      
      helptext = <<END

Snooper is  a lightweight test  automation tool,  it monitors files  and folders
while  you work  and  re-runs  your tests  when  you  change something.  Snooper
doesn't care what language you're using  or what framework you are testing with,
it's all configureable.

For more information see snooper(1).
END

      options = ParsedOptions.new
      options.config_path = nil

      parser = OptionParser.new do |parser|
        parser.banner =
          "Useage: #{File.basename __FILE__} [--config <CONFIG> | --help] " + 
          "[<COMMAND>]*"

        parser.separator helptext

        parser.on '-c', '--config CONFIGFILE', 'YAML configuration file' do |path|
          options.config_path = path
        end

        parser.on("--version", "show version information") do
          puts "Snooper v#{VERSION}"
          exit
        end
        
        parser.on("-p", "--poll [FREQUENCY]", "Force filesystem polling.") do |freq|
          options.poll = freq || true
        end

        parser.on("-h", "--help", "Show this message") do
          puts parser
          exit
        end
      end

      # Parse the arguments
      begin
        parser.parse! arguments
      rescue OptionParser::InvalidOption, \
        OptionParser::MissingArgument, \
        OptionParser::InvalidArgument => e
        puts e
        puts parser
        exit 1
      end

      options.config_path = find_config unless options.config_path

      options.command = arguments.join " " if not arguments.empty?
      options
    end

    private
    
    ##
    # Internal : Find a config file to use
    #
    # Returns the path to the config, or nil if none can be found
    def self.find_config
      file_name = '.snooper.yaml'

      Pathname.pwd.ascend do |subpath|
        location = subpath + file_name
        return location if location.exist?
      end

      nil
    end

  end
end
