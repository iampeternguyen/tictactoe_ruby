require_relative 'tic_tac_toe'

class TicTacToeNode

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    if self.board.over?
      winner = self.board.winner
      return winner != evaluator if winner
    end

    if evaluator == next_mover_mark
      self.children.all? {|node| node.losing_node?(evaluator)}
    else
      self.children.any? {|node| node.losing_node?(evaluator)}
    end
  end

  def winning_node?(evaluator)
    game_ending_results = []

    if self.board.over?
      winner = self.board.winner
      return winner == evaluator if winner
    end

    self.children.each do |child|
      game_ending_results << child.winning_node?(evaluator)
    end

    if evaluator == next_mover_mark
      game_ending_results.any? {|result| result == true}
    else
      game_ending_results.all? {|result| result == true}
    end

  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    next_moves = []
    (0...3).each do |row|
      (0...3).each do |col|
        pos = [row, col]
        if self.board[pos].nil?
          new_board = self.board.dup
          new_board[pos] = self.next_mover_mark
          next_mark = ((self.next_mover_mark == :x) ? :o : :x)

          next_move = TicTacToeNode.new(new_board, next_mark, pos)
          next_moves << next_move
        end
      end
    end
    next_moves
  end

  attr_accessor :board, :next_mover_mark, :prev_move_pos


end


# node = TicTacToeNode.new(Board.new, :x)

# # node.board[[0, 0]] = :o
# # node.board[[0, 1]] = :o
# # node.board[[0, 2]] = :o
# # p node.losing_node?(:o) # => true

# node.board[[0, 0]] = :o
# node.board[[2, 2]] = :o
# node.board[[0, 2]] = :o

# p node.losing_node?(:x) # => true



