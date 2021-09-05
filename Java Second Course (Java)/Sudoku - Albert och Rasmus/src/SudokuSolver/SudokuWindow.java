package SudokuSolver;

import java.awt.*;


import javax.swing.*;

public class SudokuWindow {
	private JPButton selectedBox;
	private JPButton[][] butMatrix;

	public SudokuWindow(SudokuSolver m) {
		SwingUtilities.invokeLater(() -> createWindow(m));
	}


	/**
	 * Creates the GUI for the sudoku
	 * @param m		The model containing data of the sudoku board
	 */
	public void createWindow(SudokuSolver m) {
		butMatrix = new JPButton[9][9];

		//Creates the frame and adds a JPanel
		JFrame frame = new JFrame();
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setSize(new Dimension(600, 600));
		frame.setResizable(false);
		JPanel mainPanel = new JPanel();
		// mainPanel.setPreferredSize(new Dimension(600, 600));
		frame.add(mainPanel, BorderLayout.CENTER);
		
		//Adds 9 JPanels to the main JPanel
		//Adds 9 JPButtons to each subpanel
		for (int i = 0; i < 9; i++) {
			JPanel panel = new JPanel();
			panel.setBorder(BorderFactory.createLineBorder(Color.black, 3));
			mainPanel.add(panel);
			
			//Creates 9 buttons per JPanel and adds adds actionlisteners
			for (int j = 0; j < 9; j++) {
				JPButton minButton = new JPButton(i / 3 * 3 + j / 3, i % 3 * 3 + j % 3);
				butMatrix[minButton.getRow()][minButton.getCol()] = minButton;
				minButton.setBorder(BorderFactory.createLineBorder(Color.black, 1));
				minButton.setBackground(Color.white);
				minButton.setFont(new Font("Comic Sans ms", Font.PLAIN, 60));
				
				//Changes color upon click
				minButton.addActionListener(event -> {
					if (selectedBox != null)
						selectedBox.setBackground(Color.white);
					selectedBox = minButton;
					selectedBox.setBackground(new Color(184, 207, 229));

				});
				panel.add(minButton);
				panel.setLayout(new GridLayout(3, 3));

			}
		}

		mainPanel.setLayout(new GridLayout(3, 3));
		
		JPanel menu = new JPanel();

		JButton clearButton = new JButton("Clear");
		clearButton.addActionListener(event -> {
			for (int i = 0; i < 9; i++) {
				for (int j = 0; j < 9; j++) {
					butMatrix[i][j].setText("");
				}
			}
			m.clear();
		});

		//Reads all numbers and updates the model, then solves and updates GUI
		JButton solveButton = new JButton("Solve");
		solveButton.addActionListener(event -> {
			for(int i=0;i <butMatrix.length;i++) {
				for(int j = 0;j<butMatrix[i].length;j++) {
					if(butMatrix[i][j].getText() == "")
						m.setNumber(i,j,0);
					else
						m.setNumber(i,j,Integer.parseInt(butMatrix[i][j].getText()));
				}
			}
			
			if (m.solve()) {
				int[][] grid = m.getMatrix();

				for (int i = 0; i < 9; i++) {
					for (int j = 0; j < 9; j++) {
						butMatrix[i][j].setText(((Integer) grid[i][j]).toString());

					}
				}
			} else {
				JOptionPane.showMessageDialog(frame, "Sudoku not solvable");
			}
		});
		
		Integer[] nbrs = { 1, 2, 3, 4, 5, 6, 7, 8, 9 };
		JComboBox<Integer> nbrSelect = new JComboBox<>(nbrs);
		nbrSelect.addActionListener(event -> {
			if (selectedBox != null) {
					m.setNumber(selectedBox.getRow(), selectedBox.getCol(), (Integer) nbrSelect.getSelectedItem());
					selectedBox.setText(nbrSelect.getSelectedItem().toString());
			} else {
				JOptionPane.showMessageDialog(frame, "No square selected");
			}
		});

		menu.add(clearButton);
		menu.add(solveButton);
		menu.add(nbrSelect);

		frame.add(menu, BorderLayout.SOUTH);
		frame.setVisible(true);

	}
}