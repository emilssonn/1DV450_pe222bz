/*global angular */

angular.module('TOERH.controllers').controller('ResourceCtrl', ['$scope', 'Resources', 'Auth', '$state', 'resource', 'licenses', 'resourceTypes',
    function ($scope, Resources, Auth, $state, resource, licenses, resourceTypes) {
        'use strict';
        $scope.resource = resource.instance;
    

        $scope.licenses = licenses.collection.items;
        $scope.resource.license = $scope.licenses[0]

        $scope.resourceTypes = resourceTypes.collection.items;
        $scope.resource.resourceType = $scope.resourceTypes[0]



        var allowedProps = ['id', 'name', 'description', 'url', 'tags', 'license', 'resourceType'],

            isOwner = $scope.isOwner = $scope.resource.user.id === Auth.user.id,


            //Create a clean editable object
            editResource = function (obj) {
                var newObj = {};
                angular.forEach(obj, function (value, prop) {
                    if (~allowedProps.indexOf(prop) && value) {
                        newObj[prop] = value;
                    }
                });
                angular.forEach(newObj.tags, function (value, index) {
                    newObj.tags[index] = value.name
                });
                return newObj;
            };



        if ($state.is('resources.show')) {
            if (isOwner) {
                $scope.remove = function () {
                    Resources.remove({id: $scope.resource.id},
                        function (data) {

                        }, function (data) {

                        });
                };
            }

        } else {
            $scope.resource = editResource($scope.resource);
            $scope.save = function () {
                if (!$scope.resource.id) {
                    $scope.resource.user_id = Auth.user.id;
                }
                var r = angular.copy($scope.resource);
                r.license_id = $scope.resource.license.id;
                r.resource_type_id = $scope.resource.resourceType.id;
                delete r.license;
                delete r.resourceType;
                Resources[r.id ? 'update' : 'create'](r,
                    function (data) {
                        $state.go('resources.show', {id: $scope.resource.id});
                    }, function (data) {
                        $scope.errors = data;
                    });
            };

            $scope.addTag = function ($event) {
                if (!$event || ($event && $event.keyCode === 13)) {
                    if ($scope.tag && !~$scope.resource.tags.indexOf($scope.tag)) {
                        $scope.resource.tags.push($scope.tag);
                        $scope.tag = "";  
                    }
                          
                }
            };

            $scope.removeTag = function ($index) {
                $scope.resource.tags.splice($index, 1);
            };
        }

        /*if ($scope.edit && (!Auth.isLoggedIn || $scope.resource.user.id !== Auth.user.id)) {
            $state.go('resources.show', {id: $scope.resource.id});
        }*/
    }]);