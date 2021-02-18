# require 'pry'

class Sudoku
  attr_accessor :starting_board, :solution, :removed_values, :difficulty

  BLANK_BOARD = [
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0]
  ]

  def initialize( holes = 40, status_messages = false )
    start_time = Time.now
    holes > 64 ? 64 : holes
    @status_messages = status_messages

    puts "Generating Game..." if @status_messages 
    generate_game(holes)
    
    return if !@status_messages 
    puts "Board Generated in"
    puts "#{ format_number(@iteration_counter) } Iterations"
    puts " #{ Time.now - start_time } seconds"
  end

  def generate_game(holes)
    begin
      # @start_time = Time.now
      @iteration_counter = 0
      self.solution = new_solved_board
      self.removed_values, self.starting_board = poke_holes(self.solution.map(&:clone), holes)
      self.difficulty = holes  
    rescue
      puts "#{ format_number(@iteration_counter) } iterations, Restarting"  if @status_messages 
      generate_game(holes)
    end
  end

  def new_solved_board
    new_board = BLANK_BOARD.map(&:clone)
    solve(new_board)
    new_board
  end

  def solve (puzzle_matrix)
      empty_cell = find_next_empty_cell(puzzle_matrix)
      return puzzle_matrix if !empty_cell #If no empty cells, we are done. Return the completed puzzle

      # Fill in the empty cell 
      for num in (1..9).to_a.shuffle do 
          @iteration_counter += 1
          raise if (@iteration_counter > 1_000_000)
          if safe(puzzle_matrix, empty_cell, num) # For a number, check if it safe to place that number in the empty cell
            puzzle_matrix[empty_cell[:row_i]][empty_cell[:col_i]] = num # if safe, place number
            return puzzle_matrix if solve(puzzle_matrix) # Recursively call solve method again.
            puzzle_matrix[empty_cell[:row_i]][empty_cell[:col_i]] = 0
          end
      end
      return false  #If unable to place a number, return false, trigerring previous iteration to move to next number
  end

  def find_next_empty_cell(puzzle_matrix)
      # Find the coordinates of the next unsolved cell
      empty_cell = {row_i:"",col_i:""}
      for row in puzzle_matrix do
        next_zero_index = row.find_index(0)
        empty_cell[:row_i] = puzzle_matrix.find_index(row)
        empty_cell[:col_i] = next_zero_index
        return empty_cell if empty_cell[:col_i]
      end

      return false
  end

  def safe(puzzle_matrix, empty_cell, num)
      row_safe(puzzle_matrix, empty_cell, num) && 
      col_safe(puzzle_matrix, empty_cell, num) && 
      box_safe(puzzle_matrix, empty_cell, num)
  end

  def row_safe (puzzle_matrix, empty_cell, num)
      !puzzle_matrix[ empty_cell[:row_i] ].find_index(num)
  end

  def col_safe (puzzle_matrix, empty_cell, num)
      !puzzle_matrix.any?{|row| row[ empty_cell[:col_i] ] == num}
  end

  def box_safe (puzzle_matrix, empty_cell, num)
      box_start_row = (empty_cell[:row_i] - (empty_cell[:row_i] % 3)) 
      box_start_col = (empty_cell[:col_i] - (empty_cell[:col_i] % 3)) 

      (0..2).to_a.each do |box_row|
          (0..2).to_a.each do |box_col|
              return false if puzzle_matrix[box_start_row + box_row][box_start_col + box_col] == num
          end
      end
      return true
  end


  def poke_holes(puzzle_matrix, holes)
    removed_values = []

    while removed_values.length < holes
      row_i = (0..8).to_a.sample
      col_i = (0..8).to_a.sample

      next if (puzzle_matrix[row_i][col_i] == 0)
      removed_values.push({row_i: row_i, col_i: col_i, val: puzzle_matrix[row_i][col_i] })
      puzzle_matrix[row_i][col_i] = 0

      proposed_board = puzzle_matrix.map(&:clone)
      if !solve( proposed_board )
        puzzle_matrix[row_i][col_i] = removed_values.pop[:val]
      end
    end

    [removed_values, puzzle_matrix]
  end

  def render(board_name)
    b = self.send(board_name).map{|row| row.map{|col| col == 0 ? " " : col} }
    puts "
  ┏━━━┳━━━┳━━━┱───┬───┬───┲━━━┳━━━┳━━━┓
  ┃ #{b[0][0]} ┃ #{b[0][1]} ┃ #{b[0][2]} ┃ #{b[0][3]} │ #{b[0][4]} │ #{b[0][5]} ┃ #{b[0][6]} ┃ #{b[0][7]} ┃ #{b[0][8]} ┃
  ┣━━━╋━━━╋━━━╉───┼───┼───╊━━━╋━━━╋━━━┫
  ┃ #{b[1][0]} ┃ #{b[1][1]} ┃ #{b[1][2]} ┃ #{b[1][3]} │ #{b[1][4]} │ #{b[1][5]} ┃ #{b[1][6]} ┃ #{b[1][7]} ┃ #{b[1][8]} ┃
  ┣━━━╋━━━╋━━━╉───┼───┼───╊━━━╋━━━╋━━━┫
  ┃ #{b[2][0]} ┃ #{b[2][1]} ┃ #{b[2][2]} ┃ #{b[2][3]} │ #{b[2][4]} │ #{b[2][5]} ┃ #{b[2][6]} ┃ #{b[2][7]} ┃ #{b[2][8]} ┃
  ┡━━━╇━━━╇━━━╋━━━╈━━━╈━━━╋━━━╇━━━╇━━━┩
  │ #{b[3][0]} │ #{b[3][1]} │ #{b[3][2]} ┃ #{b[3][3]} ┃ #{b[3][4]} ┃ #{b[3][5]} ┃ #{b[3][6]} │ #{b[3][7]} │ #{b[3][8]} │
  ├───┼───┼───╊━━━╋━━━╋━━━╉───┼───┼───┤
  │ #{b[4][0]} │ #{b[4][1]} │ #{b[4][2]} ┃ #{b[4][3]} ┃ #{b[4][4]} ┃ #{b[4][5]} ┃ #{b[4][6]} │ #{b[4][7]} │ #{b[4][8]} │
  ├───┼───┼───╊━━━╋━━━╋━━━╉───┼───┼───┤
  │ #{b[5][0]} │ #{b[5][1]} │ #{b[5][2]} ┃ #{b[5][3]} ┃ #{b[5][4]} ┃ #{b[5][5]} ┃ #{b[5][6]} │ #{b[5][7]} │ #{b[5][8]} │
  ┢━━━╈━━━╈━━━╋━━━╇━━━╇━━━╋━━━╈━━━╈━━━┪
  ┃ #{b[6][0]} ┃ #{b[6][1]} ┃ #{b[6][2]} ┃ #{b[6][3]} │ #{b[6][4]} │ #{b[6][5]} ┃ #{b[6][6]} ┃ #{b[6][7]} ┃ #{b[6][8]} ┃
  ┣━━━╋━━━╋━━━╉───┼───┼───╊━━━╋━━━╋━━━┫
  ┃ #{b[7][0]} ┃ #{b[7][1]} ┃ #{b[7][2]} ┃ #{b[7][3]} │ #{b[7][4]} │ #{b[7][5]} ┃ #{b[7][6]} ┃ #{b[7][7]} ┃ #{b[7][8]} ┃
  ┣━━━╋━━━╋━━━╉───┼───┼───╊━━━╋━━━╋━━━┫
  ┃ #{b[8][0]} ┃ #{b[8][1]} ┃ #{b[8][2]} ┃ #{b[8][3]} │ #{b[8][4]} │ #{b[8][5]} ┃ #{b[8][6]} ┃ #{b[8][7]} ┃ #{b[8][8]} ┃
  ┗━━━┻━━━┻━━━┹───┴───┴───┺━━━┻━━━┻━━━┛
  "
  end

  private

  def format_number(integer)
    number_of_digits = Math.log(integer, 10).floor + 1
    number_of_segments = (number_of_digits / 3.0).ceil
    int_as_array = integer.to_s.split("")
    formatted_array = []
    index = 1
    
    while index <= number_of_digits do 
      formatted_array.unshift(int_as_array[ index * -1 ] )
      formatted_array.unshift("_") if index % 3 == 0 && index != number_of_digits
      index += 1
    end
    formatted_array.join("")
  end

end

# binding.pry
# false