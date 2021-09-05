package bst;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import bst.BinarySearchTree;
import bst.BinarySearchTree.BinaryNode;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.Comparator;

class testTree {
	private BinarySearchTree<Integer> intTree;
	private BinarySearchTree<Integer> intTreeC;
	private BinarySearchTree<String> stringTree;
	private BinarySearchTree<String> stringTreeC;
	private static String[] TESTWORDS = { "frankofil", "hej", "dunderklump", "kuk",
			"tjena", "Apple", "Banana", "Orange", "Grapes"};
	private static int NBR = 8;

	@BeforeEach
	void setUp() throws Exception {
		intTree = new BinarySearchTree<Integer>();
		stringTree = new BinarySearchTree<String>();
		Comparator<BinaryNode<Integer>> intComp = (BinaryNode<Integer> n1, BinaryNode<Integer> n2)-> n1.element-n2.element;
		Comparator<BinaryNode<String>> stringComp = (BinaryNode<String> n1, BinaryNode<String> n2)-> n1.element.compareTo(n2.element);
		intTreeC = new BinarySearchTree(intComp);
		stringTreeC = new BinarySearchTree(stringComp);
	}

	@AfterEach
	void tearDown() throws Exception {
		intTree = null;
		stringTree = null;

	}

	private void setUpTestTrees() {
		for (int i = 0; i < NBR; i++) {
			intTree.add(i);
			stringTree.add(TESTWORDS[i]);
		}
	}
	

	@Test
	void testAdd() {
		setUpTestTrees();
		assertFalse(intTree.add(3));
		assertFalse(stringTree.add("kuk"));
	}

	@Test
	void testPrint() {
		setUpTestTrees();
		intTree.printTree();
		stringTree.printTree();
	}
	@Test
	void testClear() {
		setUpTestTrees();
		intTree.clear();
		stringTree.clear();
		assertTrue(intTree.height()==0);
		assertTrue(stringTree.height()==0);
	}
	@Test
	void testHeight() {
		setUpTestTrees();
		assertTrue(intTree.height()==5);
		assertTrue(stringTree.height()==5);
	}
	void testSize() {
		setUpTestTrees();
		assertTrue(intTree.size()==NBR);
		assertTrue(stringTree.size()==NBR);
	}
	@Test
	void testEmpty() {
		assertTrue(intTree.height()==0);
		assertTrue(stringTree.height()==0);
		
	}

}
