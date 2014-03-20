/*global angular */

angular.module('TOERH.services').factory('Auth', ['$cookieStore', '$http', function ($cookieStore, $http) {
    'use strict';

    var key     = $cookieStore.get('key').key,
        user    = $cookieStore.get('user');

    $cookieStore.remove('key');
    $cookieStore.remove('user');

    return {
        key: key,
        user: user,
        isLoggedIn: function () {
            return !!user
        },
        logOut: function () {
            user = null;
            delete $http.defaults.headers.common.Authorization;
            $http.delete('http://lvh.me:3000/signout')
                .success(function(data, status, headers, config) {
                    return true;
                })
                .error(function(data, status, headers, config) {
                    return false;
                });
            
        }
    };
}]);