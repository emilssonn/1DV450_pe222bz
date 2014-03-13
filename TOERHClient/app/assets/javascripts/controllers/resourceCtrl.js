/*global angular */

angular.module('TOERH.controllers').controller('ResourceCtrl', ['$scope', '$location', function ($scope, $location) {
    'use strict';

    $scope.$watch('$routeUpdate', function () {
        console.log($location.search());
    });
}]);