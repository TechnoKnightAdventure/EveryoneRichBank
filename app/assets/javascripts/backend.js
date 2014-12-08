/////////////////////////////////////////////////////////////////////////////
// This is an abstraction of our backend service                           //
/////////////////////////////////////////////////////////////////////////////
var module = angular.module('er.backend', []);
module.service('$backend', function($http, $q) {
  // User Service encapsulation
  this.customers = new function() {

    // Named URLS
    function customers_path()  { return 'api/customers.json'      }
    function customer_path(id) { return 'api/customers/'+id+'.json'}

    // Get all the users from the teller controller
    this.getList = function() {
      return $q(function(resolve, reject){

        $http.get(customers_path())
        .success(function(data) {
          resolve(data.customers);
        })
        .error(function(msg, code) {
          reject(code + " Error: Could not get customers.");
        })

      });
    }
    // Get a specific user from the teller controller
    this.findById = function(id) {
      return $q(function(resolve, reject) {

        $http.get(customer_path(id))
        .success(function(data) {
          resolve(data.customer);
        })
        .error(function(msg, code) {
          reject(code + " Error: Can not get a customer with an ID " + id);
        });
      });

    }
    this.getCurrentCustomer = function() {
      return this.findById('current');
    }
  };

  // Payment Account encapsulation
  this.paymentAccount = new function() {

    // Named URLS
    function accounts_path()               { return 'api/payment_accounts/all.json'               }
    function accounts_penalty_threshold()  { return 'api/payment_accounts/penalty-threshold.json' }
    function accounts_op_path()            { return 'api/payment_accounts/op.json'                }
    function account_path(id)              { return 'api/payment_accounts/'+id+'.json'            }
    function account_transfer_path(id)     { return 'api/payment_accounts/'+id+'/transfer.json'   }
    function account_credit_debit_path(id) { return 'api/payment_accounts/'+id+'/credit-debit.json'}
    function customer_accounts_path(cid)   { return 'api/customers/'+cid+'/payment_accounts.json' }

    this.getPenaltyThreshold = function() {
      return $q(function(resolve, reject) {

        $http.get(accounts_penalty_threshold())
        .success(function(data) {
          resolve(data.threshold);
        })
        .error(function(msg, code) {
          reject(code + " Error: can not get the penalty threshold");
        });
      });
    }

    this.getAccountsForUserId = function(cid) {
      return $q(function(resolve, reject) {

        $http.get(customer_accounts_path(cid))
        .success(function(data) {
          resolve(data.accounts)
        })
        .error(function(msg, code) {
          reject(code + " Error: Can not get accounts for user with an ID " + id);
        });

      });
    }
    this.getAccountsForCurrentUser = function() {
      return this.getAccountsForUserId('current');
    }
    this.getAccountById = function(id) {
      return $q(function(resolve, reject) {

        $http.get(account_path(id))
        .success(function(data) {
          resolve(data.account);
        })
        .error(function(msg, code) {
          reject(code + " Error: Can not get account with an ID " + id);
        });
        
      });

    }
    this.create = function(userId, accountName, accountType) {
      return $q(function(resolve, reject) {

        $http.post(customer_accounts_path(userId), { name: accountName, type: accountType })
        .success(function() {
          resolve();
        })
        .error(function(msg, code){
          reject(code + " Error: Can not create account for user [" + userId + "]" + msg.error);
        });

      });
    }
    this.delete = function(id) {
      return $q(function(resolve, reject) {
        $http.delete(account_path(id))
        .success(function() {
          resolve();
        })
        .error(function(msg, code){
          reject(code + " Error: Can not delete account [" + id + "]");
        });
      });
    }
    this.transferMoney = function(amount, from, to) {
      return $q(function(resolve, reject) {

        $http.post(account_transfer_path(), {fromId: from, toId: to, amount: amount})
        .success(function() {
          resolve();
        })
        .error(function(msg, code){
          reject(code + " Error: Can not transfer money for accounts [" + from + "]->[" + to + "]");
        });

      });
    }
    this.moneyOperation = function(account_id, op, amount, description) {
      return $q(function(resolve, reject) {

        $http.post(account_credit_debit_path(account_id), {operation: op, amount: amount, description: description})
        .success(function(data, status, headers, config) {
          resolve();
        })
        .error(function(data, status, headers, config) {
          reject(data.error);
        })

      });
    }
    this.applyGlobalInterest = function() {
      return $q(function(resolve, reject){

        $http.post(accounts_op_path(), {operation: 'interest'})
        .success(function(data, status, headers, config) {
          resolve(data.applied);
        })
        .error(function(data) {
          reject(data.error);
        })

      });
    }
    this.applyGlobalPenalty = function() {
      return $q(function(resolve, reject){

        $http.post(accounts_op_path(), {operation: 'penalty'})
        .success(function(data, status, headers, config) {
          resolve(data.applied);
        })
        .error(function(data) {
          reject(data.error);
        })

      });
    }
  };
  this.transactions = new function() {
    function payment_account_transaction_path(id) { return 'api/payment_accounts/'+id+'/transactions.json'   }

    this.getTransactionsForPaymentAccountId = function(id) {
      return $q(function(resolve, reject) {

        $http.get(payment_account_transaction_path(id))
        .success(function(data) {
          resolve(data.transactions)
        })
        .error(function(msg, code) {
          reject(code + "Error: Can not list transactions for account [" + id + "]" + msg);
        })
      });
    }
  };
});
