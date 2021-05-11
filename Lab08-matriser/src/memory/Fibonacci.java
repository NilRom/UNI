package memory;

import java.util.Scanner;
import java.util.ArrayList;
public class Fibonacci {

	public static void fib(int n) {
		int fib1 = 1;
		int fib2 = 1;
		System.out.println(fib1);
		System.out.println(fib2);
		for (int i = 1; i <= n; i++) {
			if (i == fib1 + fib2) {
				System.out.println(i);
				fib1 = fib2;
				fib2 = i;
			}
		}
	}
	public static int[] fib2(int n) {
		ArrayList<Integer> fibonacci = new ArrayList<Integer>();
		int fib1 = 1;
		int fib2 = 1;
		for (int i = 1; i <= n; i++) {
			if (i == fib1 + fib2) {
				fibonacci.add(i);
				fib1 = fib2;
				fib2 = i;
			}
		}
		int[] fibovektor = new int[fibonacci.size()];
		for(int i=0; i<fibonacci.size();i++) {
			fibovektor[i] = fibonacci.get(i);
		}
		return fibovektor;
	}
	
	public static void main(String[] args) {
		Scanner scan = new Scanner(System.in);
		int n = scan.nextInt();
		int[] fibo = fib2(n);
		for(int i =0; i<fibo.length;i++) {
			System.out.println(fibo[i]);
		}
		
	}

}