require 'fiber'

require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/synchrony'
require 'eventmachine'
require 'rack/fiber_pool'

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

module Informant
  class << self
    attr_accessor :scheduler, :channels, :configuration
  end

  self.scheduler = Informant::Scheduler.new

  def self.configure
    @configuration = Configuration.configure
  end

  def self.create_channels
    @channels = Channels.create
  end

  def self.schedule
    configuration.nodes.each { |(_,node)| node.schedule }
  end

  def self.subscribe
    configuration.email_notifiers.each { |(_,notifier)| notifier.subscribe }
    @check_reporter = CheckReporter.new
    @check_reporter.subscribe
  end

  def self.check_fiber_pool
    @check_fiber_pool ||= FiberPool.new(10)
  end
end

Thin::Callbacks.after_connect do
  Informant.create_channels
  Informant.configure
  Informant.subscribe
  Informant.schedule
end
