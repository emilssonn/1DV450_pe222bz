/*global angular */

angular.module('TOERH.services').factory('ResourceTypes', ['$resource', function ($resource) {
    'use strict';

    return $resource('/resource_types/:id', {}, {
        'get': { method: 'GET', params: {id: '@id'}, cache: true }
    });
}]);