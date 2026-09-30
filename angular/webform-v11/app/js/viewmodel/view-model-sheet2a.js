
(function() {
    angular.module('FGases.viewmodel').factory('ViewModelSheet2a', [

        'ViewModelObjectBase', 'ViewModelSheet2aSection5a', 'objectUtil',

        function (ViewModelObjectBase, ViewModelSheet2aSection5a, objectUtil) {

            function ViewModelSheet2a(viewModel) {
                if (!(this instanceof ViewModelSheet2a)) {
                    return new ViewModelSheet2a(viewModel);
                }

                ViewModelObjectBase.call(this, viewModel);
                this.section5 = new ViewModelSheet2aSection5a(this);
            }

            objectUtil.chainConstructor(ViewModelObjectBase, ViewModelSheet2a);

            return ViewModelSheet2a;
        }
    ]).factory('ViewModelSheet2aSection5a', [

        'ViewModelSectionBase', 'sheet2aValidator', 'gasHelper', 'objectUtil', 'arrayUtil',

        function (ViewModelSectionBase, sheet2aValidator, gasHelper, objectUtil, arrayUtil) {

            function ViewModelSheet2aSection5a(sheet2aViewModel) {
                if (!(this instanceof ViewModelSheet2aSection5a)) {
                    return new ViewModelSheet2aSection5a(sheet2aViewModel);
                }

                ViewModelSectionBase.call(this, sheet2aViewModel);
            }

            objectUtil.chainConstructor(ViewModelSectionBase, ViewModelSheet2aSection5a);

            ViewModelSheet2aSection5a.prototype.getSectionData = function () {
                return this.getRoot().getDataSource().FGasesReporting.F2a_S5a_exempted_HFCs;
            };

            return ViewModelSheet2aSection5a;
        }
    ]);
})();
