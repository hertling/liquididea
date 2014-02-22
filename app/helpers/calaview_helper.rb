module CalaviewHelper
  def event_url(e_id)
    "http://calagator.org/events/#{e_id}"
  end

  MAX_DESCRIPTION = 80 * 5

  def format_description(string)
    if string.length > MAX_DESCRIPTION
      string = string[0..MAX_DESCRIPTION] + "... _(more)_"
    end
    sanitize(auto_link(upgrade_br(markdown(string))))
  end

  def format_when(event)
    start_time = DateTime.parse(event['start_time']).strftime("%I:%M%P")
    end_time = DateTime.parse(event['end_time']).strftime("%I:%M%P")
    start_date = DateTime.parse(event['start_time']).strftime("%b %e, %Y")

    "#{start_time} to #{end_time} on #{start_date}"
  end

  def format_where(venue)
    if venue.present? && venue['title'].present?
      "at #{venue['title']}"
    else
      ""
    end
  end

  def format_why(why)
    if why.present?
      "why: #{why}"
    else
      ""
    end
  end
end
