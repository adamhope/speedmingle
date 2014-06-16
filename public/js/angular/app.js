var app = angular.module('speedmingle',
  ['services',
   'angular-flash.service',
   'angular-flash.flash-alert-directive',
   'ngAnimate'
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
      flash.error = 'Error creating participant.';
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
    });
    Participant.all("connect").post(req).then(function(data) {
      flash.success = 'Thank you. Participant connected.';
      $scope.participants = Participant.getList();
    }, function(error) {
      flash.error = "Error connecting participant."
    });
  }

  $scope.connect_random = function() {
    Participant.one("connect_random").get().then(function(data) {
      flash.success = 'Thank you. Random participant connected.';
      $scope.participants = Participant.getList();
    }, function(error) {
      flash.error = "Error connecting random participant."
    });
  }

  $scope.destroy_all = function() {
    Participant.one("destroy_all").get().then(function(data) {
      flash.success = 'Thank you. Removed all participants.';
      $scope.participants = Participant.getList();
    }, function(error) {
      flash.error = "Error connecting random participant."
    })
  }
});

app.controller('DashboardSlideCtrl', ['$timeout', function(timeout) {
  var SLIDE_COUNT = 3;
  var TIMEOUT = 5000;
  var self = this;
  var nth = 0;
  var slides = ['bubble', 'connections', 'swarm'];

  self.slide = slides[0];

  timeout(function switchSlide() {
    nth++;
    self.slide = slides[nth % SLIDE_COUNT];
    timeout(switchSlide, TIMEOUT);
  }, TIMEOUT);
}]);
