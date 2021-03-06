defmodule BankTest do
  use ExUnit.Case

  test "balance/1 gives correct balance when no transactions" do
    account = %Bank.Account{account_num: 123, initial_balance: 100}

    assert Bank.Core.balance(account) == 100
  end

  test "balance/1 gives correct balance with transactions" do
    account = %Bank.Account{
      account_num: 321,
      initial_balance: 100,
      transactions: [
        %Bank.Transaction{amount: 10, account_num: 123, datetime: ""},
        %Bank.Transaction{amount: 75, account_num: 123, datetime: ""},
        %Bank.Transaction{amount: -15, account_num: 123, datetime: ""}
      ]
    }

    assert Bank.Core.balance(account) == 100 + 10 + 75 - 15
  end

  test "transfer/3 adds complementary transactions to both accounts" do
    from = %Bank.Account{account_num: 321, initial_balance: 100}
    to = %Bank.Account{account_num: 123, initial_balance: 100}

    {:ok, {new_from, new_to}} = Bank.Core.transfer(from, to, 10)
    [from_transaction | _] = new_from.transactions
    [to_transaction | _] = new_to.transactions

    assert from_transaction.amount == -to_transaction.amount
  end

  test "transfer/3 error when from account balance too low" do
    from = %Bank.Account{account_num: 321, initial_balance: 100}
    to = %Bank.Account{account_num: 123, initial_balance: 100}

    {:error, _} = Bank.Core.transfer(from, to, 101)
  end
end
