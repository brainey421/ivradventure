class StoriesController < ApplicationController
  def index
  
  end
  
  def new
    begin
      if (!params[:story_name] || params[:story_name] == "")
        flash[:error] = "Please enter a valid story name."
        redirect_to(root_path)
        return
      end
      
      newid = rand(9000) + 1000
      while (Story.where(id: newid).size > 0)
        newid = rand(9000) + 1000
      end
      
      c = Chapter.new
      c.story_id = newid
      c.scenario = "You are in some scenario."
      c.save
      
      s = Story.new
      s.id = newid
      s.name = params[:story_name]
      s.chapter_one = c.id
      s.save
      
      redirect_to(show_story_path(story_id: s.id))
    rescue
      flash[:error] = "Please enter a valid story name."
      redirect_to(root_path)
    end
  end
  
  def show
    begin
      story = Story.find(params[:story_id])
      
      @story_id = params[:story_id]
      @story_name = story.name
      @chapters = Chapter.where(story_id: params[:story_id])
    rescue
      flash[:error] = "Please enter a valid story ID."
      redirect_to(root_path)
    end
  end
  
  def add_to
    begin
      story = Story.find(params[:story_id])
      
      c = Chapter.new
      c.story_id = story.id
      c.scenario = "You are in some scenario."
      c.save
      
      redirect_to(show_story_path(story_id: params[:story_id]))
    rescue
      flash[:error] = "An error occurred while adding a new chapter."
      redirect_to(root_path)
    end
  end
end