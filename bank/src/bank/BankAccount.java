package bank;

public class BankAccount{
	private Customer holder;
	private double balance;
	private static int accountIndexGenerator=1000;
	private int accountIndex;

	public BankAccount(Customer holder) {
		this.holder = holder;
		accountIndexGenerator++;
		this.accountIndex = accountIndexGenerator;
		
	}

	public Customer getHolder() {
		return holder;
	}

	public String getHolderName() {
		return holder.getName();
	}

	public long getAccountNumber() {
		return holder.getIdNr();
	}

	public int getCustomerNr() {
		return holder.getCustomerNr();
	}
	public int getAccountIndex() {
		return accountIndex;
	}

	public double getAmount() {
		return balance;
	}

	public void deposit(double amount) {
		balance = balance + amount;
	}

	public void withdraw(double amount) {
		balance = balance - amount;
	}
	
	public String toString() {
		return "konto " + getAccountIndex() + " (" + getHolderName() + ", id " + getAccountNumber() + ", kundnr " + getCustomerNr() + ", Saldo: " + getAmount() +  ")";

	}

}
