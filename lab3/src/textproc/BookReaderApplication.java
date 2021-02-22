package textproc;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Scanner;
import java.util.Set;

public class BookReaderApplication {

	public static void main(String[] args) throws FileNotFoundException {
		long t0 = System.nanoTime();
		Scanner s = new Scanner(new File("nilsholg.txt"));
		Scanner scan = new Scanner(new File("undantagsord.txt"));
		Set stopwords = new HashSet<String>();
		while(scan.hasNext()) {
			String stopWord = scan.next().toLowerCase();
			stopwords.add(stopWord);
		}
		GeneralWordCounter gwc = new GeneralWordCounter(stopwords);
		s.findWithinHorizon("\uFEFF", 1);
		s.useDelimiter("(\\s|,|\\.|:|;|!|\\?|'|\\\")+"); // se handledning
		while (s.hasNext()) {
			String word = s.next().toLowerCase();

			gwc.process(word);
			
		}

		s.close();
		gwc.report();
		long t1 = System.nanoTime();
		System.out.println("tid: " + (t1 - t0) / 1000000.0 + " ms");
		BookReaderController brc = new BookReaderController(gwc);
		SortedListModel listModel = new SortedListModel(gwc.getWordList());
		
	}

}
