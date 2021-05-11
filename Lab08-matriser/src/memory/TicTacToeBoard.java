package memory;

public class TicTacToeBoard {
	private int size;
	private char[][] board;
	
	public void ticTacToeBoard(int size) {
		this.size = size;
		setBoard();
		
	}
	private void setBoard() {
		for(int i = 0; i<size; i++) {
			for(int k = 0; k<size; k++) {
				board[i][k] = ' ';
			}
		}
	}
	public int getNbrOfRows() {
		return size;
	}
	public int getNbrofCols() {
		return size;
	}
	public char readPosition(int row, int col) {
		return board[row][col];
	}
	public void markPosition(char mark, int row, int col) {
		board[row][col] = mark;
	}
	public char getWinner() {
		for(int i = 0; i<size; i++) {
			
		}
	}

}
