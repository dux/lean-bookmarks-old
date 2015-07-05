module TimeOptions
  def short
    strftime("%Y-%m-%d")    
  end

  def long
    strftime("%Y-%m-%d %H:%m")    
  end
end

class Time
  include TimeOptions

  def self.ago(start_time, end_time=nil)
    end_time ||= DateTime.now
    time_diff = end_time.to_i - start_time.to_i

    d_minutes = (time_diff/60).round
    d_hours   = (time_diff/(60*60)).round
    d_days    = (time_diff/(60*60*24)).round
    d_months  = (time_diff/(60*60*24*30)).round

    return 'Few sec ago' if time_diff < 10
    return 'Less than min ago' if time_diff < 60
    return "#{d_months} months ago" if d_months > 0
    return "#{d_days} days ago" if d_days > 0
    return "#{d_hours} hours ago" if d_hours > 0
    return "Time.ago error" if d_hours > 0
  end
end

class DateTime
  include TimeOptions
end
