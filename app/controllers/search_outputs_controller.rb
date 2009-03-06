class SearchOutputsController < ApplicationController
  def new
  end
  
  def create
    redirect_to(params.merge :controller => "topics", :action => "index")
  end

end
