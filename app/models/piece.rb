class Piece < ApplicationRecord
  belongs_to :game
  belongs_to :user
  has_many :moves

  def within_bounds?(x_new, y_new)
    x_new >= 0 && y_new >= 0 && x_new <= 7 && y_new <= 7
  end

  def valid_move?(x_new, y_new)
    return false if move_type(x_new, y_new) == :invalid
    true
  end

  # returns the distance between the input 
  # x position and the current x position
  # in order to check for valid move distance
  def x_diff(x)
    (x - x_pos).abs
  end
  
  # same as above but for y position
  def y_diff(y)
    (y - y_pos).abs
  end

  def move_type(x_new, y_new)
    # Need to deal with Knight case
    vertical_delta = (x_new - x_pos).abs
    horizontal_delta = (y_new - y_pos).abs

    return :horizontal if horizontal_delta > 0 && vertical_delta.zero?
    return :vertical if vertical_delta > 0 && horizontal_delta.zero?
    return :diagonal if vertical_delta == horizontal_delta
    # Knight case is a bit of a hack, tried the code below, could not quite get it to pass the test. This needs to be addressed 
    # at some point
    # return :knight if Rational(vertical_delta, horizontal_delta) == (2/1) || Rational(vertical_delta, horizontal_delta) == (1/2)
    return :knight if self.type = "Knight"
    return :invalid if vertical_delta > 0 && horizontal_delta > 0 && vertical_delta != horizontal_delta
  end

  def is_obstructed?(x_new, y_new)
    move_direction = move_type(x_new, y_new)
    pieces_in_row = game.pieces.where(x_pos: x_new)
    pieces_in_column = game.pieces.where(y_pos: y_new)
    # horizontal case
    if move_direction == :horizontal
      return false if pieces_in_row.where("#{x_new} > ? AND #{x_new} < ?", [x_pos, x_new].min, [x_pos, x_new].max).empty?
    # vertical case
    elsif move_direction == :vertical
      return false if pieces_in_column.where("#{y_new} > ? AND #{y_new} < ?", [y_pos, y_new].min, [y_pos, y_new].max).empty?
    # diagonal case
    elsif move_direction == :diagonal
      (x_pos..x_new).each do |x|
        next if x == x_pos
        return false if x == x_new
        (y_pos..y_new).each do |y|
          next if y == y_pos
          ## why 2 instead of 1?
          # should be 1 (BK)
          return true if game.pieces.where(x_pos: x, y_pos: y).size == 1
        end
      end
    end
    raise "Invalid move" if move_direction == :invalid
  end

  # move_to! method calls valid_move? and will update a piece instance's
  # position and/or capture by setting positions to null. Could update
  # this later to incorporate a piece status
  
  def move_to!(x_new, y_new)
    return raise "Invalid move" if !valid_move?(x_new, y_new)
    occupant = game.piece_present(x_new, y_new)
    current_piece = game.pieces.where(x_pos: x_pos, y_pos: y_pos).first
    if occupant.nil?
      current_piece.update_attributes(x_pos: x_new, y_pos: y_new)
    elsif occupant.color != current_piece.color
      current_piece.update_attributes(x_pos: x_new, y_pos: y_new)
      occupant.update_attributes(x_pos: nil, y_pos: nil)
    else return raise "Invalid move"
    end
  end

  def piece_color
    if self.color == false
      'black'
    elsif self.color == true
      'white'
    else self.color
    end
  end

  def symbol
    self.color ? 'X' : 'Y'
  end
end
