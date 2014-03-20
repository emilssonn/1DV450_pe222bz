/*global angular */

angular.module('TOERH.filters').filter('sorter', function () {
    'use strict';

    return function (list, searchProp, string) {
        if (!searchProp || string === undefined) {
            return list;
        }

        searchProp = angular.lowercase(searchProp);

        //Filter the list to only show matching objects
        //If the value being targeted for filtering is a array, check for match on each value in array
        return list.filter(function (value) {
            value = angular.lowercase(value[searchProp]);
            if (angular.isArray(value)) {
                return value.filter(function (val) {
                    return ~val.indexOf(string);
                }).length > 0;
            }
            return ~value.indexOf(string);
        });
    };
});