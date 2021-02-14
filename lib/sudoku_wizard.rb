require 'pry'

class Sudoku
  attr_accessor :solution, :board

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
  BLANK_BOARD

  @@num_array = [1, 2, 3, 4, 5, 6, 7, 8, 9]

  def initialize
    start = Time.now
    new_board = BLANK_BOARD.map(&:clone)
    counter = 0

    while new_board.last.last == 0 do
      new_board = clean_board
      generate_puzzle(new_board)
      counter += 1
    end
    self.solution = new_board.map(&:clone)
    self.board = remove_num(new_board.map(&:clone), 20)
    puts Time.now - start
    puts counter
    # binding.pry
  end

  def clean_board
    board = [
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
    return board
  end



  def generate_puzzle (puzzle_array)
      empty_cell = find_next_empty_cell(puzzle_array)
      return true if !empty_cell #If no empty cells, we are done. Return the completed puzzle

      # Fill in the empty cell
      @@num_array.shuffle.each do |num|
          if safe(puzzle_array, empty_cell, num) # For a number, check if it safe to place that number in the empty cell
              puzzle_array[empty_cell[:row_i]][empty_cell[:col_i]] = num # if safe, place number
              return puzzle_array if generate_puzzle(puzzle_array) # Recursively call solve method again.
          end
      end
      return false  #If unable to place a number, return false, trigerring previous iteration to move to next number
  end

  def solve (puzzle_array)
    empty_cell = find_next_empty_cell(puzzle_array)
    return true if !empty_cell #If no empty cells, we are done. Return the solved puzzle

    # Fill in the empty cell
    (1..9).to_a.each do |num|
        # puts "trying #{num}"
        # sleep(0.2)
        if safe(puzzle_array, empty_cell, num) # For a number, check if it safe to place that number in the empty cell
          # puts "#{num} placed"
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
      # puts "row safe"
      return true
  end

  def col_safe (puzzle_array, empty_cell, num)
      return false if puzzle_array.any?{|row| row[ empty_cell[:col_i] ] == num}
      # puts "col safe"
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
      # puts "box safe"
      return true
  end


  def remove_num(puzzle_array, holes)
    removed_vals = []

    while removed_vals.length < holes
      # binding.pry
      val = (1..81).to_a.sample
      row_i = val / 9
      col_i= val % 9
      next if (puzzle_array[row_i][col_i] == 0)
      removed_vals.push({row_i: row_i, col_i: col_i, val: puzzle_array[row_i][col_i] })
      puzzle_array[row_i][col_i] = 0
      if !solve( puzzle_array.map(&:clone) )
        puzzle_array[row_i][col_i] = removed_vals.last[:val]
        removed_vals.pop
      end
    end
    puzzle_array
  # binding.pry
  end


end

binding.pry
false