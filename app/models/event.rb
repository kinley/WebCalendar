class Event < ActiveRecord::Base

	has_many :repeats
	
	def self.find_all_by_day(string)
		date = string.to_date
		#mday = (date.day < 10) ? "0#{mday}" : mday.to_s
		mday = date.day
		wday = date.wday
		
		Event.find_by_sql ["SELECT * FROM events e LEFT OUTER JOIN repeats r ON e.id = r.event_id
			WHERE strftime('%d.%m.%Y', date) = ? OR
						(repeating_type = 1 AND repeating_day = ?) OR 
						(repeating_type = 2 AND repeating_day = ?)
			GROUP BY id", date.strftime('%d.%m.%Y'), wday, mday]
	end
	
	#def self.find_all_by_day(string)
	#	date = string.to_date
	#	Event.where(:date => (date.beginning_of_day..date.end_of_day)).order(:date)
	#end
	
	def self.find_all_by_week(string)
		date = string.to_date
		w_begin = date.beginning_of_week
		w_end = date.end_of_week
		
		if (w_begin.day > w_end.day)
			Event.find_by_sql ["SELECT e.id as id, e.date as date, e.title as title 
				FROM events e LEFT OUTER JOIN repeats r ON e.id = r.event_id
				WHERE (date >= ? AND date <= ?) OR (repeating_type = 1) OR 
							(repeating_type = 2 AND ((repeating_day >= ?) OR (repeating_day <= ?)))
				GROUP BY id", w_begin, w_end, w_begin.day, w_end.day]
		else
			Event.find_by_sql ["SELECT e.id as id, e.date as date, e.title as title 
				FROM events e LEFT OUTER JOIN repeats r ON e.id = r.event_id
				WHERE (date >= ? AND date <= ?) OR (repeating_type = 1) OR 
							(repeating_type = 2 AND ((repeating_day >= ?) AND (repeating_day <= ?)))
				GROUP BY id", w_begin, w_end, w_begin.day, w_end.day]
		end
	end
	
	def self.find_all_by_month(string)
		date = string.to_date
		
		Event.find_by_sql ["SELECT e.id as id, e.date as date, e.title as title 
			FROM events e LEFT OUTER JOIN repeats r ON e.id = r.event_id
			WHERE (date >= ? AND date <= ?) OR (repeating_type = 1) OR (repeating_type = 2 )
			GROUP BY id", date.beginning_of_month, date.end_of_month]
	end
	
	
	#def self.find_by_wday(events, day)
	#	events.select {|item| (item.date.to_s.index(day.strftime("%Y-%m-%d"))	||
	#		(item.repeats.empty? ? nil : item.repeats.select {|item| (item.repeating_type == 1 && item.repeating_day == day.wday) })) }
	#end
	
	def self.find_by_wday(events, day)
		events.select{|item| (item.date.to_s.index(day.strftime("%Y-%m-%d")) ||
			(!item.repeats.empty? && 
				!item.repeats.find_all{|r_item|
					r_item.repeating_type == 1 && r_item.repeating_day == day.wday && item.date < day ||
					r_item.repeating_type == 2 && r_item.repeating_day == day.day && item.date < day}.empty?))}
	end
	
	def self.generate_with_repeated(string)
		date = string.to_date
		m_begin = date.beginning_of_month
		m_end = date.end_of_month
		events = Event.find_all_by_month(date)
		res = []
		res += events
		
		events.each do |event|
			event.repeats.each do |r|
				r_days = (m_begin..m_end).select{ |d|
					((r.repeating_type == 1 && d.wday == r.repeating_day && event.date.to_date < d.to_date) ||
					 (r.repeating_type == 2 && d.day == r.repeating_day && event.date.to_date < d.to_date)) }
				temp_events = []
				r_days.each do |item|
					e = Event.find(r.event_id)
					e.date = item
					res << e
				end
			end
		end
		
		return res
	end
	
	#def self.find_all_by_week(string)
	#	date = string.to_date
	#	Event.where(:date => (date.beginning_of_week..date.end_of_week)).order(:date)
	#end
		
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
