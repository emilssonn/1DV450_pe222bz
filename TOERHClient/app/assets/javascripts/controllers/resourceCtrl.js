/*global angular */

angular.module('TOERH.controllers').controller('ResourceCtrl', ['$scope', '$window', 'Resources', 'Auth', '$state', 'resource', 'licenses', 'resourceTypes', 'StringHelper', 'Alert',
    function ($scope, $window, Resources, Auth, $state, resource, licenses, resourceTypes, StringHelper, Alert) {
        'use strict';

        //All licenses/resource types
        $scope.licenses = licenses.collection.items;
        $scope.resourceTypes = resourceTypes.collection.items;

        //Update/new resource
        $scope.resource = resource ? resource.instance : {};
        $scope.resource.tags = $scope.resource.tags || [];

        if ($state.is('resources.edit')) {
            //Set the correct license/resource type
            $scope.resource.license = $scope.licenses[$scope.licenses.map(
                function (l) {
                    return l.id;
                }
            ).indexOf($scope.resource.license.id)];

            $scope.resource.resourceType = $scope.resourceTypes[$scope.resourceTypes.map(
                function (r) {
                    return r.id;
                }
            ).indexOf($scope.resource.resourceType.id)];
        } else {
            $scope.resource.license = $scope.licenses[0];
            $scope.resource.resourceType =  $scope.resourceTypes[0];
        }

        $scope.master = angular.copy($scope.resource);

        $scope.isOwner = (Auth.isLoggedIn() && $scope.resource.user && $scope.resource.user.id === Auth.user.id);
        var allowedProps = ['id', 'name', 'description', 'url', 'tags', 'license', 'resourceType', 'user'],

            //Create a object to save
            cleanResource = function (obj) {
                var newObj = {};
                angular.forEach(obj, function (value, prop) {
                    if (~allowedProps.indexOf(prop) && value) {
                        if (angular.isObject(value) && !angular.isArray(value)) {
                            prop = StringHelper.toUnderscore(prop);
                            newObj[prop + '_id'] = value.id;
                        } else {
                            newObj[prop] = value;
                        }
                    }
                });
                return newObj;
            };

        $scope.isUnchanged = function (r) {
            return angular.equals(r, $scope.master);
        };

        $scope.save = function () {
            var resourceToSave = cleanResource($scope.resource);
            if (!resourceToSave.id) {
                resourceToSave.user_id = Auth.user.id;
            }
            Resources[resourceToSave.id ? 'update' : 'create'](resourceToSave,
                function (data) {
                    Alert.success({message: 'Resource has saved.', msgScope: 'resource', clearScope: true});
                    $state.go('resources.show', {id: data.instance.id});
                }, function (data) {
                    if (data.status === 400) {
                        Alert.warning({message: 'Validation error. Please correct the form.', msgScope: 'resource', clearScope: true});
                        /*
                        Todo: add server errors to the DOM
                         */
                        $scope.errors = data.response;
                    } else {
                        Alert.warning({message: 'Something went wrong on the server. Please try again in a while.', msgScope: 'resource', clearScope: true});
                    }
                });
        };

        $scope.remove = function () {
            if ($window.confirm("Are you sure you want to delete the resource \"" + $scope.resource.name + "\"?")) {
                Resources.remove({id: $scope.resource.id},
                    function (data) {
                        Alert.success({message: 'Resource has deleted.', msgScope: 'resource', clearScope: true});
                        $state.go('resources.search');
                    }, function (data) {
                        Alert.warning({message: 'Something went wrong on the server. Please try again in a while.', msgScope: 'resource', clearScope: true});
                    });
            }
        };

        $scope.addTag = function ($event) {
            if (!$event || ($event && $event.keyCode === 13)) {
                if ($scope.tag && !~$scope.resource.tags.indexOf($scope.tag)) {
                    if ($scope.resource.tags.length < 20) {
                        $scope.resource.tags.push($scope.tag);
                        $scope.tag = "";
                    }
                }
            }
        };

        $scope.removeTag = function ($index) {
            $scope.resource.tags.splice($index, 1);
        };

        $scope.toggleInfo = function (prop) {
            $scope[prop] = !$scope[prop];
        };
    }]);