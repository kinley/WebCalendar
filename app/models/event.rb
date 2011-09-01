class Event < ActiveRecord::Base
	
	def self.find_all_by_day(string)
		date = string.to_date
		Event.where(:date => (date.beginning_of_day..date.end_of_day)).order(:date)
	end
	
	def self.find_all_by_week(string)
		date = string.to_date
		Event.where(:date => (date.beginning_of_week..date.end_of_week)).order(:date)
	end
		
	def self.wday_to_s(num)
		case num
		when 1
			"Monday"
		when 2
			"Tuesday"
		when 3
			"Wednesday"
		when 4
			"Thursday"
		when 5
			"Friday"
		when 6
			"Saturday"
		when 0
			"Sunday"
		end
	end
	
end
