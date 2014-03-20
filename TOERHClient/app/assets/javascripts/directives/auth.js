/*global angular */

/*
Hide/Show links depending on if the user is logged in or not and 
the attribute of the element the directive is on
 */
angular.module('TOERH.directives').directive('auth', ['Auth', function (Auth) {
    'use strict';
    return {
        restrict: 'A',
        scope: {
            req: '=auth'
        },
        link: function (scope, elem, attrs) {
            var display = elem.css('display');
            //Watch if the user logs out
            scope.$watch(function () {
                return Auth.isLoggedIn();
            }, function (newVal, oldVal) {
                if ((newVal && scope.req) || (!scope.req && !newVal)) {
                    elem.css('display', display);
                } else if ((scope.req && !newVal) || (!scope.req && newVal)) {
                    elem.css('display', 'none');
                }
            });
        }
    };
}]);