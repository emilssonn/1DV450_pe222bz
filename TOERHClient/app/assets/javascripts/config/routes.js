/*global angular */

angular.module('TOERH').config(['$stateProvider', '$urlRouterProvider', '$locationProvider', function ($stateProvider, $urlRouterProvider, $locationProvider) {
    'use strict';

    $urlRouterProvider
        .otherwise('/resources/');

    $stateProvider
        .state('resources', {
            templateUrl: '/assets/home.html',
            abstract: true,
            url: '/resources/'
        })
        .state('resources.search', {
            templateUrl: '/assets/search.html',
            controller: 'SearchCtrl',
            url: '',
            reloadOnSearch: false
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
                    var deferred = $q.defer();
                    Resources.get($stateParams,
                        function (data) {
                            deferred.resolve(data);
                        },
                        function (data) {
                            deferred.reject(data);
                        });
                    return deferred.promise;
                }]
            }
        })
        .state('resources.edit', {
            templateUrl: '/assets/resourceForm.html',
            controller: 'ResourceCtrl',
            url: ':id/edit/',
            resolve: {
                resource: ['Resources', '$stateParams', '$q', function (Resources, $stateParams, $q) {
                    var deferred = $q.defer();
                    Resources.get($stateParams,
                        function (data) {
                            deferred.resolve(data);
                        },
                        function (data) {
                            deferred.reject(data);
                        });
                    return deferred.promise;
                }]
            }
            /*
            resolve: {
                resource: ['Resources', '$stateParams', 'Auth', '$state', '$q', function (Resources, $stateParams, Auth, $state, $q) {
                    var res = false;
                    Resources.get($stateParams,
                        function (data) {
                            if (Auth.isLoggedIn && data.instance.user.id === Auth.user.id) {
                                res = data.instance;
                            }
                        },
                        function (data) {

                        });
                    if (res) {
                        return res;
                    }
                    $state.go('resources.search', {}, {location: true});
                    return $q.reject('asdas');
                }]
            }*/
        })
        .state('user', {
            templateUrl: '/assets/search.html',
            controller: 'SearchCtrl',
            url: '/me/'
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
