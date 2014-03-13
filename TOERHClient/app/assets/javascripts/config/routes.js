/*global angular */

angular.module('TOERH').config(['$stateProvider', '$urlRouterProvider', '$locationProvider', function ($stateProvider, $urlRouterProvider, $locationProvider) {
    'use strict';

    $urlRouterProvider
        .otherwise('/explore/');

    $stateProvider
        .state('resources', {
            templateUrl: '/assets/home.html',
            abstract: true,
            url: '/explore/'
        })
        .state('resources.search', {
            templateUrl: '/assets/search.html',
            controller: 'SearchCtrl',
            url: ''
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
