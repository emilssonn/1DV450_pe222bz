/*global angular */

angular.module('TOERH.controllers').controller('ResourceCtrl', ['$scope', '$location', 'Resources', function ($scope, $location, Resources) {
    'use strict';

    $scope.$watch('$routeUpdate', function () {
        console.log($location.search());
    });

    Resources.get();
}]);