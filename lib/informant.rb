require 'fiber'
require 'forwardable'

require 'bundler/setup'
require 'eventmachine'
require 'em-websocket'
require 'rack/fiber_pool'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/synchrony'

require 'thin/callbacks'
require 'informant/channels'
require 'informant/check_message'
require 'informant/check_reporter'
require 'informant/check_result'
require 'informant/check_status'
require 'informant/command_runner'
require 'informant/configuration'
require 'informant/config/command'
require 'informant/config/email_notifier'
require 'informant/config/node'
require 'informant/email_sender'
require 'informant/helpers'
require 'informant/notification_message'
require 'informant/report_message'
require 'informant/scheduler'
require 'informant/web'
require 'informant/web_socket'

module Informant
  class << self
    attr_accessor :scheduler, :channels, :configuration, :web_socket
  end

  def self.configure
    @configuration = Configuration.configure
  end

  def self.create_channels
    @channels = Channels.create
  end

  def self.schedule
    @scheduler = Scheduler.new(check_fiber_pool)
    @scheduler.start_checking!
  end

  def self.subscribe
    configuration.email_notifiers.each { |(_,notifier)| notifier.subscribe }
    @check_reporter = CheckReporter.new
    @check_reporter.subscribe
  end

  def self.check_fiber_pool
    @check_fiber_pool ||= FiberPool.new(10)
  end

  def self.start_web_socket
    @web_socket = Informant::WebSocket.start
  end
end

Thin::Callbacks.after_connect do
  Informant.create_channels
  Informant.configure
  Informant.subscribe
  Informant.schedule
  Informant.start_web_socket
end

Signal.trap("HUP") { Informant.configure }
