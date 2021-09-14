package sudoko;

public class Sudokuapp {
	public static void main(String[] args) {
		Sudoku sudoku = new Sudoku();
		SudokuViewer viewer = new SudokuViewer(sudoku);
	}
}
