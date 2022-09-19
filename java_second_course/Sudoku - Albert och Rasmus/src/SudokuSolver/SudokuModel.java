package SudokuSolver;

public class SudokuModel implements SudokuSolver {
	private int[][] grid;

	/**
	 * Constructor for SudokuModel
	 */
	public SudokuModel() {
		grid = new int[9][9];
	}

	@Override
	public void setNumber(int r, int c, int nbr) {
		if (nbr < 0 || nbr > 9 || r < 0 || r > 9 || c < 0 || c > 9)
			throw new IllegalArgumentException();
		grid[r][c] = nbr;
	}

	@Override
	public int getNumber(int r, int c) {
		if (r < 0 || r > 9 || c < 0 || c > 9)
			throw new IllegalArgumentException();
		return grid[r][c];
	}

	@Override
	public void clearNumber(int r, int c) {
		if (r < 0 || r > 9 || c < 0 || c > 9)
			throw new IllegalArgumentException();
		grid[r][c] = 0;
	}

	@Override
	public boolean isValid(int r, int c, int nbr) {
		if (nbr < 0 || nbr > 9 || r < 0 || r > 8 || c < 0 || c > 8)
			throw new IllegalArgumentException();

		for (int i = 0; i < 9; i++) {
			if (grid[r][i] == nbr && c != i)
				return false;
		}

		for (int i = 0; i < 9; i++) {
			if (grid[i][c] == nbr && r != i)
				return false;
		}
		int boxStartC = (c / 3) * 3;
		int boxStartR = (r / 3) * 3;
		for (int i = boxStartR; i < boxStartR + 3; i++) {
			for (int j = boxStartC; j < boxStartC + 3; j++) {
				if (grid[i][j] == nbr && i != r && j != c)
					return false;
			}
		}

		return true;
	}

	@Override
	public boolean isAllValid() {
		for (int i = 0; i < 9; i++) {
			for (int j = 0; j < 9; j++) {
				if (!isValid(i, j, grid[i][j]))
					return false;
			}
		} 
		return true;
	}

	@Override
	public boolean solve() {
		return solveHelp(0, 0);
	}

	private boolean solveHelp(int r, int c) {
		if (r == 8 && c == 9) {
			return true;
		}
		if (c == 9) {
			r++;
			c = 0;
		}

		if (grid[r][c] != 0) {
			if (!isValid(r, c, grid[r][c]))
				return false;
		}

		if (grid[r][c] != 0) {
			return solveHelp(r, c + 1);
		}

		for (int i = 1; i < 10; i++) {
			if (isValid(r, c, i)) {
				setNumber(r, c, i);

				if (solveHelp(r, c + 1))
					return true;

			}
		}
		setNumber(r, c, 0);
		return false;
	}

	@Override
	public void clear() {
		grid = null;
		grid = new int[9][9];

	}

	@Override
	public int[][] getMatrix() {
		return grid.clone();
	}

	@Override
	public void setMatrix(int[][] nbrs) {
		if (nbrs.length != getDimension())
			throw new IllegalArgumentException();
		for (int i = 0; i < nbrs.length; i++) {
			if (nbrs[i].length != getDimension())
				throw new IllegalArgumentException();
		}

		for (int r = 0; r < 9; r++) {
			for (int c = 0; c < 9; c++) {
				this.setNumber(r, c, nbrs[r][c]);
			}
		}
		grid = nbrs;
	}
}
