/*global angular */

/*
Highlights part of the text depending on the value of q
 */
angular.module('TOERH.filters').filter('Highlight', function () {
    'use strict';
    /**
     * @param  {string} text        text to search for match
     * @param  {string} q           text to match
     * @param  {string} searchProp  prop filter is placed on
     * @param  {type} currentProp current prop being search on
     * @return {string}             
     */
    return function (text, q, searchProp, currentProp) {
        if (!q || (searchProp !== currentProp)) {
            return text;
        }

        return text.replace(new RegExp(q, 'gi'), '<span class="highlight">$&</span>');
    };
});