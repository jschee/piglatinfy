class WikisController < ApplicationController
  def index; end

  def create
    url =  params[:url]
    @wiki = Wiki.new(url: url)
    @wiki.process
    respond_to do |format|
      format.turbo_stream
    end
  end
end