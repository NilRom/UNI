package sudoko;

public class Sudokuapp {
	private Sudoku unsolvable;
	public static void main(String[] args) {
		Sudoku unsolvable = generateUnsolvable();
		Sudoku solvable = generateSolvable();
		Sudoku test = new Sudoku();
		SudokuViewer viewer = new SudokuViewer(test);
		test.setNumber(0, 0, 5);
		test.setNumber(0, 7, 5);
		System.out.println(test.isAllValid());
	}
	private static Sudoku generateUnsolvable() {
		Sudoku unsolvable = new Sudoku();
		int[][] unsolvableMatrix = {{1,2,3,0,0,0,0,0,0}, 
									{4,5,6,0,0,0,0,0,0},
									{0,0,0,7,0,0,0,0,0},
									{0,0,0,0,0,0,0,0,0},
									{0,0,0,0,0,0,0,0,0},
									{0,0,0,0,0,0,0,0,0},
									{0,0,0,0,0,0,0,0,0},
									{0,0,0,0,0,0,0,0,0},
									{0,0,0,0,0,0,0,0,0}};
		unsolvable.setMatrix(unsolvableMatrix);
		return unsolvable;
	}
	private static Sudoku generateSolvable() {
		Sudoku solvable = new Sudoku();
		int[][] solvableMatrix = { { 0, 0, 8, 0, 0, 9, 0, 6, 2 }, { 0, 0, 0, 0, 0, 0, 0, 0, 5 },
				{ 1, 0, 2, 5, 0, 0, 0, 0, 0 }, { 0, 0, 0, 2, 1, 0, 0, 9, 0 }, { 0, 5, 0, 0, 0, 0, 6, 0, 0 },
				{ 6, 0, 0, 0, 0, 0, 0, 2, 8 }, { 4, 1, 0, 6, 0, 8, 0, 0, 0 }, { 8, 6, 0, 0, 3, 0, 1, 0, 0 },
				{ 0, 0, 0, 0, 0, 0, 4, 0, 0 } };
		solvable.setMatrix(solvableMatrix);
		return solvable;
	}
	
	

}
