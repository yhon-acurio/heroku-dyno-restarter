class ApiController < ApplicationController

  before_action :check_key

  def restart
    kind = params[:kind] || 'worker'
    RestartAppJob.perform_later(kind)
    render plain: "Restart triggered for #{kind} dynos of #{DynoService.target_app_name} app"
  end

  private

  def check_key
    render plain: 'You are not allowed to restart the dynos' unless params[:key] == ENV['RESTART_WEBHOOK_KEY']
  end

end