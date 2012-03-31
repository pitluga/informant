require 'fiber'

require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/synchrony'
require 'eventmachine'
require 'rack/fiber_pool'

require 'thin/callbacks'
require 'informant/web'
require 'informant/check_result'
require 'informant/command_runner'
require 'informant/configuration'
require 'informant/config/command'
require 'informant/config/node'
require 'informant/config/notification'

module Informant
  class << self
    attr_reader :configuration
  end
  def self.configure
    @configuration = Configuration.configure
  end
end

Thin::Callbacks.after_connect do
  Informant.configure
end
