package sudoko;

import static org.junit.Assert.assertTrue;
import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class SudokuTest {
	private Sudoku empty;
	private Sudoku solvable;
	private Sudoku solutionSolvable;
	private Sudoku unsolvable;

	@BeforeEach
	void setUp() throws Exception {
		empty = new Sudoku();
		solvable = new Sudoku();
		generateSolvable();
		unsolvable = new Sudoku();
		generateUnsolvable();

	}

	@AfterEach
	void tearDown() throws Exception {
		empty = null;
		solvable = null;
		unsolvable = null;

	}

	@Test
	void testGetAndSetNumber() {
		empty.setNumber(0, 0, 1);
		solvable.setNumber(0, 0, 1);
		unsolvable.setNumber(0, 0, 1);
		assertTrue(empty.getNumber(0, 0) == 1);
		assertTrue(solvable.getNumber(0, 0) == 1);
		assertTrue(unsolvable.getNumber(0, 0) == 1);
		assertThrows(IllegalArgumentException.class, () -> empty.setNumber(10, 10, 1));
	}

	@Test
	void testIsvalid() {
		empty.setNumber(0, 0, 1);
		solvable.setNumber(0, 0, 1);
		unsolvable.setNumber(0, 0, 1);
		assertFalse(empty.isValid(0, 1, 1));
		assertFalse(solvable.isValid(0, 1, 1));
		assertFalse(unsolvable.isValid(0, 1, 1));
		assertFalse(empty.isValid(1, 0, 1));
		assertFalse(solvable.isValid(1, 0, 1));
		assertFalse(unsolvable.isValid(1, 0, 1));
		assertFalse(empty.isValid(1, 1, 1));
		assertFalse(solvable.isValid(1, 1, 1));
		assertFalse(unsolvable.isValid(1, 1, 1));
		assertThrows(IllegalArgumentException.class, () -> empty.isValid(10, 10, 1));
		assertThrows(IllegalArgumentException.class, () -> empty.isValid(0, 0, 25));
	}

	@Test
	void testSolveAndisAllValid() {
		empty.solve();
		unsolvable.solve();
		solvable.solve();
		assertTrue(empty.isAllValid());
		assertTrue(solvable.isAllValid());
		assertFalse(unsolvable.isAllValid());

	}

	@Test
	void testClear() {
		empty.solve();
		empty.clear();
		for (int i = 0; i < empty.getDimension(); i++) {
			for (int j = 0; j < empty.getDimension(); j++) {
				assertTrue(empty.getNumber(i, j) == 0);
			}
		}
	}

	@Test
	void testGetDimension() {
		assertTrue(empty.getDimension() == 9 && unsolvable.getDimension() == 9 && solvable.getDimension() == 9);
	}
	@Test
	void testSetandGetMatrix() {
		int[][] goodMatrix = { { 0, 0, 8, 0, 0, 9, 0, 6, 2 }, { 0, 0, 0, 0, 0, 0, 0, 0, 5 },
				{ 1, 0, 2, 5, 0, 0, 0, 0, 0 }, { 0, 0, 0, 2, 1, 0, 0, 9, 0 }, { 0, 5, 0, 0, 0, 0, 6, 0, 0 },
				{ 6, 0, 0, 0, 0, 0, 0, 2, 8 }, { 4, 1, 0, 6, 0, 8, 0, 0, 0 }, { 8, 6, 0, 0, 3, 0, 1, 0, 0 },
				{ 0, 0, 0, 0, 0, 0, 4, 0, 0 } };
		int[][] badMatrix = { { 0, 0, 8, 0, 0, 9, 0, 6, 2 }, { 0, 0, 0, 0, 0, 0, 0, 0, 5 },
				{ 1, 0, 2, 5, 0, 0, 0, 0, 0 }, { 0, 0, 0, 2, 1, 0, 0, 9, 0 }, { 0, 5, 0, 0, 0, 0, 6, 0, 0 },
				{ 6, 0, 0, 0, 0, 0, 0, 2, 8 }, { 4, 1, 0, 6, 0, 8, 0, 0, 0 }, { 8, 6, 0, 0, 3, 0, 1, 0, 0 },
				{ 0, 0, 0, 0, 0, 0, 4, 0, 0 },
				{ 0, 0, 0, 0, 0, 0, 4, 0, 0 } };
		empty.setMatrix(goodMatrix);
		for(int i=0;i<empty.getDimension();i++) {
			for(int j=0;j<empty.getDimension();j++) {
				assertTrue(empty.getNumber(i, j)==goodMatrix[i][j]);
			}
		}
		assertThrows(IllegalArgumentException.class, () -> empty.setMatrix(badMatrix));	
	}
	
	@Test
	void testClearNumber() {
		solvable.clearNumber(0, 2);
		assertTrue(solvable.getNumber(0, 2)==0);
		assertThrows(IllegalArgumentException.class, () -> solvable.clearNumber(100, 100));
	}
	

	private void generateSolvable() {
		int[][] solvableMatrix = { { 0, 0, 8, 0, 0, 9, 0, 6, 2 }, { 0, 0, 0, 0, 0, 0, 0, 0, 5 },
				{ 1, 0, 2, 5, 0, 0, 0, 0, 0 }, { 0, 0, 0, 2, 1, 0, 0, 9, 0 }, { 0, 5, 0, 0, 0, 0, 6, 0, 0 },
				{ 6, 0, 0, 0, 0, 0, 0, 2, 8 }, { 4, 1, 0, 6, 0, 8, 0, 0, 0 }, { 8, 6, 0, 0, 3, 0, 1, 0, 0 },
				{ 0, 0, 0, 0, 0, 0, 4, 0, 0 } };
		solvable.setMatrix(solvableMatrix);
	}

	private void generateUnsolvable() {
		int[][] unsolvableMatrix = { { 1, 2, 3, 0, 0, 0, 0, 0, 0 }, { 4, 5, 6, 0, 0, 0, 0, 0, 0 },
				{ 0, 0, 0, 7, 0, 0, 0, 0, 0 }, { 0, 0, 0, 0, 0, 0, 0, 0, 0 }, { 0, 0, 0, 0, 0, 0, 0, 0, 0 },
				{ 0, 0, 0, 0, 0, 0, 0, 0, 0 }, { 0, 0, 0, 0, 0, 0, 0, 0, 0 }, { 0, 0, 0, 0, 0, 0, 0, 0, 0 },
				{ 0, 0, 0, 0, 0, 0, 0, 0, 0 } };
		unsolvable.setMatrix(unsolvableMatrix);
	}

}
