package textproc;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Scanner;
import java.util.Set;

public class Holgersson {

	public static final String[] REGIONS = { "blekinge", "bohuslän", "dalarna", "dalsland", "gotland", "gästrikland",
			"halland", "hälsingland", "härjedalen", "jämtland", "lappland", "medelpad", "närke", "skåne", "småland",
			"södermanland", "uppland", "värmland", "västerbotten", "västergötland", "västmanland", "ångermanland",
			"öland", "östergötland" };

	public static void main(String[] args) throws FileNotFoundException {
		long t0 = System.nanoTime();
		
		
		TextProcessor p = new SingleWordCounter("nils");
		TextProcessor p2 = new SingleWordCounter("norge");
		ArrayList<TextProcessor> processorList = new ArrayList<TextProcessor>();
		MultiWordCounter wordCounter = new MultiWordCounter(REGIONS);
		
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
			wordCounter.process(word);
			p.process(word);
			p2.process(word);
			gwc.process(word);
			
		}

		s.close();
		processorList.add(p);
		processorList.add(p2);

		for(TextProcessor pi : processorList) {
			pi.report();
		}
		wordCounter.report();
		gwc.report();
		long t1 = System.nanoTime();
		System.out.println("tid: " + (t1 - t0) / 1000000.0 + " ms");
	}
}

//Tree: 1482.515712 ms
//Hash 1193.162087


