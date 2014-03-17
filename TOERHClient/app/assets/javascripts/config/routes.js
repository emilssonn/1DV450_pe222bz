/*global angular */

angular.module('TOERH').config(['$stateProvider', '$urlRouterProvider', '$locationProvider', function ($stateProvider, $urlRouterProvider, $locationProvider) {
    'use strict';

    /**
     * Calls a resource
     * @param  {[type]} $q       
     * @param  {[type]} $resource 
     * @param  {obj}    params    
     * @return {promise}           
     */
    var loadData = function ($q, $resource, params, Auth) {
        params = params || {};
        var deferred = $q.defer();
        $resource.get(params,
            function (data) {
                if (Auth) {
                    if (data.instance.user.id === Auth.user.id) {
                        deferred.resolve(data);
                    } else {
                        deferred.reject(data);
                    }
                } else {  
                    deferred.resolve(data);
                }
            },
            function (data) {
                deferred.reject(data);
            });
        return deferred.promise;
    };

    $urlRouterProvider
        .otherwise('/resources/');

    $stateProvider
        .state('resources', {
            templateUrl: '/assets/home.html',
            abstract: true,
            url: '/resources/',
            reloadOnSearch: false,
            resolve: {
                licenses: ['Licenses', '$q', function (Licenses, $q) {
                    return loadData($q, Licenses);
                }],
                resourceTypes: ['ResourceTypes', '$q', function (ResourceTypes, $q) {
                    return loadData($q, ResourceTypes);
                }]
            }
        })
        .state('resources.search', {
            templateUrl: '/assets/search.html',
            controller: 'SearchCtrl',
            url: ''
        })
        .state('resources.create', {
            templateUrl: '/assets/resourceForm.html',
            controller: 'ResourceCtrl',
            url: 'new/'
        })
        .state('resources.show', {
            templateUrl: '/assets/resource.html',
            controller: 'ResourceCtrl',
            url: ':id/',
            resolve: {
                resource: ['Resources', '$stateParams', '$q', function (Resources, $stateParams, $q) {
                    return loadData($q, Resources, $stateParams);
                }]
            }
        })
        .state('resources.edit', {
            templateUrl: '/assets/resourceForm.html',
            controller: 'ResourceCtrl',
            url: ':id/edit/',
            resolve: {
                resource: ['Resources', '$stateParams', '$q', 'Auth', function (Resources, $stateParams, $q, Auth) {
                    return loadData($q, Resources, $stateParams, Auth);

                }]
            }
        })
        .state('resources.me', {
            templateUrl: '/assets/search.html',
            controller: 'SearchCtrl',
            url: 'me/'
        });

    //$locationProvider.html5Mode(true);

    // FIX for trailing slashes. https://github.com/angular-ui/ui-router/issues/50
    $urlRouterProvider.rule(function ($injector, $location) {
        if ($location.protocol() === 'file') {
            return;
        }

        var path = $location.path(),
        // Note: misnomer. This returns a query object, not a search string
            search = $location.search(),
            params;

        // check to see if the path already ends in '/'
        if (path[path.length - 1] === '/') {
            return;
        }

        // If there was no search string / query params, return with a `/`
        if (Object.keys(search).length === 0) {
            return path + '/';
        }

        // Otherwise build the search string and return a `/?` prefix
        params = [];
        angular.forEach(search, function (v, k) {
            params.push(k + '=' + v);
        });
        return path + '/?' + params.join('&');
    });

}]);
