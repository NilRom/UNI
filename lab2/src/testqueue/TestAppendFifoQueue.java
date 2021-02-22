package testqueue;

import static org.junit.jupiter.api.Assertions.*;

import java.util.Iterator;
import java.util.NoSuchElementException;
import java.util.Queue;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import queue_singlelinkedlist.FifoQueue;

class TestAppendFifoQueue {
	private FifoQueue<Integer> myIntQueue1;
	private FifoQueue<Integer> myIntQueue2;
	@BeforeEach
	void setUp() throws Exception {
		myIntQueue1 = new FifoQueue<Integer>();
		myIntQueue2 = new FifoQueue<Integer>();
		
		
		
	}

	@AfterEach
	void tearDown() throws Exception {
		myIntQueue1 = null;
		myIntQueue2 = null;
		
	}

	@Test
	void testAppendNonEmpty() {
		myIntQueue1.offer(1);
		myIntQueue1.offer(2);
		myIntQueue1.offer(3);
		myIntQueue1.offer(4);
		myIntQueue1.offer(5);
		myIntQueue2.offer(6);
		myIntQueue2.offer(7);
		myIntQueue2.offer(8);
		myIntQueue2.offer(9);
		myIntQueue2.offer(10);
		myIntQueue1.append(myIntQueue2);
		int nbr = 10;
		Iterator<Integer> itr = myIntQueue1.iterator();
		for (int i = 1; i <= nbr; i++) {
			Integer x = itr.next();
			assertEquals(Integer.valueOf(i), x, "Wrong result from next");
			//System.out.println(x);
		}
		assertTrue(myIntQueue2.isEmpty());
	}
	@Test
	void testAppendBothEmpty() {
		myIntQueue1.append(myIntQueue2);
		assertTrue(myIntQueue1.isEmpty());
		assertTrue(myIntQueue2.isEmpty());
	}
	@Test
	void testAppendSecondEmpty() {
		myIntQueue1.offer(1);
		myIntQueue1.offer(2);
		myIntQueue1.offer(3);
		myIntQueue1.offer(4);
		myIntQueue1.offer(5);
		myIntQueue1.append(myIntQueue2);
		int nbr = 5;
		Iterator<Integer> itr = myIntQueue1.iterator();
		for (int i = 1; i <= nbr; i++) {
			Integer x = itr.next();
			assertEquals(Integer.valueOf(i), x, "Wrong result from next");
			//System.out.println(x);
		}
		assertEquals(myIntQueue1.size(), nbr);
		assertTrue(myIntQueue2.isEmpty());
	}
	@Test
	void testAppendFirstEmpty() {
		myIntQueue2.offer(1);
		myIntQueue2.offer(2);
		myIntQueue2.offer(3);
		myIntQueue2.offer(4);
		myIntQueue2.offer(5);
		myIntQueue1.append(myIntQueue2);
		int nbr = 5;
		Iterator<Integer> itr = myIntQueue1.iterator();
		for (int i = 1; i <= nbr; i++) {
			Integer x = itr.next();
			assertEquals(Integer.valueOf(i), x, "Wrong result from next");
			//System.out.println(x);
		}
		assertEquals(myIntQueue1.size(), nbr);
		assertTrue(myIntQueue2.isEmpty());
	}
	@Test
	void testAppendSelf() {
		myIntQueue1.offer(1);
		myIntQueue1.offer(2);
		myIntQueue1.offer(3);
		myIntQueue1.offer(4);
		myIntQueue1.offer(5);
		assertThrows(IllegalArgumentException.class, () -> myIntQueue1.append(myIntQueue1));
	}
	

}
