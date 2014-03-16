/*global angular */

angular.module('TOERH.controllers').controller('SearchCtrl', ['$scope', '$location', function ($scope, $location) {
    'use strict';

    var allowedParams = ['q', 'tags', 'user_ids', 'license_ids', 'resource_type_ids', 'page'],

        searchParams = function (obj) {
            var newObj = {};
            angular.forEach(obj, function (value, prop) {
                if (~allowedParams.indexOf(prop) && value) {
                    newObj[prop] = value;
                }
            });
            return newObj;
        };

    $scope.doSearch = function () {
        $location.search(searchParams($scope.search || $location.search()));
    };

    $scope.addTag = function ($event) {
        if (!$event || ($event && $event.keyCode === 13)) {
            
        }
    };

    $scope.doSearch();
    $scope.search = searchParams($location.search());
}]);