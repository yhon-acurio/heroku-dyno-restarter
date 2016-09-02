class Dyno
  attr_accessor :type
  attr_accessor :name
  attr_accessor :state
  attr_accessor :service

  def initialize(info, service)
    self.type = info['type']
    self.name = info['name']
    self.state = info['state']
    self.service = service
  end

  def restart!
    Rails.logger.debug("restarting #{self.inspect}")
    result = connection.dyno.restart(DynoService.target_app_name, name)
    result
  end

  def up?
    state == 'up' || state == 'idle'
  end

  def connection
    service.connection
  end

end