package map;

import java.util.Random;

public class HashMapApplication {
	private static String[] TESTWORDS = { "REMOVEME","boll","yxa","veteran","jägarsoldat","hund",
			"katt","snäll","stor","liten","grund","r","g","fem","asdasd","te","fiti","te","rompi","bil","hus","kuk","ica","godis","data","vad","hallå","haj","oj","fasiken","ok","nej","snälla","sluta",
			"kan","du","vara","tyst","var","är","daniel","vet","ej","men","han","ronkar","säkert",
			"kuken", "123", "skulle", "ut", "på", "tur", "när", "han", "upptäckte", "att", "han", "glömt", "sin", "lilla", "jihadi", "anorexic", "girlfriend", "that", 
			"lived", "inside", "his", "dick", "the", "day", "was", "ruined", "the", "end"};
	public static void main(String[] args) {
		int nbr = 10;
		int nbr2 = 100;
		Random rand = new Random(10);
		SimpleHashMap<Integer,Integer> map = new SimpleHashMap<Integer, Integer>();
		SimpleHashMap<String,Integer> stringMap = new SimpleHashMap<String, Integer>();
		for(int i = 0; i<nbr;i++) {
			int num = rand.nextInt(50);
			map.put(num, num);
			stringMap.put(TESTWORDS[i], num);
		}
		System.out.println("######## TEST SMALL MAP ##########");
		System.out.println("Size = " + map.size());
		System.out.println(map.show());
		
		for(int i = 0; i<nbr2;i++) {
			int num = rand.nextInt(nbr2);
			map.put(num, num);
		}
		System.out.println("######## TEST REHASH WITH BIG MAP ##########");
		System.out.println("Size = " + map.size());
		System.out.println(map.show());
		
		System.out.println("######## TEST STRING MAP ##########");
		System.out.println("Size = " + stringMap.size());
		System.out.println(stringMap.show());
		
		
		
		stringMap.remove(TESTWORDS[0]);
		System.out.println("######## TEST REMOVE ##########");
		System.out.println("Description: if printout does not contain word 'REMOVEME', remove works :)");
		System.out.println("Size = " + stringMap.size());
		System.out.println(stringMap.show());
		
		
	}

}
