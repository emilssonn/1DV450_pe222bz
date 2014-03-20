/*global angular */

angular.module('TOERH.filters').filter('sorter', function () {
    'use strict';

    return function (list, searchProp, string) {
        if (!searchProp || string === undefined) {
            return list;
        }

        searchProp = angular.lowercase(searchProp);

        //http://stackoverflow.com/a/8052100
        var getDescendantProp = function (obj, desc) {
            var arr = desc.split(".");
            while(arr.length && (obj = obj[arr.shift()]));
            return obj;
        };

        return list.filter(function (value) {
            if (~searchProp.indexOf('.')) {
                value = getDescendantProp(value, searchProp);
            } else {
                value = angular.lowercase(value[searchProp]);
            }
            if (angular.isArray(value)) {
                return value.filter(function (val) {
                    return ~val.indexOf(string);
                }).length > 0;
            }
            return ~value.indexOf(string);
        });
    };
});