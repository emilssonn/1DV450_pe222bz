/*global angular */

angular.module('TOERH.services').factory('Auth', ['$cookieStore', function ($cookieStore) {
    'use strict';

    var key     = $cookieStore.get('key'),
        user    = $cookieStore.get('user');

    $cookieStore.remove('key').remove('user');

    return {
        key: key,
        user: user,
        isLoggedIn: function () {
            return !!user;
        }
    };
}]);