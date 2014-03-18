/*global angular */

angular.module('TOERH.controllers').controller('SearchCtrl', ['$scope', '$location', 'Licenses', 'ResourceTypes', 
    function ($scope, $location, Licenses, ResourceTypes) {
    'use strict';

    var allowedParams = ['q', 'tags', 'users', 'license_ids', 'resource_type_ids', 'page'],

        searchParamsToUrl = function (obj) {
            var newObj = {};
            angular.forEach(obj, function (value, prop) {
                if (~allowedParams.indexOf(prop) && value) {
                    if (prop !== ('q' || 'page') && (angular.isArray(value) && value.length > 0)) {
                        newObj[prop] = value.join(',');
                    } else if (prop === ('q' || 'page')) {
                        newObj[prop] = value;
                    }     
                }
            });
            return newObj;
        },

        searchParamsFromUrl = function () {
            var newObj = {};
            angular.forEach($location.search(), function (value, prop) {
                if (~allowedParams.indexOf(prop) && value) {
                    if (prop === 'license_ids') {
                        var t = value.split(',');
                        newObj[prop] = Licenses.collection.items.filter(function (obj) {
                            return ~t.indexOf(obj.id);
                        });
                    } else if (prop === 'resource_type_ids') {
                        var t = value.split(',');
                        newObj[prop] = ResourceTypes.collection.items.filter(function (obj) {
                            return ~t.indexOf(obj.id);
                        });
                    } else {
                        if (prop === ('tags' || 'users')) {
                            newObj[prop] = value.split(',');
                        } else {
                            newObj[prop] = value;
                        }
                    } 
                }
            });
            return newObj;
        };

    $scope.doSearch = function () {
        $location.search(searchParamsToUrl($scope.search));
    };

    $scope.addTag = function ($event) {
        if (!$event || ($event && $event.keyCode === 13)) {
            if ($scope.tag && !~$scope.search.tags.indexOf($scope.tag)) {
                $scope.search.tags.push($scope.tag);
                $scope.tag = "";  
             } 
        }
    };

    $scope.removeTag = function ($index) {
        $scope.search.tags.splice($index, 1);
    };

    $scope.$on('$locationChangeSuccess', function () {
        $scope.search = searchParamsFromUrl();
        $scope.search.tags = $scope.search.tags || [];
    });

    $scope.search = searchParamsFromUrl();
    $scope.search.tags = $scope.search.tags || [];
    $scope.doSearch();
    
}]);