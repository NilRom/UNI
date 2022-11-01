package textproc;

import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;


public class MultiWordCounter implements TextProcessor{
	private Map<String, Integer> words = new TreeMap<String, Integer>();
	
	public MultiWordCounter(String[] landskap) {
		for(int i = 0; i<landskap.length; i++) {
			String word = landskap[i];
			words.put(word, 0);
		}
	}
	
	@Override
	public void process(String w) {
		for (String key : words.keySet()) { // gör något med key och m.get(key) }
			String word = key;
			if(w.equals(word)){
				int count = words.get(key);
				words.put(key, count+1);
			}
		}
	}

	@Override
	public void report() {
		for (String key : words.keySet()) { // gör något med key och m.get(key) }
			String word = key;
			int count = words.get(key);
			System.out.println(word + " " + count);
		}
	}
}
