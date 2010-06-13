class ProjectsController < ApplicationController
  before_filter :find_project, :only => [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.xml
  def index
    @projects = Project.all

    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    respond_to do |wants|
      wants.html # show.html.erb
      wants.xml  { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new

    respond_to do |wants|
      wants.html # new.html.erb
      wants.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])

    respond_to do |wants|
      if @project.save
        flash[:notice] = 'Project was successfully created.'
        wants.html { redirect_to(projects_url) }
        wants.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        wants.html { render :action => "new" }
        wants.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    respond_to do |wants|
      if @project.update_attributes(params[:project])
        flash[:notice] = 'Project was successfully updated.'
        wants.html { redirect_to(projects_url) }
        wants.xml  { head :ok }
      else
        wants.html { render :action => "edit" }
        wants.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project.destroy

    respond_to do |wants|
      wants.html { redirect_to(projects_url) }
      wants.xml  { head :ok }
    end
  end

  def complete
    @project = Project.find(params[:id])
    
    @tasks = @project.tasks
    @tasks.each do |task|
      task.update_attributes(:completed => !@project.completed)
    end
    
    @project.update_attributes(:completed => !@project.completed)


    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end


  private
    def find_project
      @project = Project.find(params[:id])
    end

end
