# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.
require 'chronic'

include Nanoc3::Helpers::Blogging
include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::XMLSitemap
include Nanoc3::Helpers::Tagging

def events_by_month(month, year=Date.today.year)
  months = if month.is_a?(Array)
    month
  else
    [month]
  end 

  @items.select do |i| 
    next unless i[:kind] == 'event' && i[:start_at] 

    begin
      dt = Chronic.parse(i[:start_at])
      next unless months.include?(dt.month) && year == dt.year

    rescue Exception => e 
      puts e.message 
      next 
    end    

    i
  end

end

def recent_news(limit=5)
  @items.select{ |i| i[:kind] == 'article' && i[:publish_at]}.sort do |x, y|
    begin
      x_dt = Chronic.parse(x[:publish_at])
      y_dt = Chronic.parse(y[:publish_at])
      y_dt <=> x_dt
    rescue 
      x[:title] <=> y[:title]
    end
  end
end

def chop_to_html(identifier)
  identifier.chop + ".html"
end

def carriers
  @items.select {|i| i[:kind] == 'carrier' }.sort
end
