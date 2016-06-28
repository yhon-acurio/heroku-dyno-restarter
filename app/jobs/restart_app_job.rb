require_relative '../services/dyno_service'

class RestartAppJob < ApplicationJob
  queue_as :default

  def perform(kind)
    Rails.logger.debug("RestartAppJob: perform #{kind}")
    service = DynoService.new(kind)
    if service.connection
      service.running_dynos.each do |dyno|
        Rails.logger.debug("restarting dyno: #{dyno.inspect}")
        dyno.restart!
      end
    end
  end
end