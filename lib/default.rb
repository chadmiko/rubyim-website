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

    rescue 
      next 
    end    

    i
  end

end

def chop_to_html(identifier)
  identifier.chop + ".html"
end

