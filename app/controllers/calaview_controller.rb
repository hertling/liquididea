class CalaviewController < ApplicationController
  def index

    cal = CalagatorEvents.new
    @ranked_events = cal.ranked_events({})
    @num_events=0
    @ranked_events.each_value { |sublist| @num_events+=sublist.size }
    @num_ranks = @ranked_events.size

    Rails.logger.info "** Found #{@num_events} events in #{@num_ranks} ranks"
  end
end
