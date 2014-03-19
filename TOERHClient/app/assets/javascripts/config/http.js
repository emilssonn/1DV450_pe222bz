/*global angular */

angular.module('TOERH').config(['$httpProvider', '$provide', 'APIURL', function ($httpProvider, $provide, APIURL) {
    'use strict';

    //Enable cross domain calls
    $httpProvider.defaults.useXDomain = true;
    //Remove the header used to identify ajax calls
    delete $httpProvider.defaults.headers.common['X-Requested-With'];

    $httpProvider.defaults.headers.common.Accept = 'application/json';

    $httpProvider.interceptors.push(['$q', function ($q) {
        return {
            request: function (config) {
                config.url = ~ config.url.indexOf('.html') ? config.url : APIURL + config.url;
                return config || $q.when(config);
            }
        };
    }]);

    $provide.factory('APIResponse', function($q) {
        return {
            'responseError': function(response) {
                if (response.status === 429) {

                } else if (response.status === 500) {

                } else if (response.status === 403) {

                }
                return $q.reject(response);
            }
        };
    });

    $httpProvider.interceptors.push('APIResponse');

}]).run(['$http', 'Auth', function ($http, Auth) {
    'use strict';

    $http.defaults.headers.common['X-CLIENT-ID'] = Auth.key;

    if (Auth.isLoggedIn) {
        $http.defaults.headers.common.Authorization = 'Bearer ' + Auth.user.token;
    }
}]);