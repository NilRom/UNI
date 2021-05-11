import java.awt.Color;

import se.lth.cs.pt.window.SimpleWindow;

public class Turtle {
private SimpleWindow w;
private double x; //xstart
private double y;	//ystart
private double a;	//startvinkel
private boolean pen;	//start penna uppe

	/** Skapar en sköldpadda som ritar i ritfönstret w. Från början 
	    befinner sig sköldpaddan i punkten x, y med pennan lyft och 
	    huvudet pekande rakt uppåt i fönstret (i negativ y-riktning). */
	public Turtle(SimpleWindow w, int x, int y) {
		this.x = x;
		this.y = y;
		this.w = w;
		this.a = -180;
		this.pen = false;
	}

	/** Sänker pennan. */
	public void penDown() {
		pen = true;
	}
	
	/** Lyfter pennan. */
	public void penUp() {
		pen = false;
	}
	
	/** Går rakt framåt n pixlar i den riktning huvudet pekar. */
	public void forward(int n) {
		w.setLineWidth(2);
		w.setLineColor(new Color(0,100,0));
		w.moveTo((int)Math.round(x), (int)Math.round(y));  
		double x1 = x + n*Math.cos(Math.toRadians(a));
		double y1 = y - n*Math.sin(Math.toRadians(a));
		if (pen) {
			w.lineTo((int)Math.round(x1), (int)Math.round(y1));
			
		}
		x = x1;
		y = y1;	}


	/** Vrider beta grader åt vänster runt pennan. */
	public void left(int beta) {
		a = a+beta;
	}

	/** Går till punkten newX, newY utan att rita. Pennans läge (sänkt
	    eller lyft) och huvudets riktning påverkas inte. */
	public void jumpTo(int newX, int newY) {
		x = newX;
		y = newY;
	}

	/** Återställer huvudriktningen till den ursprungliga. */
	public void turnNorth() {
		a = 90;
	}

	/** Tar reda på x-koordinaten för sköldpaddans aktuella position. */
	public int getX() {
		return (int)Math.round(x);
	}

 	/** Tar reda på y-koordinaten för sköldpaddans aktuella position. */
	public int getY() {
		return (int)Math.round(y);
	}
  
	/** Tar reda på sköldpaddans riktning, i grader från den positiva X-axeln. */
 	public int getDirection() {
 		return (int) Math.round(a);
	}
}
