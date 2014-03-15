/*global angular */

angular.module('TOERH.controllers').controller('SearchCtrl', ['$scope', '$location', function ($scope, $location) {
    'use strict';

    var allowedParams = ['q', 'tags', 'user_ids', 'license_ids', 'resource_type_ids'],

        searchParams = function () {
            var newObj = {};
            angular.forEach($scope.search, function (value, prop) {
                if (~allowedParams.indexOf(prop) && value) {
                    newObj[prop] = value;
                }
            });
            return newObj;
        };

    $scope.search = {};
    //$scope.search.q = "asdasd";



    $scope.doSearch = function () {
        $location.search(searchParams());
    };

}]);