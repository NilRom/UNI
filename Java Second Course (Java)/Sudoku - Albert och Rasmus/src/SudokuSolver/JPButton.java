package SudokuSolver;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JOptionPane;

@SuppressWarnings("serial")
public class JPButton extends JButton implements KeyListener {
	private int r;
	private int c;

	/**
	 * Constructor for the buttons in SudokuWindow
	 * @param r		the row (index-wise) of the button
	 * @param c		the column (index-wise) of the button
	 */
	public JPButton(int r, int c) {
		super();
		this.r = r;
		this.c = c;
		addKeyListener(this);
	}
		
	/**
	 * @return	the row of the button
	 */
	public int getRow() {
		return r;
	}

	
	/**
	 * @return	the column of the button
	 */
	public int getCol() {
		return c;
	}

	@Override
	public void keyTyped(KeyEvent e) {
		if (e.getKeyChar() == '0') {
			this.setText("");
			
			return;
		}
		if (e.getKeyChar() <= 57 && e.getKeyChar() >= 47) {
			this.setText(Character.toString(e.getKeyChar()));
		} else {
			JOptionPane.showMessageDialog(new JFrame(), "please enter a number between 0 and 9");
		}

		/*
		 * switch (e.getKeyChar()) { case '0': this.setText("");
		 * System.out.println("key typed: "+e.getKeyCode()); break; case '1':
		 * this.setText("1"); System.out.println("key typed: "+e.getKeyCode()); break;
		 * case '2': this.setText("2");
		 * System.out.println("key typed: "+e.getKeyCode()); break; case '3':
		 * this.setText("3"); System.out.println("key typed: "+e.getKeyCode()); break;
		 * case '4': this.setText("4");
		 * System.out.println("key typed: "+e.getKeyCode()); break; case '5':
		 * this.setText("5"); System.out.println("key typed: "+e.getKeyCode()); break;
		 * case '6': this.setText("6");
		 * System.out.println("key typed: "+e.getKeyCode()); break; case '7':
		 * this.setText("7"); System.out.println("key typed: "+e.getKeyCode()); break;
		 * case '8': this.setText("8");
		 * System.out.println("key typed: "+e.getKeyCode()); break; case '9':
		 * this.setText("9"); System.out.println("key typed: "+e.getKeyCode()); break;
		 * default: JOptionPane.showMessageDialog(new JFrame(),
		 * "please enter a number between 0 and 9"); break; }
		 */
	}

	@Override
	public void keyPressed(KeyEvent e) {
		// TODO Auto-generated method stub

	}

	@Override
	public void keyReleased(KeyEvent e) {
		// TODO Auto-generated method stub

	}
}
