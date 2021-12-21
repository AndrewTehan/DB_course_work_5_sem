class SearchController < ApplicationController
  def search
    @search_list = Elasticsearch::Model.search(params[:text], [Master, Service]).records.to_a
    respond_to do |format|
      format.js
      format.html { redirect_to root_path }
    end
  end
end