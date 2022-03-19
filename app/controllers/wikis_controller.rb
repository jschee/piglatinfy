class WikisController < ApplicationController
  def index; end

  def create
    url =  params[:url]
    @wiki = Wiki.new(url: url)
    respond_to do |format|
      if url.present?
        @wiki.process
        format.turbo_stream
      else
        format.html { render :index, status: :unprocessable_entity }
        @error_message = "No wikipedia article was found"
      end
    end
  end
end