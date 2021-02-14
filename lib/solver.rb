class Board < ApplicationRecord
  has_many :users, through: :user_boards

  @@basic_puzzle = [
      [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
      [ 4, 5, 6, 7, 8, 9, 1, 2, 3 ],
      [ 7, 8, 9, 1, 2, 3, 4, 5, 6 ],
      [ 2, 3, 1, 5, 6, 4, 8, 9, 7 ],
      [ 5, 6, 4, 8, 9, 7, 2, 3, 1 ],
      [ 8, 9, 7, 2, 3, 1, 5, 6, 4 ],
      [ 3, 1, 2, 6, 4, 5, 9, 7, 8 ],
      [ 6, 4, 5, 9, 7, 8, 3, 1, 2 ],
      [ 9, 7, 8, 3, 1, 2, 6, 4, 5 ]
  ]
  @@basic_puzzle.freeze

  def initialize( *arguments )
      super( *arguments )
      @random_board = @@basic_puzzle.clone
      20.times{ shuffle( @random_board ) }
      @poke_holes_in_random_board = poke( @random_board, 50 )
      binding.pry
      self.solved_board = @random_board
      self.starting_board = @poke_holes_in_random_board
      self.board_in_progress = @poke_holes_in_random_board
      self.save
  end

  private
  
  def generate_grille( number_of_holes )
      ( Array.new( 81 - number_of_holes, false ) + Array.new( number_of_holes, true ) ).shuffle
  end

  def poke( puzzle_array, number_of_holes )
      grille = generate_grille( number_of_holes )
      puzzle_array.flatten.map.with_index{ | cell, index | cell = grille[ index ] ? 0 : cell }.each_slice( 9 ).to_a
  end

  def shuffle( puzzle_array )
      two_random_digits = ( 1..9 ).to_a.sample( 2 )
      puzzle_array.each do | row |
          thisIndex = row.index( two_random_digits[ 0 ] )
          thatIndex = row.index( two_random_digits[ 1 ] )
          row[ thisIndex ], row[ thatIndex ] = row[ thatIndex ], row[ thisIndex ]
      end
  end


  def solve (puzzle_array)
      empty_cell = find_next_empty_cell(puzzle_array)
      return true if !empty_cell #If no empty cells, we are done. Return the solved puzzle

      # Fill in the empty cell
      (1..9).to_a.each do |num|
          if safe(puzzle_array, empty_cell, num) # For a number, check if it safe to place that number in the empty cell
              puzzle_array[empty_cell[:row_i]][empty_cell[:col_i]] = num # if safe, place number
              return puzzle_array if solve(puzzle_array) # Recursively call solve method again.
          end
      end
      return false  #If unable to place a number, return false, trigerring previous iteration to move to next number
  end

  def find_next_empty_cell(puzzle_array)
      # Find the coordinates of the next unsolved cell
      empty_cell = {row_i:"",col_i:""}
      puzzle_array.each_with_index do |row, row_index|
          row.each_with_index do |column, col_index|
              if column == 0 
                  empty_cell[:row_i], empty_cell[:col_i] = row_index, col_index  
                  break
              end   
          end   
          break if !(empty_cell[:row_i] == "") && !(empty_cell[:col_i] == "")
      end
      !(empty_cell[:col_i] == "") ? empty_cell : false
  end

  def safe(puzzle_array, empty_cell, num)
      row_safe(puzzle_array, empty_cell, num) && 
      col_safe(puzzle_array, empty_cell, num) && 
      box_safe(puzzle_array, empty_cell, num)
  end

  def row_safe (puzzle_array, empty_cell, num)
      return false if puzzle_array[ empty_cell[:row_i] ].find_index(num)
      return true
  end

  def col_safe (puzzle_array, empty_cell, num)
      return false if puzzle_array.any?{|row| row[ empty_cell[:col_i] ] == num}
      return true
  end

  def box_safe (puzzle_array, empty_cell, num)
      box_start_row = (empty_cell[:row_i] - (empty_cell[:row_i] % 3)) 
      box_start_col = (empty_cell[:col_i] - (empty_cell[:col_i] % 3)) 

      (0..2).to_a.each do |box_row|
          (0..2).to_a.each do |box_col|
              return false if puzzle_array[box_start_row + box_row][box_start_col + box_col] == num
          end
      end
      return true
  end







end
