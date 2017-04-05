class DynoService

  def initialize(kind)
    @kind = kind
  end

  def connection
    result = if ENV['RESTART_API_KEY']
               @connection ||= PlatformAPI.connect_oauth(ENV['RESTART_API_KEY'])
             end
    Rails.logger.debug("DynoService connection: #{result.inspect}")
    result
  end

  def dynos
    result = connection.dyno.list(target_app_name).map do |dyno_info|
      Dyno.new(dyno_info, self) if dyno_info['type'] == @kind || @kind == 'all'
    end.compact
    Rails.logger.debug("DynoService dynos: #{result.inspect}")
    result
  end

  def running_dynos
    result = dynos.select(&:up?)
    Rails.logger.debug("DynoService running_dynos: #{result.inspect}")
    result
  end

  def target_app_name
    self.class.target_app_name
  end

  def self.target_app_name
    ENV['TARGET_APP_NAME']
  end
end
