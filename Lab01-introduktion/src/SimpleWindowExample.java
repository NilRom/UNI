import se.lth.cs.pt.window.SimpleWindow;
        public class SimpleWindowExample {
            public static void main(String[] args) {
                SimpleWindow w = new SimpleWindow(500, 500, "Drawing Window");
                w.moveTo(100, 100);
                w.lineTo(150, 100);
                w.moveTo(200, 500);
                w.lineTo(80, 120);
} }