package SudokuSolver;

public interface SudokuSolver {
	/**
	 * Sets the number nbr in box r, c.
	 * 
	 * @param r   The row
	 * @param c   The column
	 * @param nbr The number to insert in box r, c
	 * @throws IllegalArgumentException if r or c is outside [0..getDimension()-1]
	 *                                  or number is outside [1..9]
	 */
	public void setNumber(int r, int c, int nbr);

	/**
	 * Returns the number in box r,c. If the box i empty 0 is returned.
	 * 
	 * @param r      The row
	 * @param c      The column
	 * @return the number in box r,c or 0 if the box is empty.
	 * @throws IllegalArgumentException if r or c is outside [0..getDimension()-1]
	 */
	public int getNumber(int r, int c);

	/**
	 * Clears the number in box r, c
	 * @param r		The row
	 * @param c		The column
	 * @throws IllegalArgymentException if r or c is outside [0..getDimension()-1]
	 */
	public void clearNumber(int r, int c);

	/**
	 * CHecks if the number in box r, c is valid according to the rules of sudoku
	 * @param r		The row
	 * @param c		The column
	 * @param nbr	The number to insert in r, c
	 * @return		true if number is valid, otherwise false
	 * @throws 		IllegalArgymentException if r or c is outside [0..getDimension()-1] or if nbr < 0 or nbr > 9
	 */
	public boolean isValid(int r, int c, int nbr);

	/**
	 * checks if numbers in all the boxes are valid
	 * @return 		true if all numbers are valid, otherwise false
	 */
	public boolean isAllValid();

	/**
	 * Tries to solve sudoku and return 
	 * @return		true if solved, otherwise false
	 */
	public boolean solve();

	/**
	 * clears all boxes in the grid
	 */
	public void clear();

	/**
	 * Returns the numbers in the grid. An empty box i represented by the value 0.
	 * 
	 * @return the numbers in the grid
	 */
	public int[][] getMatrix();

	/**
	 * Fills the grid with the numbers in nbrs.
	 * 
	 * @param nbrs the matrix with the numbers to insert
	 * @throws IllegalArgumentException if nbrs have wrong dimension or containing
	 *                                  values not in [0..9]
	 */
	public void setMatrix(int[][] nbrs);

	/**
	 * Returns the dimension of the grid
	 * 
	 * @return the dimension of the grid
	 */
	public default int getDimension() {
		return 9;
	}
}
