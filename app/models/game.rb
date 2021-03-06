class Game < ApplicationRecord
  after_create :populate_game!

  has_many :user_games
  has_many :users
  has_many :pieces
  has_many :moves

  scope :available, -> { where("black_player_user_id is null or white_player_user_id is null") }


def populate_game!
  create_black_pieces
  create_white_pieces
  set_player_ids
end

# is black/white_player_user_id is set, update pieces.user_id for that player
def set_player_ids
  set_pieces_user(false, self.black_player_user_id) if self.black_player_user_id.present?
  set_pieces_user(true, self.white_player_user_id) if self.white_player_user_id.present?
end

def set_pieces_user(color, user_id)
    self.pieces.where(color: color).update_all(user_id: user_id)
end

def create_white_pieces
  8.times do |i|
    Pawn.create(
      :game_id => self.id,
      :x_pos => i,
      :y_pos => 1,
      :color => true
    )
  end

  Rook.create(
    :game_id => self.id,
    :x_pos => 0,
    :y_pos => 0,
    :color => true
  )
  Rook.create(
    :game_id => self.id,
    :x_pos => 7,
    :y_pos => 0,
    :color => true
  )
  Knight.create(
    :game_id => self.id,
    :x_pos => 1,
    :y_pos => 0,
    :color => true
  )
  Knight.create(
    :game_id => self.id,
    :x_pos => 6,
    :y_pos => 0,
    :color => true
  )
  Bishop.create(
    :game_id => self.id,
    :x_pos => 2,
    :y_pos => 0,
    :color => true
  )
  Bishop.create(
    :game_id => self.id,
    :x_pos => 5,
    :y_pos => 0,
    :color => true
  )
  Queen.create(
    :game_id => self.id,
    :x_pos => 4,
    :y_pos => 0,
    :color => true
  )
  King.create(
    :game_id => self.id,
    :x_pos => 3,
    :y_pos => 0,
    :color => true
  )
end


def create_black_pieces
  8.times do |y|
    Pawn.create(
      :game_id => self.id,
      :x_pos => y,
      :y_pos => 6,
      :color => false
    )
  end
  Rook.create(
    :game_id => self.id,
    :x_pos => 0,
    :y_pos => 7,
    :color => false
  )
  Rook.create(
    :game_id => self.id,
    :x_pos => 7,
    :y_pos => 7,
    :color => false
  )
  Knight.create(
    :game_id => self.id,
    :x_pos => 1,
    :y_pos => 7,
    :color => false
  )
  Knight.create(
    :game_id => self.id,
    :x_pos => 6,
    :y_pos => 7,
    :color => false
  )
  Bishop.create(
    :game_id => self.id,
    :x_pos => 2,
    :y_pos => 7,
    :color => false
  )
  Bishop.create(
    :game_id => self.id,
    :x_pos => 5,
    :y_pos => 7,
    :color => false
  )
  Queen.create(
    :game_id => self.id,
    :x_pos => 4,
    :y_pos => 7,
    :color => false
  )
  King.create(
    :game_id => self.id,
    :x_pos => 3,
    :y_pos => 7,
    :color => false
  )
end

  def piece_present(x_pos, y_pos)
    pieces.where(x_pos: x_pos, y_pos: y_pos).first
  end

end
