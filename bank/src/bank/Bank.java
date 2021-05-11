package bank;

import java.util.ArrayList;

public class Bank {
	private ArrayList<BankAccount> accounts;

	public Bank() {
		this.accounts = new ArrayList<BankAccount>();
	}

	public int addAccount(String holderName, long idNr) {
		for (BankAccount a : accounts) {
			if (a.getHolder().getIdNr() == idNr && a.getHolder().getName().equals(holderName)) {
				BankAccount tempaccount = new BankAccount(a.getHolder());
				accounts.add(tempaccount);
				return a.getCustomerNr();
			}
		}
		Customer tempholder = new Customer(holderName, idNr);
		BankAccount tempaccount = new BankAccount(tempholder);
		accounts.add(tempaccount);
		return tempaccount.getCustomerNr();

	}

	public Customer findHolder(long idNr) {
		for (BankAccount a : accounts) {
			if (a.getAccountNumber() == idNr) {
				return a.getHolder();
			}

		}
		return null;
	}

	public ArrayList<BankAccount> getAllAccounts() {
		// Collections.sort(accounts, new Comparator<BankAccount>() {
		// public int compare(BankAccount a1, BankAccount a2) {
		// return a1.getHolderName().compareTo(a2.getHolderName());
		// }
		// });
		sortAccounts();
		return accounts;
	}

	public void sortAccounts() {
		ArrayList<BankAccount> sorted = new ArrayList<BankAccount>();
		for (int i = 0; i < accounts.size(); i++) {
			String name = accounts.get(i).getHolderName();
			int pos = 0;
			while (pos < sorted.size() && sorted.get(pos).getHolderName().compareTo(name) < 0) {
				pos++;
			}
			sorted.add(pos, accounts.get(i));
		}
		accounts = sorted;
	}

	public boolean removeAccount(int number) {
		for (BankAccount a : accounts) {
			if (a.getAccountIndex() == number) {
				accounts.remove(a);
				return true;
			}

		}
		return false;
	}

	public BankAccount findByNumber(int accountNumber) {
		for (BankAccount a : accounts) {
			if (a.getAccountNumber() == accountNumber) {
				return a;
			}
		}
		return null;
	}

	public ArrayList<BankAccount> findAccountsForHolder(long idNr) {
		ArrayList<BankAccount> tempAccounts = new ArrayList<BankAccount>();
		for (BankAccount a : accounts) {
			if (idNr == a.getAccountNumber()) {
				tempAccounts.add(a);
			}
		}
		return tempAccounts;
	}

	public ArrayList<BankAccount> findByPartofName(String namePart) {
		ArrayList<BankAccount> tempAccounts = new ArrayList<BankAccount>();
		for (BankAccount a : accounts) {
			if (a.getHolderName().toLowerCase().contains(namePart.toLowerCase())) {
				tempAccounts.add(a);
			}
		}
		return tempAccounts;
	}

	public boolean deposit(int accountNumber, double amount) {
		if (amount > 0) {
			for (BankAccount a : accounts) {
				if (a.getAccountIndex() == accountNumber) {
					a.deposit(amount);
					return true;
				}
			}
			return false;
		}
		return false;
	}

	public boolean withdraw(int accountNumber, double amount) {
		for (BankAccount a : accounts) {
			if (a.getAccountIndex() == accountNumber && amount < a.getAmount() && amount>=0) {
				a.withdraw(amount);
				return true;
			}
		}
		return false;
	}

	public boolean transfer(int accountNumber1, int accountNumber2, double ammount) {
		if (withdraw(accountNumber1, ammount)) {
			if (deposit(accountNumber2, ammount)) {
				return true;
			} else {
				return false;
			}
		} else {
			return false;
		}
	}

	public BankAccount getLastAccount() {
		return accounts.get(accounts.size() - 1);
	}

	public BankAccount getAccountFromAccountNumber(int accountNumber) {
		for (BankAccount a : accounts) {
			if (a.getAccountIndex() == accountNumber) {
				return a;
			}
		}
		return null;
	}

	public boolean doesAccountExist(int accountNumber) {
		for (BankAccount a : accounts) {
			if (a.getAccountIndex() == accountNumber) {
				return true;
			}
		}
		return false;
	}

	public boolean doesHolderHaveAccount(String holderName, long holderId) {
		for (BankAccount a : accounts) {
			if (a.getHolderName().equals(holderName) && holderId == a.getHolder().getIdNr()) {
				return true;
			}
		}
		return false;
	}
}
