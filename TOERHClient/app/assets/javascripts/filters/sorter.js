/*global angular */

angular.module('TOERH.filters').filter('sorter', function () {
    'use strict';

    return function (list, searchProp, string) {
        if (!searchProp || string === undefined) {
            return list;
        }

        return list.filter(function (value) {
            return ~angular.lowercase(value[angular.lowercase(searchProp)]).indexOf(string);
        });
    };
});