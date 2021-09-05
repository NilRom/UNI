package mountain;

import java.util.HashMap;
import java.util.Map;

import fractal.*;

public class Mountain extends Fractal {
	private Point p1;
	private Point p2;
	private Point p3;
	private double dev;
	private Map<Side, Point> map = new HashMap<Side, Point>();

	public Mountain(Point p1, Point p2, Point p3, double dev) {
		super();
		this.p1 = p1;
		this.p2 = p2;
		this.p3 = p3;
		this.dev = dev;
	}

	public String getTitle() {
		return "Mountain";
	}

	public void draw(TurtleGraphics turtle) {
		fractalLine(turtle, order, p1, p2, p3, dev);
	}

	private void fractalLine(TurtleGraphics turtle, int order, Point p1, Point p2, Point p3, double dev) {
		if (order == 0) {
			turtle.moveTo(p1.getX(), p1.getY());
			turtle.penDown();
			turtle.forwardTo(p2.getX(), p2.getY());
			turtle.forwardTo(p3.getX(), p3.getY());
			turtle.forwardTo(p1.getX(), p1.getY());
			turtle.penUp();
		} else {
			dev /= 2;
			double offset1 = RandomUtilities.randFunc(dev);
			double offset2 = RandomUtilities.randFunc(dev);
			double offset3 = RandomUtilities.randFunc(dev);

			Point mLeft = getMid(p1,p2,offset1);
			Point mRight = getMid(p2,p3,offset2);
			Point bMid = getMid(p3,p1,offset3);
			fractalLine(turtle, order - 1, p1, mLeft, bMid, dev);
			fractalLine(turtle, order - 1, mLeft, p2, mRight, dev);
			fractalLine(turtle, order - 1, mLeft, mRight, bMid, dev);
			fractalLine(turtle, order - 1, bMid, mRight, p3, dev);
			

		}
	}

	private Point getMid(Point p1, Point p2, double offset) {
		Point midPoint = null;
		Side temp = new Side(p1, p2);
		if (map.containsKey(temp)) {
			midPoint = map.get(temp);
			map.remove(temp);
		} else {
			midPoint = new Point((p1.getX() + p2.getX()) / 2, (p1.getY() + p2.getY()) / 2 + (int)offset);
			map.put(new Side(p1, p2), midPoint);
		}
		return midPoint;

	}

}
