
(function() {
    //Includes method to focus and element with id
    angular.module('FGases.services.ui').factory('highlight', function($timeout) {
        return function(id, is_blocker) {
            $timeout(function() {
                var element = document.getElementById(id);
                if (element) {
                    let css_classes = ["alert", is_blocker ? "alert-danger" : "alert-warning"];
                    css_classes.forEach(css_class => element.classList.toggle(css_class));
                    $timeout(() => {
                        css_classes.forEach(css_class => element.classList.toggle(css_class));
                    }, 1000);
                }
            });
        };
    });
})();
