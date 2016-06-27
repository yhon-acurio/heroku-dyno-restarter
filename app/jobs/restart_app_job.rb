class RestartAppJob < ApplicationJob
  queue_as :default

  class Dyno
    attr_accessor :type
    attr_accessor :name
    attr_accessor :state

    def self.connection1
      result = if ENV['RESTART_API_KEY']
        @@connection1 ||= PlatformAPI.connect_oauth(ENV['RESTART_API_KEY'])
      end
      Rails.logger.debug("connection1: #{result.inspect}")
      result
    end

    def self.dynos
      result = connection1.dyno.list(ENV['APP_NAME']).map do |dyno_info|
        Dyno.new(dyno_info)
      end
      Rails.logger.debug("dynos: #{result.inspect}")
      result
    end

    def self.running_worker_dynos
      result = dynos.select { |dyno| dyno.worker? && dyno.up? }
      Rails.logger.debug("running_web_dynos: #{result.inspect}")
      result
    end

    def worker?
      type == 'worker'
    end

    def up?
      state == 'up'
    end

    def connection1
      self.class.connection1
    end

    def restart!
      result = connection1.dyno.restart(ENV['APP_NAME'], name)
      Rails.logger.debug("restart! result: #{result.inspect}")
      result
    end

    def initialize(info)
      self.type = info['type']
      self.name = info['name']
      self.state = info['state']
    end
  end

  def perform(*args)
    if Dyno.connection1
      Dyno.running_worker_dynos.each do |dyno|
        Rails.logger.debug("restarting dyno: #{dyno.inspect}")
        dyno.restart!
      end
    end
  end
end