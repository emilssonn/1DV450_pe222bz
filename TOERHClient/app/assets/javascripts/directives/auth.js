/*global angular */

angular.module('TOERH.directives').directive('auth', ['Auth', function (Auth) {
    return {
        restrict: 'A',
        scope: {
            req: '=auth'
        },
        link: function (scope, elem, attrs) {
            var display = elem.css('display')
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