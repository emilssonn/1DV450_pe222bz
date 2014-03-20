/*global angular */

angular.module('TOERH').config(['$httpProvider', '$provide', 'APIURL', function ($httpProvider, $provide, APIURL) {
    'use strict';

    //Enable cross domain calls
    $httpProvider.defaults.useXDomain = true;
    //Remove the header used to identify ajax calls
    delete $httpProvider.defaults.headers.common['X-Requested-With'];

    $httpProvider.defaults.headers.common.Accept = 'application/json';

    $httpProvider.interceptors.push(['$q', '$injector', function ($q, $injector) {
        return {
            //Config api url
            request: function (config) {
                config.url = ~ config.url.indexOf('.html') || ~ config.url.indexOf('http') ? config.url : APIURL + config.url;
                return config || $q.when(config);
            },
            //Check if response is 401, session has expired
            responseError: function (rejection) {
                var Auth = $injector.get('Auth'),
                    Alert = $injector.get('Alert');
                if (rejection.status === 401) {
                    Alert.warning({message: 'Your session has expired. Please log in again to continue.', msgScope: 'route', clearScope: true});
                    Auth.logOut();
                }
                return $q.reject(rejection);
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