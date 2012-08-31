class HomeController < ApplicationController
  def index
    tiles = Tile.order("created_at")
    id = params[:id]
    t = []
    i = 1
    tiles.each do |tile|
      t << {:id => i,
            :description => tile.description,
            :image => tile.image}
      i += 1
    end
    render :text => t.to_json
  end

end
