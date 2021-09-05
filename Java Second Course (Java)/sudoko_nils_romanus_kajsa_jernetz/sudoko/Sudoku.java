package sudoko;

public class Sudoku implements SudokuSolver {
	private int[][] board;

	public Sudoku() {
		this.board = new int[9][9];

	}

	@Override
	public void setNumber(int r, int c, int nbr) {
		if (r <= board.length && r >= 0 && c <= board[0].length && c >= 0) {
			board[r][c] = nbr;
		} else {
			throw new IllegalArgumentException();
		}
	}

	@Override
	public int getNumber(int r, int c) {
		if (r <= board.length && r >= 0 && c <= board[0].length && c >= 0) {
			return board[r][c];
		} else {
			throw new IllegalArgumentException();
		}
	}

	@Override
	public void clearNumber(int r, int c) {
		if (r <= board.length && r >= 0 && c <= board[0].length && c >= 0) {
			board[r][c] = 0;
		} else {
			throw new IllegalArgumentException();
		}
	}

	@Override
	public boolean isValid(int r, int c, int nbr) {
		if (r <= board.length && r >= 0 && c <= board[0].length && c >= 0 && nbr < 10 && nbr > -1) {
			return checkRow(r, c, nbr) && checkCol(r, c, nbr) && checkSquare(r, c, nbr);
		} else {
			throw new IllegalArgumentException();
		}
	}

	private boolean checkCol(int r, int c, int nbr) {
		for (int i = 0; i < board.length; i++) {
			if (i == r) {
				continue;
			}
			if (board[i][c] == nbr) {
				return false;
			}
		}
		return true;
	}

	private boolean checkRow(int r, int c, int nbr) {
		for (int i = 0; i < board.length; i++) {
			if (i == c) {
				continue;
			}
			if (board[r][i] == nbr) {
				return false;
			}
		}
		return true;
	}

	private boolean checkSquare(int r, int c, int nbr) {
		int row = r - r % 3;
		int col = c - c % 3;
		for (int i = row; i < row + 3; i++) {
			for (int j = col; j < col + 3; j++) {
				if (i == r && j == c) {
					continue;
				}
				if (board[i][j] == nbr) {
					return false;
				}
			}
		}
		return true;

	}

	@Override
	public boolean isAllValid() {
		for (int i = 0; i < board.length; i++) {
			for (int j = 0; j < board[0].length; j++) {
				if (!isValid(i, j, getNumber(i, j))) {
					return false;
				}
			}
		}
		return true;

	}

	private boolean solve(int r, int c) {
		if (c == 9) {
			c = 0;
			r++;
			if (r == 9) {
				return true;
			}
		}
		for (int num = 1; num < 10; num++) {
			if (getNumber(r, c) == 0) {
				if (isValid(r, c, num)) {
					setNumber(r, c, num);
					if (solve(r, c + 1)) {
						return true;
					} else {

						setNumber(r, c, 0);
					}
				}
			} else {
				if (isValid(r, c, getNumber(r, c)))
					return solve(r, c + 1);
			}
		}
		return false;
	}

	@Override
	public void clear() {
		for (int i = 0; i < board.length; i++) {
			for (int j = 0; j < board[0].length; j++) {
				board[i][j] = 0;
			}
		}

	}

	@Override
	public int[][] getMatrix() {
		int[][] temp = new int[this.getDimension()][this.getDimension()];
		for(int i = 0; i<this.getDimension();i++) {
			for(int j = 0; j<this.getDimension();j++) {
				temp[i][j] = board[i][j];
			}
		}
		return temp;
	}

	@Override
	public void setMatrix(int[][] nbrs) {
		if (nbrs.length != 9 || nbrs[0].length != 9) {
			throw new IllegalArgumentException();
		} else {
			int nbr = -1;
			for (int i = 0; i < nbrs.length; i++) {
				for (int j = 0; j < nbrs[0].length; j++) {
					nbr = nbrs[i][j];
					if (nbr < 0 || nbr > 9) {
						throw new IllegalArgumentException();
					}
				}
			}
			this.board = nbrs;
		}
	}

	// Only for testing
	// private String toString() {
	// StringBuilder sb = new StringBuilder();
	// for (int i = 0; i < board.length; i++) {
	// StringBuilder sb2 = new StringBuilder();
	// for (int j = 0; j < board.length; j++) {
	// sb2.append(" " + board[i][j]);
	// }
	// sb.append(sb2.toString() + "\n");
	// }
	// return sb.toString();
	// }

	@Override
	public boolean solve() {
		return solve(0, 0);
	}

	public int getDimension() {
		return board.length;
	}
}
