class StoriesController < ApplicationController
  def index
  
  end
  
  def show
    begin
      story = Story.find(params[:story_id])
      
      @story_id = params[:story_id]
      @story_name = story.name
    rescue
      redirect_to(root_path)
    end
  end
end