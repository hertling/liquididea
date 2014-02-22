class CalaviewController < ApplicationController
  def index

    cal = CalagatorEvents.new
    @ranked_events = cal.ranked_events({})


    @num_events = @ranked_events.flatten.size
    @num_ranks = @ranked_events.size
    Rails.logger.info "** Found #{@num_events} events"
    Rails.logger.info "** Found #{@num_ranks} events"
  end
end
