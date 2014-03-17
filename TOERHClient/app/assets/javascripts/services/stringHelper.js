/*global angular */

angular.module('TOERH.services').service('StringHelper', [function () {
    'use strict';

    this.toUnderscore = function (val) {
        return val.replace(/([A-Z])/g, function ($1) {
            return "_" + $1.toLowerCase();
        });
    };
}]);