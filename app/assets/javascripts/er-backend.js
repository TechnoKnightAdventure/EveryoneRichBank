// ///////////////////////////////////////////////////////////////////////////
// This is an abstraction of our backend service
// ///////////////////////////////////////////////////////////////////////////
var module = angular.module('er.backend', []);
module.service('$backend', function($http, $q) {

  // The Teller Service is encapsulated here
  this.teller = new function() {

    // Named URLS
    function customers_path()  { return '/teller/customers.json'      }
    function customer_path(id) { return '/teller/customer/'+id+'.json'}

    // Get all the users from the teller controller
    this.getAllUsers = function() {
      return $q(function(resolve, reject){

        $http.get(customers_path())
        .success(function(data) {
          resolve(data.users);
        })
        .error(function(msg, code) {
          reject(code + " Error: Could not get users.");
        })

      });
    }

    // Get a specific user from the teller controller
    this.getUserById = function(id) {
      return $q(function(resolve, reject) {

        $http.get(customer_path(id))
        .success(function(data) {
          if (data.success) {
            resolve(data.user);
          } else {
            reject("Error: "+data.message+"\n"+_(data.errors).join());
          }
        })
        .error(function(msg, code) {
          reject(code + " Error: Can not get a user with an ID " + id);
        });
      });

    }
  }

  this.createPaymentAccount = function(userId, accountName) {
    return $q(function(resolve, reject) {
      alert("Not Implemented");
    });
  }

  this.deletePaymentAccount = function(id) {
    return $q(function(resolve, reject) {
      alert("Not Implemented");
    });
  }

  this.moneyOperationOnUser = function(user_id, op, amount) {
    // return $q(function() {
    //   $http.post('/teller/users.json', {user_id: id, operation: op, amount: amount})
    //   .success(function(data, status, headers, config) {
    //     // Things went well
    //   })
    //   .error(function(data, status, headers, config) {
    //     alert("Error: Can not do an operation on the given user.");
    //   })
    // });
  }
});
