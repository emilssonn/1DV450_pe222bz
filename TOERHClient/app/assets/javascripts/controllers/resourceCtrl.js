/*global angular */

angular.module('TOERH.controllers').controller('ResourceCtrl', ['$scope', 'Resources', 'Auth', '$state', 'resource', 'licenses', 'resourceTypes', 'StringHelper',
    function ($scope, Resources, Auth, $state, resource, licenses, resourceTypes, StringHelper) {
        'use strict';

        $scope.licenses = licenses.collection.items;
        $scope.resourceTypes = resourceTypes.collection.items;

        $scope.resource = resource ? resource.instance : {};
        $scope.resource.tags = $scope.resource.tags || [];
        
        if ($state.is('resources.edit')) {
            $scope.resource.license = $scope.licenses[$scope.licenses.map(
                function (l) { 
                    return l.id 
                }).indexOf($scope.resource.license.id)];

            $scope.resource.resourceType = $scope.resourceTypes[$scope.resourceTypes.map(
                function (r) { 
                    return r.id 
                }).indexOf($scope.resource.resourceType.id)];
        } else {
            $scope.resource.license = $scope.licenses[0];
            $scope.resource.resourceType =  $scope.resourceTypes[0];
        }
       
        $scope.master = angular.copy($scope.resource);
    
        var isOwner = $scope.isOwner = (Auth.isLoggedIn && $scope.resource.user && $scope.resource.user.id === Auth.user.id),
            allowedProps = ['id', 'name', 'description', 'url', 'tags', 'license', 'resourceType', 'user'],

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

        $scope.isUnchanged = function(r) {
            return angular.equals(r, $scope.master);
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

        $scope.remove = function () {
            Resources.remove({id: $scope.resource.id},
                function (data) {
                    $state.go('resources.search');
                }, function (data) {

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
        
    }]);