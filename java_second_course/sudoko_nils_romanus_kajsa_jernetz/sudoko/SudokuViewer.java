package sudoko;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Container;
import java.awt.Font;
import java.awt.GridLayout;
import java.util.ArrayList;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.SwingUtilities;

public class SudokuViewer {
	private JTextField[][] grid;
	private JPanel panel;
	private Sudoku sudoku;
	private static Font FONT = new Font("SansSerif", Font.PLAIN, 20);
	private static ArrayList<Integer> ALLOWEDINPUT = new ArrayList<Integer>();
	private static int VIEWDIMENSION = 400;

	public SudokuViewer(Sudoku sudoku) {
		for (int i = 1; i < 10; i++) {
			ALLOWEDINPUT.add(i);
		}
		this.grid = new JTextField[sudoku.getDimension()][sudoku.getDimension()];
		this.panel = new JPanel(new GridLayout(9, 9));
		this.sudoku = sudoku;
		SwingUtilities.invokeLater(() -> createWindow("Sudoku", VIEWDIMENSION, VIEWDIMENSION));
	}

	private void createWindow(String title, int width, int height) {
		JFrame frame = new JFrame(title);
		frame.setResizable(false);
		createGrid();

		JButton solve = new JButton("Solve");
		solve.addActionListener(e -> {
			if (!updateSudoku()) {
				JOptionPane.showMessageDialog(null,
						"Please remove invalid inputs, please make sure all inputs are in the range [1,9]");
			} else {
				sudoku.solve();
				updateGrid();
				if (sudoku.isAllValid()) {
					JOptionPane.showMessageDialog(null, "Solved Sudoku");
				} else {
					JOptionPane.showMessageDialog(null, "Soduku is unsolvable");
				}
			}

		});

		JButton clear = new JButton("Clear");
		clear.addActionListener(e -> {
			updateSudoku();
			sudoku.clear();
			updateGrid();
		});

		JButton example = new JButton("Test case 1 (unsolvable)");
		example.addActionListener(e -> {
			updateSudoku();
			generateUnsolvable();
			updateGrid();
		});

		JButton example2 = new JButton("Test case 2 (solvable)");
		example2.addActionListener(e -> {
			updateSudoku();
			generateSolvable();
			updateGrid();
		});

		frame.add(example2, BorderLayout.CENTER);
		frame.add(example, BorderLayout.NORTH);
		frame.add(clear, BorderLayout.WEST);
		frame.add(solve, BorderLayout.EAST);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		Container pane = frame.getContentPane();
		pane.add(panel, BorderLayout.SOUTH);
		frame.setSize(width, height);
		frame.setVisible(true);

	}

	private boolean orangeConditions(int i, int j) {
		if (i < 3) {
			return j < 3 || j > 5;
		} else if (5 < i) {
			return 5 < j || j < 3;
		} else if (2 < i && i < 6) {
			return 2 < j && j < 6;
		}

		else {
			return false;
		}

	}

	private void createGrid() {
		for (int i = 0; i < sudoku.getDimension(); i++) {
			for (int j = 0; j < sudoku.getDimension(); j++) {
				JTextField textfield = new JTextField();
				textfield.setLocation(5, 5);
				textfield.setSize(100, 20);
				textfield.setFont(FONT);
				grid[i][j] = textfield;
				if (sudoku.getNumber(i, j) != 0) {
					grid[i][j].setText(String.valueOf(sudoku.getNumber(i, j)));
				}
				if (orangeConditions(i, j)) {
					grid[i][j].setBackground(Color.CYAN);
				}
				grid[i][j].setHorizontalAlignment(JTextField.CENTER);

				panel.add(grid[i][j]);
			}
		}
	}

	private boolean updateGrid() {
		for (int i = 0; i < sudoku.getDimension(); i++) {
			for (int j = 0; j < sudoku.getDimension(); j++) {
				if (sudoku.getNumber(i, j) != 0) {
					try {
						grid[i][j].setText(String.valueOf(sudoku.getNumber(i, j)));
					} catch (NumberFormatException e) {
						return false;
					}
				} else {
					grid[i][j].setText("");
				}
			}
		}
		return true;
	}

	private boolean updateSudoku() {
		for (int i = 0; i < grid.length; i++) {
			for (int j = 0; j < grid.length; j++) {
				if (!grid[i][j].getText().equals("")) {
					try {
						sudoku.setNumber(i, j, Integer.parseInt(grid[i][j].getText()));
					} catch (NumberFormatException e) {
						return false;
					}
					if (!ALLOWEDINPUT.contains(Integer.parseInt(grid[i][j].getText()))) {
						return false;
					}

				} else {
					sudoku.setNumber(i, j, 0);
				}

			}
		}
		return true;
	}

	private void generateUnsolvable() {
		int[][] unsolvableMatrix = { { 1, 2, 3, 0, 0, 0, 0, 0, 0 }, { 4, 5, 6, 0, 0, 0, 0, 0, 0 },
				{ 0, 0, 0, 7, 0, 0, 0, 0, 0 }, { 0, 0, 0, 0, 0, 0, 0, 0, 0 }, { 0, 0, 0, 0, 0, 0, 0, 0, 0 },
				{ 0, 0, 0, 0, 0, 0, 0, 0, 0 }, { 0, 0, 0, 0, 0, 0, 0, 0, 0 }, { 0, 0, 0, 0, 0, 0, 0, 0, 0 },
				{ 0, 0, 0, 0, 0, 0, 0, 0, 0 } };

		sudoku.setMatrix(unsolvableMatrix);
	}

	private void generateSolvable() {
		int[][] solvableMatrix = { { 0, 0, 8, 0, 0, 9, 0, 6, 2 }, { 0, 0, 0, 0, 0, 0, 0, 0, 5 },
				{ 1, 0, 2, 5, 0, 0, 0, 0, 0 }, { 0, 0, 0, 2, 1, 0, 0, 9, 0 }, { 0, 5, 0, 0, 0, 0, 6, 0, 0 },
				{ 6, 0, 0, 0, 0, 0, 0, 2, 8 }, { 4, 1, 0, 6, 0, 8, 0, 0, 0 }, { 8, 6, 0, 0, 3, 0, 1, 0, 0 },
				{ 0, 0, 0, 0, 0, 0, 4, 0, 0 } };
		sudoku.setMatrix(solvableMatrix);
	}

}