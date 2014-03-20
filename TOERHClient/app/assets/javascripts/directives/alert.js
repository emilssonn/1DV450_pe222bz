/*global angular */

/*
Adds the markup for the alerter
 */
angular.module('TOERH.directives').directive('alerter', ['Alert', function (Alert) {
    'use strict';

    return {
        restrict: 'EA',
        templateUrl: 'assets/alert.html',
        replace: true,
        link: function (scope, elem, attrs) {
            scope.alerts = Alert.alerts;
            scope.close = function ($index) {
                Alert.alerts.splice($index, 1);
            };
        }
    };
}]);