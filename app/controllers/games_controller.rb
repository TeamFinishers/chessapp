class GamesController < ApplicationController

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
    redirect_to game_path(@game)
  end

  def show
    @game = Game.find(params[:id])
    @piece = Piece.find(params[:id])
  end

  def update
  end

  private 

  def game_params
    params.require(:game).
      permit(:black_player_user_id, :white_player_user_id, :turn_user_id,)
  end
end
