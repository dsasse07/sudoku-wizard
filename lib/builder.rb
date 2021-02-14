require 'pry'

class Sudoku

    attr_accessor :solution, :board

    def initialize( number_of_holes )
        self.solution = [ nil ]
        self.solution = populate_puzzle( starting_puzzle ) until !self.solution.flatten.include?( nil )
        self.board = poke( self.solution, generate_grille( 48 ) )
    end

    def self.to_s( board )
        %(
┏━━━┳━━━┳━━━┱───┬───┬───┲━━━┳━━━┳━━━┓
┃ #{ board[ 0 ][ 0 ].zero? ? " " : board[ 0 ][ 0 ] } ┃ #{ board[ 0 ][ 1 ].zero? ? " " : board[ 0 ][ 1 ] } ┃ #{ board[ 0 ][ 2 ].zero? ? " " : board[ 0 ][ 2 ] } ┃ #{ board[ 0 ][ 3 ].zero? ? " " : board[ 0 ][ 3 ] } │ #{ board[ 0 ][ 4 ].zero? ? " " : board[ 0 ][ 4 ] } │ #{ board[ 0 ][ 5 ].zero? ? " " : board[ 0 ][ 5 ] } ┃ #{ board[ 0 ][ 6 ].zero? ? " " : board[ 0 ][ 6 ] } ┃ #{ board[ 0 ][ 7 ].zero? ? " " : board[ 0 ][ 7 ] } ┃ #{ board[ 0 ][ 8 ].zero? ? " " : board[ 0 ][ 8 ] } ┃
┣━━━╋━━━╋━━━╉───┼───┼───╊━━━╋━━━╋━━━┫
┃ #{ board[ 1 ][ 0 ].zero? ? " " : board[ 1 ][ 0 ] } ┃ #{ board[ 1 ][ 1 ].zero? ? " " : board[ 1 ][ 1 ] } ┃ #{ board[ 1 ][ 2 ].zero? ? " " : board[ 1 ][ 2 ] } ┃ #{ board[ 1 ][ 3 ].zero? ? " " : board[ 1 ][ 3 ] } │ #{ board[ 1 ][ 4 ].zero? ? " " : board[ 1 ][ 4 ] } │ #{ board[ 1 ][ 5 ].zero? ? " " : board[ 1 ][ 5 ] } ┃ #{ board[ 1 ][ 6 ].zero? ? " " : board[ 1 ][ 6 ] } ┃ #{ board[ 1 ][ 7 ].zero? ? " " : board[ 1 ][ 7 ] } ┃ #{ board[ 1 ][ 8 ].zero? ? " " : board[ 1 ][ 8 ] } ┃
┣━━━╋━━━╋━━━╉───┼───┼───╊━━━╋━━━╋━━━┫
┃ #{ board[ 2 ][ 0 ].zero? ? " " : board[ 2 ][ 0 ] } ┃ #{ board[ 2 ][ 1 ].zero? ? " " : board[ 2 ][ 1 ] } ┃ #{ board[ 2 ][ 2 ].zero? ? " " : board[ 2 ][ 2 ] } ┃ #{ board[ 2 ][ 3 ].zero? ? " " : board[ 2 ][ 3 ] } │ #{ board[ 2 ][ 4 ].zero? ? " " : board[ 2 ][ 4 ] } │ #{ board[ 2 ][ 5 ].zero? ? " " : board[ 2 ][ 5 ] } ┃ #{ board[ 2 ][ 6 ].zero? ? " " : board[ 2 ][ 6 ] } ┃ #{ board[ 2 ][ 7 ].zero? ? " " : board[ 2 ][ 7 ] } ┃ #{ board[ 2 ][ 8 ].zero? ? " " : board[ 2 ][ 8 ] } ┃
┡━━━╇━━━╇━━━╋━━━╈━━━╈━━━╋━━━╇━━━╇━━━┩
│ #{ board[ 3 ][ 0 ].zero? ? " " : board[ 3 ][ 0 ] } │ #{ board[ 3 ][ 1 ].zero? ? " " : board[ 3 ][ 1 ] } │ #{ board[ 3 ][ 2 ].zero? ? " " : board[ 3 ][ 2 ] } ┃ #{ board[ 3 ][ 3 ].zero? ? " " : board[ 3 ][ 3 ] } ┃ #{ board[ 3 ][ 4 ].zero? ? " " : board[ 3 ][ 4 ] } ┃ #{ board[ 3 ][ 5 ].zero? ? " " : board[ 3 ][ 5 ] } ┃ #{ board[ 3 ][ 6 ].zero? ? " " : board[ 3 ][ 6 ] } │ #{ board[ 3 ][ 7 ].zero? ? " " : board[ 3 ][ 7 ] } │ #{ board[ 3 ][ 8 ].zero? ? " " : board[ 3 ][ 8 ] } │
├───┼───┼───╊━━━╋━━━╋━━━╉───┼───┼───┤
│ #{ board[ 4 ][ 0 ].zero? ? " " : board[ 4 ][ 0 ] } │ #{ board[ 4 ][ 1 ].zero? ? " " : board[ 4 ][ 1 ] } │ #{ board[ 4 ][ 2 ].zero? ? " " : board[ 4 ][ 2 ] } ┃ #{ board[ 4 ][ 3 ].zero? ? " " : board[ 4 ][ 3 ] } ┃ #{ board[ 4 ][ 4 ].zero? ? " " : board[ 4 ][ 4 ] } ┃ #{ board[ 4 ][ 5 ].zero? ? " " : board[ 4 ][ 5 ] } ┃ #{ board[ 4 ][ 6 ].zero? ? " " : board[ 4 ][ 6 ] } │ #{ board[ 4 ][ 7 ].zero? ? " " : board[ 4 ][ 7 ] } │ #{ board[ 4 ][ 8 ].zero? ? " " : board[ 4 ][ 8 ] } │
├───┼───┼───╊━━━╋━━━╋━━━╉───┼───┼───┤
│ #{ board[ 5 ][ 0 ].zero? ? " " : board[ 5 ][ 0 ] } │ #{ board[ 5 ][ 1 ].zero? ? " " : board[ 5 ][ 1 ] } │ #{ board[ 5 ][ 2 ].zero? ? " " : board[ 5 ][ 2 ] } ┃ #{ board[ 5 ][ 3 ].zero? ? " " : board[ 5 ][ 3 ] } ┃ #{ board[ 5 ][ 4 ].zero? ? " " : board[ 5 ][ 4 ] } ┃ #{ board[ 5 ][ 5 ].zero? ? " " : board[ 5 ][ 5 ] } ┃ #{ board[ 5 ][ 6 ].zero? ? " " : board[ 5 ][ 6 ] } │ #{ board[ 5 ][ 7 ].zero? ? " " : board[ 5 ][ 7 ] } │ #{ board[ 5 ][ 8 ].zero? ? " " : board[ 5 ][ 8 ] } │
┢━━━╈━━━╈━━━╋━━━╇━━━╇━━━╋━━━╈━━━╈━━━┪
┃ #{ board[ 6 ][ 0 ].zero? ? " " : board[ 6 ][ 0 ] } ┃ #{ board[ 6 ][ 1 ].zero? ? " " : board[ 6 ][ 1 ] } ┃ #{ board[ 6 ][ 2 ].zero? ? " " : board[ 6 ][ 2 ] } ┃ #{ board[ 6 ][ 3 ].zero? ? " " : board[ 6 ][ 3 ] } │ #{ board[ 6 ][ 4 ].zero? ? " " : board[ 6 ][ 4 ] } │ #{ board[ 6 ][ 5 ].zero? ? " " : board[ 6 ][ 5 ] } ┃ #{ board[ 6 ][ 6 ].zero? ? " " : board[ 6 ][ 6 ] } ┃ #{ board[ 6 ][ 7 ].zero? ? " " : board[ 6 ][ 7 ] } ┃ #{ board[ 6 ][ 8 ].zero? ? " " : board[ 6 ][ 8 ] } ┃
┣━━━╋━━━╋━━━╉───┼───┼───╊━━━╋━━━╋━━━┫
┃ #{ board[ 7 ][ 0 ].zero? ? " " : board[ 7 ][ 0 ] } ┃ #{ board[ 7 ][ 1 ].zero? ? " " : board[ 7 ][ 1 ] } ┃ #{ board[ 7 ][ 2 ].zero? ? " " : board[ 7 ][ 2 ] } ┃ #{ board[ 7 ][ 3 ].zero? ? " " : board[ 7 ][ 3 ] } │ #{ board[ 7 ][ 4 ].zero? ? " " : board[ 7 ][ 4 ] } │ #{ board[ 7 ][ 5 ].zero? ? " " : board[ 7 ][ 5 ] } ┃ #{ board[ 7 ][ 6 ].zero? ? " " : board[ 7 ][ 6 ] } ┃ #{ board[ 7 ][ 7 ].zero? ? " " : board[ 7 ][ 7 ] } ┃ #{ board[ 7 ][ 8 ].zero? ? " " : board[ 7 ][ 8 ] } ┃
┣━━━╋━━━╋━━━╉───┼───┼───╊━━━╋━━━╋━━━┫
┃ #{ board[ 8 ][ 0 ].zero? ? " " : board[ 8 ][ 0 ] } ┃ #{ board[ 8 ][ 1 ].zero? ? " " : board[ 8 ][ 1 ] } ┃ #{ board[ 8 ][ 2 ].zero? ? " " : board[ 8 ][ 2 ] } ┃ #{ board[ 8 ][ 3 ].zero? ? " " : board[ 8 ][ 3 ] } │ #{ board[ 8 ][ 4 ].zero? ? " " : board[ 8 ][ 4 ] } │ #{ board[ 8 ][ 5 ].zero? ? " " : board[ 8 ][ 5 ] } ┃ #{ board[ 8 ][ 6 ].zero? ? " " : board[ 8 ][ 6 ] } ┃ #{ board[ 8 ][ 7 ].zero? ? " " : board[ 8 ][ 7 ] } ┃ #{ board[ 8 ][ 8 ].zero? ? " " : board[ 8 ][ 8 ] } ┃
┗━━━┻━━━┻━━━┹───┴───┴───┺━━━┻━━━┻━━━┛
        )
    end

    private

    def populated_region; ( 1..9 ).to_a.shuffle.each_slice( 3 ).to_a; end
    
    def empty_region; [ [ 0, 0, 0 ], [ 0, 0, 0 ], [ 0, 0, 0 ] ]; end
    
    def starting_puzzle
        [ populated_region.zip( empty_region, empty_region ), empty_region.zip( populated_region, empty_region ), empty_region.zip( empty_region, populated_region ) ].flatten.each_slice( 9 ).to_a
    end

    def populate_puzzle( puzzle )
        for row in ( 0..8 ) do
            for column in ( 0..8 ) do
                if puzzle[ row ][ column ].zero?
                    this_row = puzzle[ row ]
                    this_column = puzzle.map{ | row | row[ column ] }
                    this_region = [ puzzle[ row / 3 * 3 ].slice( column / 3 * 3, 3 ), puzzle[ ( row / 3 * 3 ) + 1 ].slice( column / 3 * 3, 3 ), puzzle[ ( row / 3 * 3 ) + 2 ].slice( column / 3 * 3, 3 ) ].flatten
                    puzzle[ row ][ column ] = ( 1..9 ).to_a.reject{ | digit | this_row.union( this_column, this_region ).include?( digit ) }.sample
                end
            end
        end
        puzzle
    end
    
    def generate_grille( number_of_holes )
        ( Array.new( 81 - number_of_holes, false ) + Array.new( number_of_holes, true ) ).shuffle
    end
    
    def poke( puzzle, grille )
        return puzzle.flatten.map.with_index{ | cell, index | grille[ index ] ? 0 : cell }.each_slice( 9 ).to_a
    end

end

test = Sudoku.new( 64 )

binding.pry
false