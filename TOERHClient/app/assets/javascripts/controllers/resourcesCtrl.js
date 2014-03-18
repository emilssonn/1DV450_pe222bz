/*global angular */

angular.module('TOERH.controllers').controller('ResourcesCtrl', ['$scope', '$location', 'Resources', function ($scope, $location, Resources) {
    'use strict';

    var allowedParams = ['q', 'tags', 'users', 'license_ids', 'resource_type_ids'],

        searchParams = function () {
            var obj = $location.search(),
                newObj = {};
            angular.forEach(obj, function (value, prop) {
                if (~allowedParams.indexOf(prop) && value) {
                    newObj[prop] = value;
                }
            });
            if (obj.page) {
                newObj.limit = 30;
                newObj.offset = 30 * obj.page - 30;
            }
            return newObj;
        },

        getResources = function () {
            Resources.query(searchParams(),
                function (data) {
                    var collection = data.collection;
                    $scope.resources = collection.items;
                    $scope.total = collection.total;
                },
                function (data) {

                });
        };

    $scope.$on('$locationChangeSuccess', function () {
        getResources();
    });
    getResources();
}]);