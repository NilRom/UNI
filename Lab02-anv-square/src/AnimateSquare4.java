import se.lth.cs.pt.window.SimpleWindow;
import se.lth.cs.pt.square.Square;

public class AnimateSquare4 {
	public static void main(String[] args) {
		SimpleWindow w = new SimpleWindow(600, 600, "DrawSquare");
		Square sq = new Square(0, 0, 10);
		int oldX = 0;
		int oldY = 0;
		int x = 0;
		int y = 0;
		while (true) {
			w.waitForMouseClick();
			for (int i = 1; i <= 10; i++) {
				sq.erase(w);
				x = w.getMouseX() / 10;
				y = w.getMouseY() / 10;
				sq.move((x - oldX), (y - oldY));
				sq.draw(w);
				SimpleWindow.delay(20);

			}
			oldX = x;
			oldY = y;

		}
	}
}
