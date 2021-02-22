package textproc;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.TreeMap;



public class GeneralWordCounter implements TextProcessor{
	private Set<String> stopWords;
	private Map<String, Integer> words = new TreeMap<String, Integer>();
	
	public GeneralWordCounter(Set<String> stopWords) {
		this.stopWords = stopWords;
		
	}
	
	
	public void process (String w) {
		if(!stopWords.contains(w)) {
			if(words.containsKey(w)) {
				int count = words.get(w);
				words.put(w, count+1);	
				}

			else {
				words.put(w, 1);
			}
		}
	}
	
		
		
	

	@Override
	public void report() {
		//for (String key : words.keySet()) { 
		//	String word = key;
		//	int count = words.get(key);
		//	if(count>199) {
		//		System.out.println(word + " " + count);
		//	}
		//}
		
		Set<Map.Entry<String, Integer>> wordSet = words.entrySet(); 
		List<Map.Entry<String, Integer>> wordList = new ArrayList<>(wordSet);
		wordList.sort(new WordCountComparator());
		int rows = 0;
		for(Map.Entry<String, Integer> ws : wordList) {
			rows++;
			System.out.println(ws.getKey() + ", " + ws.getValue());
			if(rows>4) {
				break;
			}
		}
		//for(int i = 0; i<5; i++) {
		//	Map.Entry<String, Integer> ws = wordList.get(i);
		//	System.out.println(ws.getKey() + ", " + ws.getValue());
		//}
		
		
			
		
	}
	public List<Map.Entry<String, Integer>> getWordList() { 
		return new ArrayList<Map.Entry<String, Integer>>(words.entrySet());
		
	}
	public List<String>getKeyList(){ 
		return new ArrayList<String>(words.keySet());
		
	}

}
