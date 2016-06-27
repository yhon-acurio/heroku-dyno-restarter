class ApiController < ApplicationController

  def restart_workers
    if params[:key] == ENV['RESTART_WEBHOOK_KEY']
      RestartAppJob.perform_later
      render text: 'Restart triggered'
    else
      render text: 'You are not allowed to restart the dynos'
    end
  end
end