/*global angular */

angular.module('TOERH.controllers').controller('UserResourcesCtrl', ['$scope', 'Resources', 'Auth', function ($scope, Resources, Auth) {
    'use strict';


    var getResources = function () {
        Resources.query({user_ids: Auth.user.id },
            function (data) {
                var collection = data.collection;
                $scope.resources = collection.items;
                $scope.total = collection.total;
            },
            function (data) {

            });
    };

    getResources();
}]);