class CalaviewController < ApplicationController
  def index
    @threshold = params["threshold"].to_i || 1

    cal = CalagatorEvents.new
    @ranked_events = cal.ranked_events({})
    @selected_events = @ranked_events.select {|e| e['weighted_rank'] >= @threshold }

    Rails.logger.info "** Found #{@ranked_events.size} events, selected #{@selected_events.size}"
  end
end
