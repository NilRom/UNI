package bank;

import java.util.ArrayList;
import java.util.InputMismatchException;
import java.util.Scanner;

public class BankApplication {
	public static Bank b = new Bank();
	public static Scanner scan = new Scanner(System.in).useDelimiter("\\n");

	public static void main(String[] args) {
		testAddAccounts();
		runApplication();
	}

	// kör programmet
	public static void runApplication() {
		printUI();
		int choice = 0;
		while (choice != 9) {
			choice = 0;

			try {
				choice = scan.nextInt();

			} catch (InputMismatchException e) {
				System.out.println("Gör ditt val genom att skriva en siffra 1-9 i terminalen");
				choice = 0;
				printUI();
				scan.next();
			}
			// hitta kontoinnehavare
			if (choice == 1) {
				System.out.println("val: 1. Sök konto utifrån innehavare");
				findAccountsForHolder();

			}
			// findByPartofName
			if (choice == 2) {
				System.out.println("val: 2. Sök kontoinnehavare utifrån (del av) namn");
				findByPartofName();
			}
			if (choice == 3) {
				System.out.println("val: 3. Sätt in");
				deposit();
			}
			if (choice == 4) {
				System.out.println("val: 4. Ta ut");
				withdraw();
			}
			if (choice == 5) {
				System.out.println("val: 5. Överföring");
				transfer();
			}
			// add account
			if (choice == 6) {
				System.out.println("Val: 6. Skapa konto");
				addAccount();
			}
			// remove account
			if (choice == 7) {
				System.out.println("Val: 7. Ta bort konto");
				removeAccount();
			}

			// printa all accounts
			if (choice == 8) {
				
				printAllAccounts();
			}

			if (choice == 9) {
				System.out.println("Val: 9. Avsluta \nTack, hejdå");

			}
		}
	}

	// 3. Sätta in
	public static void deposit() {
		System.out.println("Vilket konto vill du sätta in i? Skriv ditt kontonummer");
		try {
			int tempAccountNumber = scan.nextInt();

			if (b.doesAccountExist(tempAccountNumber)) {
				System.out.println(
						b.getAccountFromAccountNumber(tempAccountNumber).toString() + "\nHur mycket vill du sätta in?");
				double ammount = scan.nextDouble();
				if (b.deposit(tempAccountNumber, ammount)) {
					printUI();
					System.out.println("Insättning lyckades!" + "\n"
							+ b.getAccountFromAccountNumber(tempAccountNumber).toString());
				}
				else {
					printUI();
					System.out.println("Insättningen mislyckades, du har angett ett felaktigt belopp" + "\n"
							+ b.getAccountFromAccountNumber(tempAccountNumber).toString());
				}
			} else {
				printUI();
				System.out.println("Det finns inget konto med kontonummret du har angivit \nvänligen försök igen");
				return;
			}

		} catch (InputMismatchException e) {
			printUI();
			System.out.println(
					"Du har angivit ett ogiltigt kontonummer eller ett ogiltigt belopp vänligen börja om från början");
			return;
		}
	}

	// 4. Ta ut
	public static void withdraw() {
		System.out.println("Vilket konto vill du ta ut ifrån? Skriv ditt kontonummer");
		try {
			int tempAccountNumber = scan.nextInt();
			if (b.doesAccountExist(tempAccountNumber)) {
				System.out.println(
						b.getAccountFromAccountNumber(tempAccountNumber).toString() + "\nHur mycket vill du ta ut?");
				double ammount = scan.nextDouble();
				if (b.withdraw(tempAccountNumber, ammount)) {
					printUI();
					System.out.println(
							"Uttaget lyckades!" + "\n" + b.getAccountFromAccountNumber(tempAccountNumber).toString());
				} else {
					printUI();
					System.out.println("Uttaget mislyckades, konto " + tempAccountNumber + " saknar täckning");
				}
			} else {
				printUI();
				System.out.println("Det finns inget konto med kontonummret du har angivit \nVänligen försök igen");
				return;
			}

		} catch (InputMismatchException e) {
			printUI();
			System.out.println(
					"Du har angivit ett ogiltigt kontonummer eller ett ogiltigt belopp vänligen börja om från början");
			return;
		}

	}

	// 5. Överföring
	public static void transfer() {
		System.out.println(
				"Vilket konto vill du göra en överföring från? Skriv kontonummret till det konto du vill föra över pengar ifrån");
		try {
			int accountNumber1 = scan.nextInt();
			System.out.println(
					"Tack, vilket konto vill du göra överföringen till? Skriv kontonummret till det konto du vill föra över pengar till");
			int accountNumber2 = scan.nextInt();
			if (b.doesAccountExist(accountNumber1) && b.doesAccountExist(accountNumber2)) {
				System.out.println(b.getAccountFromAccountNumber(accountNumber1).toString() + "\n"
						+ b.getAccountFromAccountNumber(accountNumber2));

				System.out.println("Tack, Hur mycket pengar vill du föra över?");
				double ammount = scan.nextDouble();
				if (b.transfer(accountNumber1, accountNumber2, ammount)) {
					System.out.println(
							"Överföringen lyckades \n" + b.getAccountFromAccountNumber(accountNumber1).toString() + "\n"
									+ b.getAccountFromAccountNumber(accountNumber2));
				} else {
					System.out.println("Överföringen mislyckades. Konto: " + accountNumber1 + " saknar täckning");
				}
			} else {
				printUI();
				System.out.println("Något av kontonummrena som angivits är fel. Vänligen försök igen");
				return;
			}

		} catch (InputMismatchException e) {
			printUI();
			System.out.println(
					"Du har angivit ett ogiltigt kontonummer eller ett ogiltigt belopp vänligen börja om från början");
			return;
		}

	}

	// 8. printar alla bankens konton
	public static void printAllAccounts() {
		System.out.println("Val: 8. Skriv ut konton");
		printUI();
		ArrayList<BankAccount> tempAccounts = b.getAllAccounts();
		for (BankAccount a : tempAccounts) {
			System.out.println(a.toString());
		}
		if(tempAccounts.isEmpty()) {
			System.out.println("Det finns inga konton registrerade hos banken");
		}
	}

	// 6. Lägger till ett konto
	public static void addAccount() {
		System.out.println("Skriv kontoinnehavarens namn");
		String tempName = "";
		long tempId = 0;
		tempName = scan.next();
		System.out.println("Tack! Skriv kontoinnehavarens IDnummer");

		try {
			tempId = scan.nextLong();
			System.out.println("Tack! Kontot har lagts till");
			try{
				b.addAccount(tempName, tempId);
		}catch(NullPointerException e) {
			System.out.println("Du har angett ett felaktigt IDnummer. Inget konto har lagts till. Vänligen börja om från början");
			printUI();
			return;
		}
		} catch (InputMismatchException e) {
			printUI();
			System.out.println("Du har angett ett felaktigt IDnummer. Inget konto har lagts till. Vänligen börja om från början");
			return;
		}
		printUI();
		System.out.println(b.findHolder(tempId).ToString() + "\nKonto skapat. Ditt kontonummer är: "
				+ b.getLastAccount().getAccountIndex());
	}

	// 7. Tar bort konto
	public static void removeAccount() {
		System.out.println("Vilket konto vill du ta bort? Skriv kontonummret till det konto du vill ta bort");
		try {
			int tempAccountNumber = scan.nextInt();
			if (b.doesAccountExist(tempAccountNumber)) {
				System.out.println(b.getAccountFromAccountNumber(tempAccountNumber)
						+ "\n Är du säker på att du vill ta bort kontot? Om du vill ta bort det skriv 'Ja'. Om inte skriv 'Nej'");
				String answer = scan.next().toLowerCase();
				if (answer.equals("ja")) {
					if (b.removeAccount(tempAccountNumber)) {
						System.out.println("Kontot har tagits bort");
					} else {
						System.out.println("Kontot har inte tagits bort");
					}
				} else {
					System.out.println("Okej! Inget konto har tagits bort");
					printUI();
					return;
				}
			} else {
				System.out.println("Ett konto med det kontonummret existerar ej. Vänligen försök igen");
				printUI();
				return;
			}

		} catch (InputMismatchException e) {
			System.out.println("Du har angivit ett ogiltigt kontonummer, vänligen börja om från början");
			printUI();
			return;
		}
	}
	
	// 1. Hittar konto från id
	// 1. Hittar konto utifrån id
	public static void findAccountsForHolder() {
		System.out.println("Vänligen skriv ditt Idnummer");
		long tempId = 0;
		try {
			tempId = scan.nextLong();
		} catch (InputMismatchException e) {
			System.out.println("Du har angett ett felaktigt IDnummer. Vänligen börja om från början");
			printUI();
			return;
		}
		ArrayList<BankAccount> tempAccounts = b.findAccountsForHolder(tempId);
		if(tempAccounts.isEmpty()) {
			System.out.println("Personen med IDnummer: " + tempId + " Har inga konton registrerade i banken");
			printUI();
			return;
		}
		for (BankAccount a : tempAccounts) {
			System.out.println(a.toString());
		}
	}

	// 2. Hittar konto från namn
	public static void findByPartofName() {
		System.out.println("Vänligen skriv ditt namn");
		String tempName = scan.next();
		ArrayList<BankAccount> tempAccounts = b.findByPartofName(tempName);
		if (tempAccounts.isEmpty()) {
			printUI();
			System.out.println("Personen har inga aktiva konton i banken");
			return;
		}
		printUI();
		System.out.println("En sökning på '" + tempName + "' ger följande konton");
		for (BankAccount a : tempAccounts) {
			System.out.println(a.toString());
		}
	}

	// lägger till några konton från början
	public static void testAddAccounts() {
		b.addAccount("Nils Romanus", (long) 98091964);
		b.addAccount("Nils Romanus", (long) 98091964);
		b.addAccount("Nils Romanus", (long) 98091964);
		b.addAccount("Nils Romanus", (long) 98091964);
		b.addAccount("Nils Romanus", (long) 98091964);
		b.addAccount("Kajsa Jernetz", (long) 980923554);
		b.addAccount("Arvid Gramer", (long) 973747223);
		b.addAccount("Greta Thunberg", (long) 372523784);
		b.addAccount("Dr. Dog", (long) 2342624);
		b.addAccount("Agneta alm", (long)9809196);
		b.deposit(1001, 350);
		b.deposit(1003, 6950);
		b.deposit(1005, 7);
		b.deposit(1007, 2);
		b.deposit(1009, 10000);

	}

	// printar UIen
	public static void printUI() {
		System.out.println("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -");
		System.out.println("1. Hitta konto utifrån innehavare \n" + "2. Sök kontoinnehavare utifrån (del av) namn \n"
				+ "3. Sätt in \n" + "4. Ta ut \n" + "5. Överföring \n" + "6. Skapa konto \n" + "7. Ta bort konto \n"
				+ "8. Skriv ut konton \n" + "9. Avsluta"
				+ "\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -");
	}
}
