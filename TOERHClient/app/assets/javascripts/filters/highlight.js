/*global angular */

angular.module('TOERH.filters').filter('Highlight', function () {
    'use strict';

    return function (text, q, searchProp, currentProp) {
        if (!q || (searchProp !== currentProp)) {
            return text;
        }

        return text.replace(new RegExp(q, 'gi'), '<span class="highlight">$&</span>');
    };
});