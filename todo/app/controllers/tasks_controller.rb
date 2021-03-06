class TasksController < ApplicationController
  # GET /tasks
  # GET /tasks.xml
  def index
    @tasks = Task.all(:order => "priority DESC")
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
    end
  end

  def today
    @tasks = Task.find_all_by_today(true)
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @tasks }
    end
  end
  
  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = Task.new

    @projects = Project.all

    if pid = params[:project_id]
      @task[:project_id] = pid
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
    
    @projects = Project.all
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    @task = Task.new(params[:task])

    respond_to do |format|
      if @task.save
        format.html { redirect_to(tasks_url, :notice => 'Task was successfully created.') }
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to(tasks_url, :notice => 'Task was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to(tasks_url) }
      format.xml  { head :ok }
    end
  end
  
  
  def complete
    @task = Task.find(params[:id])
    
    @task.update_attributes(:completed => !@task.completed)

    @task.project.update_attributes(:completed => false) if !@task.completed and @task.project.completed

    respond_to do |format|
      format.html { redirect_back_or tasks_url }
      format.xml  { head :ok }
    end
  end
  
  def do_today
    @task = Task.find(params[:id])
    @task.update_attributes(:today => !@task.today, :completed => false)
    
    respond_to do |format|
      format.html { redirect_back_or tasks_url }
      format.xml  { head :ok }
    end
  end
  
  def clear_completed
    @tasks = Task.find(:all, :conditions => { :completed => true })
    
    @tasks.each do |task|
      task.destroy
    end

    respond_to do |format|
      format.html { redirect_to(tasks_url) }
      format.xml  { head :ok }
    end
  end
end
