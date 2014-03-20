/*global angular */

angular.module('TOERH.services').factory('Alert', ['$timeout', function ($timeout) {
    'use strict';

    //Creates a message
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

    //Creates a Alert
    Alert = function (params) {
        angular.extend(this, {
            type: params.type,
            time: params.msgTypeTime,
            messages: []
        }, params);
    },

    alerts = [],

    //Remove a alert and cancels all active timeouts on the alert and messages
    removeAlert = function (type) {
        angular.forEach(alerts, function (value, index) {
            if (value.type === type) {
                angular.forEach(value.messages, function (value2, index2) {
                    $timeout.cancel(value2.timeout);
                });
                $timeout.cancel(value.timeout);
                alerts.splice(index, 1);
            } 
        });
    },

    //Add a alert and set timeout if needed
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

    //Add a message
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

        //Check if a alert of the same type already created
        var ix = alerts.map(
            function (a) {
                return a.type
            }).indexOf(msg.type);
        var cAlert;
        ~ix ? (cAlert = alerts[ix]) : (cAlert = null);
        
        if (!cAlert) {
            //Create alert
            cAlert = addAlert(msg.type, msg.msgTypeTime)
        } else if (cAlert.timeout) {
            $timeout.cancel(cAlert.timeout);
            if (msg.msgTypeTime > 0) {
                cAlert.timeout = $timeout(function () {
                    removeAlert(msg.type);
                }, msg.msgTypeTime);
            }
        }

        cAlert.messages.push(msg);
    },

    removeAllAlerts = function () {
        //Cancel all timeouts
        angular.forEach(alerts, function (value, index) {
            angular.forEach(value.messages, function (value2, index2) {
                $timeout.cancel(value2.timeout);
            });
            $timeout.cancel(value.timeout);
        });
        alerts = [];
    },

    //Remove all messages within a specific scope
    clearScope = function (scope) {
        //Cancel all timeouts
        angular.forEach(alerts, function (value, index) {
            angular.forEach(value.messages, function (value2, index2) {
                if (value2.msgScope === scope) {
                    $timeout.cancel(value2.timeout);
                    value.messages.splice(index2, 1);
                }
            });
        });
    },

    //Clear all messages within a specific scope and a specific type
    clearScopeByType = function (scope, type) {
        //Cancel all timeouts
        angular.forEach(alerts, function (value, index) {
            angular.forEach(value.messages, function (value2, index2) {
                if (value2.msgScope === scope && value2.type === type) {
                    $timeout.cancel(value2.timeout);
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