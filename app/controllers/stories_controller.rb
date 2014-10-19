class StoriesController < ApplicationController
  def index
  
  end
  
  def list
    begin
      @stories = Story.all
    rescue
      flash[:error] = "An error occurred while getting a list of stories."
      redirect_to(root_path)
    end
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
      redirect_to(show_story_path(story_id: params[:story_id]))
    end
  end
  
  def update
    begin
      chapter = Chapter.find(params[:chapter_id])
      
      if chapter.story_id.to_s != params[:story_id]
        flash[:error] = "An error occurred while updating the chapter."
        redirect_to(show_story_path(story_id: params[:story_id]))
        return
      end
      
      if (params[:choice_one_id] != "" && Chapter.find(params[:choice_one_id]).story_id.to_s != params[:story_id])
        flash[:error] = "An error occurred while updating the chapter."
        redirect_to(show_story_path(story_id: params[:story_id]))
        return
      end
      
      if (params[:choice_two_id] != "" && Chapter.find(params[:choice_two_id]).story_id.to_s != params[:story_id])
        flash[:error] = "An error occurred while updating the chapter."
        redirect_to(show_story_path(story_id: params[:story_id]))
        return
      end
      
      if (params[:choice_three_id] != "" && Chapter.find(params[:choice_three_id]).story_id.to_s != params[:story_id])
        flash[:error] = "An error occurred while updating the chapter."
        redirect_to(show_story_path(story_id: params[:story_id]))
        return
      end
      
      if (params[:scenario] == "")
        flash[:error] = "An error occurred while updating the chapter."
        redirect_to(show_story_path(story_id: params[:story_id]))
        return
      end
      
      chapter.scenario = params[:scenario]
      chapter.choice_one = params[:choice_one]
      chapter.choice_one_id = params[:choice_one_id]
      chapter.choice_two = params[:choice_two]
      chapter.choice_two_id = params[:choice_two_id]
      chapter.choice_three = params[:choice_three]
      chapter.choice_three_id = params[:choice_three_id]
      chapter.save
      
      redirect_to(show_story_path(story_id: params[:story_id]))
    rescue
      flash[:error] = "An error occurred while updating the chapter."
      redirect_to(show_story_path(story_id: params[:story_id]))
    end
  end
end