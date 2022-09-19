package koch;

import fractal.*;
public class PrepExercises extends Fractal {
	private int length;
	private int counter = 0;

	/**
	 * Creates an object that handles Koch's fractal.
	 * 
	 * @param length the length of the triangle side
	 */
	public PrepExercises(int length) {
		super();
		this.length = length;
	}

	/**
	 * Returns the title.
	 * 
	 * @return the title
	 */
	@Override
	public String getTitle() {
		return "Preperatory exercises";
	}

	/**
	 * Draws the fractal.
	 * 
	 * @param turtle the turtle graphic object
	 */
	@Override
	public void draw(TurtleGraphics turtle) {
		turtle.moveTo(turtle.getWidth() / 2.0 - length / 2.0, turtle.getHeight() / 2.0 + Math.sqrt(3.0) * length / 4.0);
		fractalLine(turtle, 4, 810,0);
		System.out.println(this.counter);
	}

	/*
	 * Reursive method: Draws a recursive line of the triangle.
	 */
	private void fractalLine(TurtleGraphics turtle, int order, double length, int alpha) {
		
		if (order == 0) {
			turtle.penDown();
			turtle.setDirection(alpha);
			turtle.forward(length);
			this.counter++;
		} else {
			fractalLine(turtle, order - 1, length / 3, alpha);
			fractalLine(turtle, order - 1, length / 3, alpha - 60);
			fractalLine(turtle, order - 1, length / 3, alpha + 60);
			fractalLine(turtle, order - 1, length / 3, alpha);
		}
		System.out.println(counter);
	}

}
