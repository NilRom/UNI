import java.awt.Color;

import se.lth.cs.pt.window.SimpleWindow;

public class Graphics{
	private int width;
	private int blockSize;
	private int height;
	private SimpleWindow w = new SimpleWindow(300,500,"Digging");
	
	public Graphics(int w, int h, int bs){
		this.blockSize = bs;
		this.width = w;
		this.height = h;
		this.w = new SimpleWindow(width * blockSize,
				height * blockSize,
				"Digging");
	}
	
	public void square() {
	w.moveTo(10, 10);
    w.lineTo(10, 20);
    w.lineTo(20, 20);
    w.lineTo(20, 10);
    w.lineTo(10, 10);
	}
	public void block(int x, int y,java.awt.Color color) {
		w.setLineColor(color);
		int left = x * blockSize;
		int right = left + blockSize -1;
		int top = y * blockSize;
		int bottom = top + blockSize -1;
		for(int row = top; row<= bottom; row++){
			w.setLineColor(color);
			w.moveTo(left, row);
			w.lineTo(right, row);
		}
	}
	public int getWidth() {
		return width;
	}
	public int getHeight() {
		return height;
	}
	public void rectangle(int x,int y,int width,int height,Color c){
		for (int yy = y; yy < y + height; yy++){
	        for(int xx = x; xx < x + width; xx++){
	            block(xx, yy, c);
	        }
	}
	}
	public char waitForKey() {
		return w.waitForKey();
	}
}

