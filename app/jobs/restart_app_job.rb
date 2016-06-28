require_relative '../services/dyno_service'

class RestartAppJob < ApplicationJob
  queue_as :default

  def perform(kind)
    Rails.logger.debug("RestartAppJob: perform #{kind}")
    service = DynoService.new(kind)
    if service.connection
      service.running_dynos.each do |dyno|
        if dyno.restart!
          Rails.logger.debug("done restarting #{dyno.type} dyno of #{service.target_app_name}: #{dyno.inspect}")
        end
      end
    end
  end
end