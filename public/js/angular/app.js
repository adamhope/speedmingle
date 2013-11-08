var app = angular.module('speedmingle', 
  ['services',
   'angular-flash.service', 
   'angular-flash.flash-alert-directive'
  ]);

app.config(function (flashProvider) {
    flashProvider.errorClassnames.push('alert-danger');
    flashProvider.successClassnames.push('alert-success');
})

var services = angular.module('services', ['restangular']);

services.factory('Participant', function(Restangular){
  return Restangular.all('participants');
});

// CONTROLLERS

var ParticipantsController = app.controller("ParticipantsController", function($scope, Participant, flash){
  $scope.init = function() {
    $scope.participants = Participant.getList();
  }

  $scope.save = function (participant) {
    Participant.all("register").post(participant).then(function(data) {
      flash.success = 'Thank you. Participant created.';
      $scope.participants = Participant.getList();
    }, function(error) {
      flash.error = 'Error creating Participant.';
    });
  }

  $scope.save_random = function(count) {
    Participant.all("random").post({"count": count}).then(function(data) {
      flash.success = 'Thank you. ' + count + ' random participants created.';
      $scope.participants = Participant.getList();
    }, function(error) {
      flash.error = 'Error creating ' + count + ' random participants.';      
    });
  }
  
  $scope.connect = function(from_participant, to_participant) {
    var req = JSON.stringify({ 
      "from": from_participant.phone_number,
      "to": to_participant.pin
    })
    Participant.all("connect").post(req).then(function(data) {
      flash.success = 'Thank you. Participant connected.';
      $scope.participants = Participant.getList();
    }, function(error) {
      flash.error = "Error connecting Participant."
    });
  }
});