/*global angular */

angular.module('TOERH.services').factory('Licenses', ['$resource', function ($resource) {
    'use strict';

    return $resource('/licenses/:id', {}, {
        'get': { method: 'GET', params: {id: '@id'} }
    });
}]);