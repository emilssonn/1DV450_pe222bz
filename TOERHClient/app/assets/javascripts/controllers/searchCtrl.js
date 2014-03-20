/*global angular */

angular.module('TOERH.controllers').controller('SearchCtrl', ['$scope', '$location', 'licenses', 'resourceTypes',
    function ($scope, $location, licenses, resourceTypes) {
        'use strict';

        $scope.licenses = licenses.collection.items;
        $scope.resourceTypes = resourceTypes.collection.items;

        //Params allowed to be used. Property name = name on the $scope.search object. Value = name to be used in url
        var allowedParams = {q: 'q', tags: 'tags', user: 'user', licenses: 'license_ids', resourceTypes: 'resource_type_ids', page: 'page'},

            //Transform the search object to url parameters
            searchParamsToUrl = function (obj) {
                var newObj = {};
                angular.forEach(obj, function (value, prop) {
                    if (allowedParams.hasOwnProperty(prop) && value) {
                        if ((prop !== 'q' || prop !== 'page') && (angular.isArray(value) && value.length > 0)) {
                            newObj[allowedParams[prop]] = value.map(function(val) {
                                return angular.isString(val) ? val : val.id;
                            }).join(',');
                        } else if (prop === 'q' || prop === 'page' || prop === 'user') {
                            newObj[allowedParams[prop]] = value;
                        }
                    }
                });
                return newObj;
            },

            //Transform the url parameters to the search object
            searchParamsFromUrl = function () {
                var newObj = {};
                angular.forEach($location.search(), function (value, prop) {
                    var newProp;
                    if (value) {
                        angular.forEach(allowedParams, function (value2, prop2) {
                            if (newProp) {
                                return;
                            }
                            if (value2 === prop) {
                                newProp = prop2;
                            }
                        });
                    }
                    if (newProp) {
                        //Transform the ids to complete objects
                        if (newProp === 'licenses') {
                            var t = value.split(',');
                            newObj[newProp] = licenses.collection.items.filter(function (obj) {
                                return ~t.indexOf(obj.id);
                            });
                        } else if (newProp === 'resourceTypes') {
                            var t = value.split(',');
                            newObj[newProp] = resourceTypes.collection.items.filter(function (obj) {
                                return ~t.indexOf(obj.id);
                            });
                        } else {
                            if (newProp === 'tags') {
                                newObj[newProp] = value.split(',');
                            } else {
                                newObj[newProp] = value;
                            }
                        }
                    }
                });

                newObj.tags = newObj.tags || [];
                newObj.licenses = newObj.licenses || [];
                newObj.resourceTypes = newObj.resourceTypes || [];
                return newObj;
            };

        $scope.doSearch = function () {
            $location.search(searchParamsToUrl($scope.search));
        };

        $scope.addTag = function ($event) {
            if (!$event || ($event && $event.keyCode === 13)) {
                if ($event) {
                    $event.preventDefault();
                }
                if ($scope.tag && !~$scope.search.tags.indexOf($scope.tag)) {
                    if ($scope.search.tags.length < 20) {
                        $scope.search.tags.push($scope.tag);
                        $scope.tag = "";
                    }
                 }
            }
        };

        $scope.removeTag = function ($index) {
            $scope.search.tags.splice($index, 1);
        };

        $scope.removeLicense = function ($index) {
            $scope.search.licenses.splice($index, 1);
        };

        $scope.removeResourceType = function ($index) {
            $scope.search.resourceTypes.splice($index, 1);
        };

        $scope.$on('$locationChangeSuccess', function () {
            $scope.search = searchParamsFromUrl();
            $scope.search.tags = $scope.search.tags || [];
        });

        $scope.search = searchParamsFromUrl();
        $scope.doSearch();

        //License select box, add to array on selection
        $scope.$watch('search.license', function (newVal) {
            if (newVal && !~$scope.search.licenses.map(function (l) {
                return l.id;
            }).indexOf(newVal.id)) {
                $scope.search.licenses.push(newVal);
            }
            $scope.search.license = null;
        });

        //Resource type select box, add to array on selection
        $scope.$watch('search.resourceType', function (newVal) {
            if (newVal && !~$scope.search.resourceTypes.map(function (l) {
                return l.id;
            }).indexOf(newVal.id)) {
                $scope.search.resourceTypes.push(newVal);
            }
            $scope.search.resourceType = null;
        });
    }]);