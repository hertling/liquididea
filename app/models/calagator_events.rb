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
    @events = events#[0..10]
    r_events = {}

    @events.each do |event|
      rank, why = event_rank(event, weighting_hash)

      if r_events[rank].nil?
        puts "initializing array for #{rank}"
        r_events[rank]=[]
      end

      event["why_rank"] = why if why.present?

      puts "rank #{rank} size: #{r_events[rank].size}"
      r_events[rank] << event
    end
    puts "size of r_events: #{r_events.size}"
    r_events
  end

  def rank_from_weight (weight)
    weight
  end

  def time_before(time1, time2)
    time1 = DateTime.parse(time1) unless time1.is_a? DateTime
    time2 = DateTime.parse(time2) unless time2.is_a? DateTime
    time1.seconds_since_midnight < time2.seconds_since_midnight
  end

  def time_match(event, rule)
    match=true
    if rule["time"].present?
      if rule["time"]["starts_after"].present?
        match=false if time_before(event["start_time"], rule["time"]["starts_after"])
      end
      if rule["time"]["starts_before"].present?
        match=false if time_after(event["start_time"], rule["time"]["starts_before"])
      end
      if rule["time"]["ends_after"].present?
        match=false if time_before(event["end_time"], rule["time"]["ends_after"])
      end
      if rule["time"]["ends_before"].present?
        match=false if time_after(event["end_time"], rule["time"]["ends_before"])
      end    end
    match
  end

  def event_rank(event, weighting_hash)
    rules = [
      {"text" => "ruby", "weight" => 2},
      {"text" => "robot", "weight" => 3},
      {"where" => "new relic", "weight" => 1},
      {"when" => {"time" => {"starts_after" => "8:00pm"}},
                 "weight" => 2}
    ]

    weight=0
    why=""
    rules.each do | rule |
      case
        when rule["text"].present?
          if event["description"].include?(rule["text"]) || event["title"].include?(rule["text"])
            weight+=rule["weight"]
            why+="[#{rule["text"]}, #{rule["weight"]}]; "
          end
        when rule["where"].present?
          if event["venue"].present? && event["venue"]["title"].downcase.include?(rule["where"].downcase)
            weight+=rule["weight"]
            why+="[#{rule["where"]}, #{rule["weight"]}]; "
          end
        when rule["when"].present?
          if time_match(event, rule["when"])
            weight+=rule["weight"]
            why+="[#{rule["when"].to_s}, #{rule["weight"]}]; "
          end
      end
    end
    [rank_from_weight(weight), why]
  end
end