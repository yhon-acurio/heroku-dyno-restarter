class RestartAppJob < ApplicationJob
  queue_as :restarts

  class Dyno
    attr_accessor :type
    attr_accessor :name
    attr_accessor :state

    def self.connection
      if ENV['RESTART_API_KEY']
        @@connection ||= PlatformAPI.connect_oauth(ENV['RESTART_API_KEY'])
      end
    end

    def self.dynos
      result = connection.dyno.list(ENV['APP_NAME']).map do |dyno_info|
        Dyno.new(dyno_info)
      end
      Rails.logger.debug("dynos: #{dynos.inspect}")
      result
    end

    def self.running_worker_dynos
      result = dynos.select { |dyno| dyno.worker? && dyno.up? }
      Rails.logger.debug("running_web_dynos: #{running_worker_dynos.inspect}")
      result
    end

    def worker?
      type == 'worker'
    end

    def up?
      state == 'up'
    end

    def connection
      self.class.connection
    end

    def restart!
      result = connection.dyno.restart(ENV['APP_NAME'], name)
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
    if Dyno.connection
      Dyno.running_worker_dynos.each do |dyno|
        Rails.logger.debug("running_web_dynos: #{running_worker_dynos.inspect}")
        dyno.restart!
      end
    end
  end
end