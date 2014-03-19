/*global angular */

angular.module('TOERH.services').factory('Alert', ['$timeout', function ($timeout) {
    'use strict';

    var Message = function (params) {
        angular.extend(this, {
            message: null,
            type: 'info',
            msgScope: '',
            msgTime: 10000,
            msgScopeTime: 10000,
            msgTypeTime: 10000,
            clearAlert: false,
            clearScope: false,
            clearScopeError: false,
            clearScopeSuccess: false,
            clearScopeWarning: false,
            clearScopeInfo: false,
            clearAll: false,
            clearErrorAlert: false,
            clearSuccessAlert: false,
            clearWarningAlert: false,
            clearInfoAlert: false
        }, params);
    },

    Alert = function (params) {
        angular.extend(this, {
            type: params.type,
            time: params.msgTypeTime,
            messages: []
        }, params);
    },

    alerts = [],

    removeAlert = function (type) {
        angular.forEach(alerts, function (value, index) {
            if (value.type === type) {
                angular.forEach(value.messages, function (value, index2) {
                    $timeout.cancel(value.timeout);
                });
                $timeout.cancel(value.timeout);
                alerts.splice(index, 1);
            } 
        });
    },

    addAlert = function (type, time) {
        var a = new Alert({
            type: type, 
            time: time
        });
        if (a.time > 0) {
            a.timeout = $timeout(function () {
                removeAlert(type);
            }, time);
        }
        alerts.push(a);
        return a;
    },

    addMessage = function (msg) {
        if (msg.clearAll === true) {
            removeAllAlerts();
        } else {
            if (msg.clearScope === true) {
                clearScope(msg.msgScope);
            } else {
                if (msg.clearScopeError === true) {
                    clearScopeByType(msg.msgScope, 'danger');
                }
                if (msg.clearScopeSuccess === true) {
                    clearScopeByType(msg.msgScope, 'success');
                }
                if (msg.clearScopeWarning === true) {
                    clearScopeByType(msg.msgScope, 'warning');
                }
                if (msg.clearScopeInfo === true) {
                    clearScopeByType(msg.msgScope, 'info');
                }
            }
            if (msg.clearAlert === true) {
                removeAlert(msg.type);
            }
            if (msg.clearErrorAlert === true) {
                removeAlert('danger');
            }
            if (msg.clearSuccessAlert === true) {
                removeAlert('success');
            }
            if (msg.clearWarningAlert === true) {
                removeAlert('warning');
            }
            if (msg.clearInfoAlert === true) {
                removeAlert('info');
            }
        }

        var ix = alerts.map(
            function (a) {
                return a.type
            }).indexOf(msg.type);
        var cAlert;
        ~ix ? (cAlert = alerts[ix]) : (cAlert = null);
        
        if (!cAlert) {
            cAlert = addAlert(msg.type, msg.msgTypeTime)
        } else if (cAlert.timeout) {
            $timeout.cancel(cAlert.timeout);
        }
        if (msg.msgTypeTime > 0) {
            cAlert.timeout = $timeout(function () {
                removeAlert(msg.type);
            }, msg.msgTypeTime);
        }
        cAlert.messages.push(msg);
    },

    removeMessage = function (msg) {

    },

    removeAllAlerts = function () {
        //Cancel all timeouts
        angular.forEach(alerts, function (value, index) {
            angular.forEach(value.messages, function (value, index2) {
                $timeout.cancel(value.timeout);
            });
            $timeout.cancel(value.timeout);
        });
        alerts = [];
    },

    clearScope = function (scope) {
        //Cancel all timeouts
        angular.forEach(alerts, function (value, index) {
            angular.forEach(value.messages, function (value, index2) {
                if (msg.msgScope === scope) {
                    $timeout.cancel(value.timeout);
                    value.messages.splice(index2, 1);
                }
            });
        });
    },

    clearScopeByType = function (scope, type) {
        //Cancel all timeouts
        angular.forEach(alerts, function (value, index) {
            angular.forEach(value.messages, function (value, index2) {
                if (msg.msgScope === scope && msg.type === type) {
                    $timeout.cancel(value.timeout);
                    value.messages.splice(index2, 1);
                }
            });
        });
    };



    return {
        warning: function (msg) {
            msg.type = 'warning';
            addMessage(new Message(msg));
        },
        danger: function (msg) {
            msg.type = 'danger';
            addMessage(new Message(msg));
        },
        info: function (msg) {
            msg.type = 'info';
            addMessage(new Message(msg));
        },
        success: function (msg) {
            msg.type = 'success';
            addMessage(new Message(msg));
        },
        alerts: alerts
    };
}]);