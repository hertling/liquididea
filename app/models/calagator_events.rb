require 'open-uri'
#require 'json'

class CalagatorEvents
  def initialize
    @source_uri = "http://calagator.org/events.json"
  end

  def events
    JSON.parse(open(@source_uri).read)
  end

  def ranked_events(weighting_hash)
    @events = events[0..10]
    r_events = {}

    @events.each do |event|
      rank = event_rank(event, weighting_hash)

      puts rank
      puts r_events[rank].present?

      if r_events[rank].nil?
        puts "initializing array for #{rank}"
        r_events[rank]=[]
      end

      puts "rank class and size:"
      puts r_events[rank].class
      puts r_events[rank].size

      r_events[rank] << event

    end

    puts "size of r_events: #{r_events.size}"
    r_events
  end

  def event_rank(event, weighting_hash)
    "medium"
  end
end