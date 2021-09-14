package SudokuSolver;

import static org.junit.Assert.assertThrows;
import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class SudokuModelJUnit {

	SudokuModel sm;
	
	@BeforeEach
	void setUp() throws Exception {
		sm = new SudokuModel();
	}

	@AfterEach
	void tearDown() throws Exception {
		sm = null;
	}

//	@Test
//	void test() {
//		fail("Not yet implemented");
//	}
	
	//Testfall 1
	@Test
	void testEmptySolve() {
		sm.solve();
		assertTrue(sm.isAllValid(), "Tomt sudoku löstes fel");
	}
	
	//Testfall 2
	@Test
	void twoFivesSameRow() {
		sm.setNumber(0, 0, 5);
		sm.setNumber(0, 1, 5);
		assertFalse(sm.solve(), "Olösligt sudoku löstes");
		sm.clear();
		sm.setNumber(0, 0, 5);
		sm.setNumber(4, 0, 5);
		assertFalse(sm.solve(), "Olösligt sudoku löstes 2");
		sm.clear();
		sm.setNumber(0, 0, 5);
		sm.setNumber(1, 1, 5);
		assertFalse(sm.solve(), "Olösligt sudoku löstes 3");
	} 
	
	//Testfall 3
	@Test
	void testBoards() {
		sm.setNumber(0, 0, 1);
		sm.setNumber(0, 1, 2);
		sm.setNumber(0, 2, 3);
		sm.setNumber(1, 0, 4);
		sm.setNumber(1, 1, 5);
		sm.setNumber(1, 2, 6);
		sm.setNumber(2, 3, 7);
		assertFalse(sm.solve(), "Olösligt sudoku löstes testfall 3");
		sm.setNumber(2, 3, 0);
		assertTrue(sm.solve(), "Lösligt sudoku löstes inte, testfall 3");
	}
	
	//Testfall 4
	@Test
	void testClear() {
		sm.setNumber(0, 0, 5);
		sm.setNumber(0, 4, 5);
		assertFalse(sm.solve(), "Olösligt sudoku löstes testfall 4");
		sm.clear();
		assertTrue(sm.solve(), "Lösligt sudoku löstes inte");
	}
	
	//Testfall 5
	@Test
	void testSolvable() {
		int[][] matrix = {{0, 0, 8, 0, 0, 9, 0, 6, 2},
						{0, 0, 0, 0, 0, 0, 0, 0, 5},
						{1, 0, 2, 5, 0, 0, 0, 0, 0},
						{0, 0, 0, 2, 1, 0, 0, 9, 0},
						{0, 5, 0, 0, 0 ,0, 6, 0, 0},
						{6, 0, 0, 0, 0, 0, 0, 2, 8},
						{4, 1, 0, 6, 0, 8, 0, 0, 0},
						{8, 6, 0, 0, 3, 0, 1, 0, 0},
						{0, 0, 0, 0, 0, 0, 4, 0, 0}};
		sm.setMatrix(matrix);
		assertTrue(sm.solve(), "Löstes inte");
	}
	
	//Testfall 6
	@Test
	void wrongData() {
		assertThrows(IllegalArgumentException.class, ()-> sm.setNumber(3, 3, -1),"Throwade inte! -1");
		assertTrue(sm.solve(), "Hittade inte att -1 är fel");
		
		sm.setNumber(3, 3, 0);
		assertTrue(sm.solve(), "Hittade inte att 0 är fel");
		
		assertThrows(IllegalArgumentException.class, ()-> sm.setNumber(3, 3, 10),"Throwade inte! 10");
		assertTrue(sm.solve(), "Hittade inte att 10 är fel");
		
		assertThrows(IllegalArgumentException.class, ()-> sm.setNumber(3, 3, 'a'),"Throwade inte!");
		assertTrue(sm.solve(), "Hittade inte att a är fel");
	}
}
