class HomeController < ApplicationController
  def index
    id = params[:id].to_i
    render :text => Tile.where("id >= ?" , id).order("created_at").to_json
  end

end
