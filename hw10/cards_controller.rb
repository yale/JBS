class CardsController < ApplicationController
  # GET /cards
  # GET /cards.xml
  def index
    @cards = Card.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cards }
    end
  end

  # GET /cards/1
  # GET /cards/1.xml
  def show
    @card = Card.find_by_name(params[:name]);

    if @card
      respond_to do |format|
        format.xml  { render :xml => @card[0] }
      end
    else
      respond_to do |format|
        format.xml {render :xml => "<error>No card by that name found.</error>"}
      end
    end
  end

  # GET /cards/new
  # GET /cards/new.xml
  def new
    @card = Card.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @card }
    end
  end

  # GET /cards/1/edit
  def edit
    @card = Card.find(params[:id])
  end

  # POST /cards
  # POST /cards.xml
  def create
    @card = Card.new(params[:card])

    respond_to do |format|
      if @card.save
        flash[:notice] = 'Card was successfully created.'
        format.xml  { render "<message>Your card has been created.</message>", :status => :created, :location => @card }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @card.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cards/1
  # PUT /cards/1.xml
  def update
    @card = Card.find(params[:id])

    respond_to do |format|
      if @card.update_attributes(params[:card])
        flash[:notice] = 'Card was successfully updated.'
        format.html { redirect_to(@card) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @card.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def store
    begin
      @card = Card.find(params[:id])
    rescue
      @card = Card.new
    end
    respond_to do |format|
      if @card.update_attributes(params[:card])
        flash[:notice] = 'Card was successfully updated.'
        format.xml  { head :ok }
      else
        format.xml  { render :xml => @card.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.xml
  def destroy
    @card = Card.find(params[:id])
    @card.destroy

    respond_to do |format|
      format.html { redirect_to(cards_url) }
      format.xml  { head :ok }
    end
  end
  
  ### SEED
  #   declared to respond to POST in routes.rb
  def seed
    number = params[:number]
    names = ["Bill", "Karen", "Frank", "Lisa", "Steve", "Sara", "Jeremy", "GladOS"]
    @cards = []
    number.to_i.times do
      @cards << Card.new(:name => names[rand * names.size], :office_phone => (rand * 10000000).to_i, :home_phone => (rand * 10000000).to_i)
    end
    
    @cards.each do |card|
      card.save!
    end
    
    respond_to do |format|
      format.xml  { render :xml => @cards, :status => :created }
    end
  end
end
