/*global angular */

angular.module('TOERH').config(['$httpProvider', 'APIURL', function ($httpProvider, APIURL) {
    'use strict';

    //Enable cross domain calls
    $httpProvider.defaults.useXDomain = true;

    //Remove the header used to identify ajax calls
    delete $httpProvider.defaults.headers.common['X-Requested-With'];

    //fix
    $httpProvider.defaults.headers.common['X-CLIENT-ID'] = 'dbfb4187d7209f31e08d7d0552235778ebca62312670919209d85dca1ecbf727';
    $httpProvider.defaults.headers.common['Accept'] = 'application/json';

    $httpProvider.interceptors.push(['$q', function ($q) {
        return {
            request: function (config) {
                config.url = config.url.indexOf('.html') !== -1 ? config.url : APIURL + config.url;
                return config || $q.when(config);
            },
            response: function (response) {
                return response || $q.when(response);
            }
        };
    }]);

}]);