/*global angular */

angular.module('TOERH').config(['$stateProvider', '$urlRouterProvider', function ($stateProvider, $urlRouterProvider) {
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
                        deferred.reject({status: 403});
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
            template: '<div data-ui-view></div>',
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
            url: '',
            data: {
                user: false
            }
        })
        .state('resources.create', {
            templateUrl: '/assets/resourceForm.html',
            controller: 'ResourceCtrl',
            url: 'new/',
            resolve: {
                resource: function () { return null; }
            },
            data: {
                user: true
            }
        })
        .state('resources.show', {
            templateUrl: '/assets/resource.html',
            controller: 'ResourceCtrl',
            url: 'show/:id/',
            resolve: {
                resource: ['Resources', '$stateParams', '$q', function (Resources, $stateParams, $q) {
                    return loadData($q, Resources, $stateParams);
                }]
            },
            data: {
                user: false
            }
        })
        .state('resources.edit', {
            templateUrl: '/assets/resourceForm.html',
            controller: 'ResourceCtrl',
            url: 'edit/:id/',
            resolve: {
                resource: ['Resources', '$stateParams', '$q', 'Auth', function (Resources, $stateParams, $q, Auth) {
                    return loadData($q, Resources, $stateParams, Auth);
                }]
            },
            data: {
                user: true
            }
        })
        .state('resources.me', {
            templateUrl: '/assets/resources.html',
            controller: 'UserResourcesCtrl',
            url: 'me/',
            data: {
                user: true
            }
        })
        .state('logout', {
            controller: ['$state', 'Auth', 'Alert', function ($state, Auth, Alert) {
                Auth.logOut();
                Alert.success({message: 'You have been logged out.', msgScope: 'user'});
                $state.go('resources.search');
            }],
            data: {
                user: true
            }
        });

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

}]).run(['$rootScope', '$state', 'Auth', 'Alert', '$location', function ($rootScope, $state, Auth, Alert, $location) {

    //Check if state is public
    $rootScope.$on("$stateChangeStart", function (event, toState, toParams, fromState, fromParams) {
        if (toState.data.user && !Auth.isLoggedIn()) {
            event.preventDefault();
            Alert.warning({message: 'You need to be logged in to view "' + $location.absUrl() + '".', msgScope: 'route', clearScope: true});
            if (fromState.abstract) {
                $state.go('resources.search');
            }
        }
    });

    //The state failed to load, check what error and "redirect"
    $rootScope.$on("$stateChangeError", function (event, toState, toParams, fromState, fromParams, error) {
        event.preventDefault();
        if (error.status === 401) {
            Alert.warning({message: 'Your session has expired. Please log in again to continue.', msgScope: 'route', clearScope: true});
        } else if (error.status === 403) {
            Alert.danger({message: 'You dont have permission to edit this resource.', msgScope: 'route', clearScope: true});
        } else if (error.status === 404) {
            Alert.warning({message: 'The requested resource was not found.', msgScope: 'route', clearScope: true});
        } else if (error.status === 429) {
            Alert.warning({message: 'The site is currently overloaded, please check back later or sign in to continue.', msgScope: 'route', clearScope: true});
        } else if (error.status === 500) {
            Alert.danger({message: 'Something broke, please try again. If the this error continues, please check back later.', msgScope: 'route', clearScope: true});
        } else {
            Alert.warning({message: 'Something unexpected happend. Please try again or check back later.', msgScope: 'route', clearScope: true});
        }

        if (fromState.abstract) {
            $state.go('resources.search');
        } else {
            $state.go(fromState, fromParams);
        }
    });
}]);
