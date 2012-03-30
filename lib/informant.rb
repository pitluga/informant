require 'bundler/setup'
require 'sinatra'
require 'eventmachine'
require 'rack/fiber_pool'

require 'fiber'
require 'informant/web'
require 'informant/check_result'
require 'informant/command_runner'

module Informant
end
