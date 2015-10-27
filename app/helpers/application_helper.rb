module ApplicationHelper
  def alert_name(name)
    case name
    when "notice"
      "success"
    when "alert"
      "danger"
    else
      "info"
    end
  end

  def time_mini(start_time, end_time)
    (end_time.to_f - start_time.to_f)
  end
  
end
