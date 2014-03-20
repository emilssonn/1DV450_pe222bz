/*global angular */

angular.module('TOERH.controllers').controller('UserResourcesCtrl', ['$scope', 'Resources', 'Auth', '$location', 'Alert', function ($scope, Resources, Auth, $location, Alert) {
    'use strict';
    /*
     TODO: refactor. Very simular to ResourceController
     */

    var getResources = function () {
        var search = {};
        if ($location.search().page && parseInt($location.search().page)) {
            search.limit = 30;
            search.offset = 30 * parseInt($location.search().page) - 30;
        }
        search.user_ids = Auth.user.id;
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

    $scope.pager = {};

    $scope.changePage = function (next) {
        if ($scope.pager.page > 1 && $scope.pager.page < $scope.pager.pages) {
            if (next) {
                $scope.pager.page = $scope.pager.page + 1;
            } else {
                $scope.pager.page = $scope.pager.page - 1;
            }
            $location.search('page', $scope.pager.page);
        }
    };

    /*
    TODO: Going to a missing route will trigger this event
     */
    $scope.$on('$locationChangeSuccess', function () {
        getResources();
    });

    getResources();
}]);