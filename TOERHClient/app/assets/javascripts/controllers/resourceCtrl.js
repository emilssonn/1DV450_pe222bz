/*global angular */

angular.module('TOERH.controllers').controller('ResourceCtrl', ['$scope', 'Resources', 'Auth', '$state', 'resource', 'licenses', 'resourceTypes',
    function ($scope, Resources, Auth, $state, resource, licenses, resourceTypes) {
        'use strict';

        $scope.resource = resource.instance;
        var isOwner = $scope.isOwner = (Auth.isLoggedIn && $scope.resource.user.id === Auth.user.id);

        if ($state.is('resources.show')) {
            if (isOwner) {
                $scope.remove = function () {
                    Resources.remove({id: $scope.resource.id},
                        function (data) {
                            $state.go('resources.search');
                        }, function (data) {

                        });
                };
            }
        } else {
            $scope.licenses = licenses.collection.items;
            $scope.resource.license = $scope.licenses[$scope.licenses.map(
                function (l) { 
                    return l.id 
                }).indexOf($scope.resource.license.id)];

            $scope.resourceTypes = resourceTypes.collection.items;
            $scope.resource.resourceType = $scope.resourceTypes[$scope.resourceTypes.map(
                function (r) { 
                    return r.id 
                }).indexOf($scope.resource.resourceType.id)];

            var allowedProps = ['id', 'name', 'description', 'url', 'tags', 'license', 'resourceType', 'user'],

                //Create a object to save
                cleanResource = function (obj) {
                    var newObj = {};
                    angular.forEach(obj, function (value, prop) {
                        if (~allowedProps.indexOf(prop) && value) {
                            if (angular.isObject(value) && !angular.isArray(value)) {
                                newObj[prop + '_id'] = value.id;
                            } else {
                                newObj[prop] = value;  
                            }
                        }
                    });
                    return newObj;
                };
        
            $scope.save = function () {
                var resourceToSave = cleanResource($scope.resource);
                if (!resourceToSave.id) {
                    resourceToSave.user_id = Auth.user.id;
                }
                Resources[resourceToSave.id ? 'update' : 'create'](resourceToSave,
                    function (data) {
                        $state.go('resources.show', {id: data.instance.id});
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
    }]);