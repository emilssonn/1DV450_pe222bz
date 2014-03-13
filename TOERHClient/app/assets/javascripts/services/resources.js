/*global angular */

angular.module('TOERH.services').factory('Resources', ['$resource', function ($resource) {
    'use strict';

    return $resource('/resources.json/:id', {}, {
        'get': { method: 'GET', params: {id: '@id'} },
        'create': { method: 'POST' },
        'query': { method: 'GET' },
        'remove': { method: 'DELETE' },
        'update': { method: 'PUT', params: {id: '@id'} },
    });
}]);