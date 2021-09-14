package fractal;

import koch.Koch;
import koch.PrepExercises;
import mountain.*;

public class FractalApplication {
	public static void main(String[] args) {
		Fractal[] fractals = new Fractal[2];
		fractals[1] = new Koch(300);
		Point p1 = new Point(100,350);
		Point p2 = new Point(500,100);
		Point p3 = new Point(700,400);
		double dev = 50;
		fractals[0] = new Mountain(p1, p2, p3, dev);
		//fractals[2] = new PrepExercises(300);
	    new FractalView(fractals, "Fraktaler", 1000, 1000);
	}

}