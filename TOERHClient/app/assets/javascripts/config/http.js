/*global angular */

angular.module('TOERH').config(['$httpProvider', 'APIURL', function ($httpProvider, APIURL) {
    'use strict';

    //Enable cross domain calls
    $httpProvider.defaults.useXDomain = true;
    //Remove the header used to identify ajax calls
    delete $httpProvider.defaults.headers.common['X-Requested-With'];

    $httpProvider.defaults.headers.common.Accept = 'application/json';

    $httpProvider.interceptors.push(['$q', function ($q) {
        return {
            request: function (config) {
                config.url = ~ config.url.indexOf('.html') || ~ config.url.indexOf('http') ? config.url : APIURL + config.url;
                return config || $q.when(config);
            }
        };
    }]);

}]).run(['$http', 'Auth', function ($http, Auth) {
    'use strict';

    $http.defaults.headers.common['X-CLIENT-ID'] = Auth.key;

    if (Auth.isLoggedIn()) {
        $http.defaults.headers.common.Authorization = 'Bearer ' + Auth.user.token;
    }
}]);