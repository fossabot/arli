require 'json'
require 'arli'
require 'net/http'
require_relative 'base'
require_relative '../arli_file'
require_relative '../lock/formats'
require_relative '../lock/file'

module Arli
  module Commands
    class Bundle < Base

      attr_accessor :arlifile, :lock_file

      def setup
        super
        self.arlifile = Arli::ArliFile.new(config: config)
        self.lock_file = Arli::Lock::File.new(config: config)
      end

      def params
        if arlifile&.libraries
          "libraries: \n • " + arlifile.libraries.map(&:name).join("\n • ")
        end
      end

      def run
        install_with_arli_file
      end

      protected

      def install_with_arli_file
        arlifile.install
        post_install
      end

      def post_install
        lock_file.lock!(*arlifile.libraries)
      end
    end
  end
end
