/*global angular */

angular.module('TOERH.controllers').controller('ResourceCtrl', ['$scope', 'Resources', '$stateParams', 'Auth', '$state', 'resource',
    function ($scope, Resources, $stateParams, Auth, $state, resource) {
        'use strict';

        resource = $scope.resource = resource.instance;

        var isOwner = function () {
            return resource.user.id === Auth.user.id;
        };

        if ($state.is('resources.show')) {
            
        } else {
            $scope.save = function () {
                Resources[resource.id ? 'update' : 'create'](resource,
                    function (data) {

                    }, function (data) {

                    });
            };
        }

        /*if ($scope.edit && (!Auth.isLoggedIn || $scope.resource.user.id !== Auth.user.id)) {
            $state.go('resources.show', {id: $scope.resource.id});
        }*/
    }]);