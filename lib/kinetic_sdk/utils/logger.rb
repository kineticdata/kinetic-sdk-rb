require 'logger'

module KineticSdk
  module Utils

    # The KLogger class provides methods to output at different levels based on 
    # a configuration property.  The default log level is `off`, but can be 
    # turned on by passing in the `log_level` option.
    #
    # Available Levels: `debug`, `info`, `warn`, `error`, `off`
    #
    # The default output is to `STDOUT`, but can also be set to `STDERR` by 
    # passing in the `log_output` option.
    #
    # Available Outputs: `STDOUT`, `STDERR`
    #
    class KLogger
      def initialize(log_level, output=STDOUT)
        output ||= STDOUT
        @logger = Logger.new(output)

        case log_level
        when "error"
          @logger.level= Logger::ERROR
        when "warn"
          @logger.level= Logger::WARN
        when "info"
          @logger.level= Logger::INFO
        when "debug"
          @logger.level= Logger::DEBUG
        else
          @logger.level= Logger::FATAL
        end

        # define the string output format
        @logger.formatter = proc do |severity, datetime, progname, msg|
          date_format = datetime.utc.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
          "[#{date_format}] #{severity}: #{msg}\n"
        end
      end

      # Print the message if level is Logger::DEBUG or lower
      #
      # @param msg [String] the message to log
      def debug(msg); @logger.debug(msg); end

      # Is the current log level set to Logger::DEBUG or lower?
      #
      # @return [Boolean] true if level is debug or lower
      def debug?; @logger.debug? end

      # Print the message if level is Logger::ERROR or lower
      #
      # @param msg [String] the message to log
      def error(msg); @logger.error(msg); end

      # Is the current log level set to Logger::ERROR or lower?
      #
      # @return [Boolean] true if level is error or lower
      def error?; @logger.error? end

      # Print the message if level is Logger::FATAL or lower
      #
      # @param msg [String] the message to log
      def fatal(msg); @logger.fatal(msg); end

      # Is the current log level set to Logger::FATAL or lower?
      #
      # @return [Boolean] true if level is fatal or lower
      def fatal?; @logger.fatal? end

      # Print the message if level is Logger::INFO or lower
      #
      # @param msg [String] the message to log
      def info(msg); @logger.info(msg); end

      # Is the current log level set to Logger::INFO or lower?
      #
      # @return [Boolean] true if level is info or lower
      def info?; @logger.info? end

      # Print the message if level is Logger::WARN or lower
      #
      # @param msg [String] the message to log
      def warn(msg); @logger.warn(msg); end

      # Is the current log level set to Logger::WARN or lower?
      #
      # @return [Boolean] true if level is warn or lower
      def warn?; @logger.warn?; end
      
    end

  end
end
