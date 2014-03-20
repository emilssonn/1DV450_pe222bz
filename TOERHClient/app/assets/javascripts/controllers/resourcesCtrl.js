/*global angular */

angular.module('TOERH.controllers').controller('ResourcesCtrl', ['$scope', '$location', 'Resources', 'Alert', function ($scope, $location, Resources, Alert) {
    'use strict';

    var allowedParams = ['q', 'tags', 'user', 'license_ids', 'resource_type_ids'],
        //Get the params to use in the api call
        searchParams = function () {
            var obj = $location.search(),
                newObj = {};
            angular.forEach(obj, function (value, prop) {
                if (~allowedParams.indexOf(prop) && value) {
                    newObj[prop] = value;
                }
            });
            if (obj.page && parseInt(obj.page)) {
                newObj.limit = 30;
                newObj.offset = 30 * parseInt(obj.page) - 30;
            }
            return newObj;
        },

        getResources = function () {
            var search = searchParams();
            Resources.query(search,
                function (data) {
                    var collection = data.collection;
                    $scope.resources = collection.items;
                    $scope.total = collection.total;
                    $scope.pager.page = search.page || 1;
                    $scope.pager.pages = $scope.total > 30 ? $scope.total / 30 : 1;
                },
                function (data) {
                    Alert.warning({message: 'Something went wrong while fetching the resources. Please try again or come back later.', msgScope: 'resources', clearScope: true});
                });
        };

    /*
    TODO: pager should not be in a controller, move to a directive
     */
    $scope.pager = {};

    $scope.changePage = function (next) {
        if ($scope.pager.page > 1 && $scope.pager.page < $scope.pager.pages) {
            if (next) {
                $scope.pager.page = $scope.pager.page + 1;
            } else {
                $scope.pager.page = $scope.pager.page -1;
            }
            $location.search('page', $scope.pager.page);
        }
    };

    $scope.$on('$locationChangeSuccess', function () {
        getResources();
    });

    getResources();
}]);