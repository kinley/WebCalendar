class EventsController < ApplicationController
  
  def calendar
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  	@events = Event.generate_with_repeated(@date)
    @selected = "month"
  end
  
  def week
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @dates = (@date.beginning_of_week..@date.end_of_week).to_a
  	@events = Event.find_all_by_week(@date)
    @selected = "week"
  end
  
  def day
  	@date = params[:date] ? Date.parse(params[:date]) : Date.today
  	@events = Event.find_all_by_day(@date)
    @selected = "day"
  end
  
  # GET /events
  # GET /events.xml
  def index
    @events = Event.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])
		@wrepeats = params[:wday].first.to_hash if params[:wday]
		@mrepeats = params[:mday].first.to_hash if params[:mday]
		
    respond_to do |format|
      if @event.save
      	@wrepeats.each_value { |val| @event.repeats.new(:repeating_type => 1, :repeating_day => val).save } if @wrepeats
      	@mrepeats.each_value { |val| @event.repeats.new(:repeating_type => 2, :repeating_day => val).save } if @mrepeats
      	
        format.html { redirect_to(@event, :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end
end
