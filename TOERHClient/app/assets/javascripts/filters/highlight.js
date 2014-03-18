/*global angular */

angular.module('TOERH.filters').filter('Highlight', function () {
    'use strict';

    return function (text, q) {
        if (!q) {
            return text;
        }
        return text.replace(new RegExp(q, 'gi'), '<span class="highlight">$&</span>');
    };
});