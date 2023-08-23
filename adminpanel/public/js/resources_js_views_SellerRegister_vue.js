"use strict";
(self["webpackChunk"] = self["webpackChunk"] || []).push([["resources_js_views_SellerRegister_vue"],{

/***/ "./node_modules/babel-loader/lib/index.js??clonedRuleSet-5[0].rules[0].use[0]!./node_modules/vue-loader/lib/index.js??vue-loader-options!./resources/js/views/SellerRegister.vue?vue&type=script&lang=js&":
/*!****************************************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/babel-loader/lib/index.js??clonedRuleSet-5[0].rules[0].use[0]!./node_modules/vue-loader/lib/index.js??vue-loader-options!./resources/js/views/SellerRegister.vue?vue&type=script&lang=js& ***!
  \****************************************************************************************************************************************************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony import */ var axios__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! axios */ "./node_modules/axios/index.js");
/* harmony import */ var axios__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(axios__WEBPACK_IMPORTED_MODULE_0__);
/* harmony import */ var _Auth_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../Auth.js */ "./resources/js/Auth.js");
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//


/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ({
  data: function data() {
    return {
      isLoading: false,
      user: {
        email: 'admin@gmail.com',
        password: '123456'
      },
      loggedUser: _Auth_js__WEBPACK_IMPORTED_MODULE_1__["default"].user
    };
  },
  mounted: function mounted() {
    console.log('loggedUser');
    console.log(this.loggedUser);

    if (this.loggedUser) {//this.$router.push('/dashboard');
    }
  },
  methods: {
    loginCheck: function loginCheck() {
      var _this = this;

      var vm = this;
      this.isLoading = true;
      var url = this.$apiUrl + '/login';
      axios__WEBPACK_IMPORTED_MODULE_0___default().post(url, this.user).then(function (res) {
        vm.isLoading = false;
        var data = res.data;

        if (data.status === 1) {
          _this.updateCurrency(data.data.currency);

          _Auth_js__WEBPACK_IMPORTED_MODULE_1__["default"].login(data.data.access_token, data.data.user);

          _this.$router.push('/dashboard');
        } else {
          vm.showError(data.message);
        }
      })["catch"](function (error) {
        console.log(error);
        vm.isLoading = false;

        _this.showError("Something went wrong!");
      });
    }
  }
});

/***/ }),

/***/ "./resources/js/views/SellerRegister.vue":
/*!***********************************************!*\
  !*** ./resources/js/views/SellerRegister.vue ***!
  \***********************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony import */ var _SellerRegister_vue_vue_type_template_id_70030521___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./SellerRegister.vue?vue&type=template&id=70030521& */ "./resources/js/views/SellerRegister.vue?vue&type=template&id=70030521&");
/* harmony import */ var _SellerRegister_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./SellerRegister.vue?vue&type=script&lang=js& */ "./resources/js/views/SellerRegister.vue?vue&type=script&lang=js&");
/* harmony import */ var _node_modules_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! !../../../node_modules/vue-loader/lib/runtime/componentNormalizer.js */ "./node_modules/vue-loader/lib/runtime/componentNormalizer.js");





/* normalize component */
;
var component = (0,_node_modules_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_2__["default"])(
  _SellerRegister_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__["default"],
  _SellerRegister_vue_vue_type_template_id_70030521___WEBPACK_IMPORTED_MODULE_0__.render,
  _SellerRegister_vue_vue_type_template_id_70030521___WEBPACK_IMPORTED_MODULE_0__.staticRenderFns,
  false,
  null,
  null,
  null
  
)

/* hot reload */
if (false) { var api; }
component.options.__file = "resources/js/views/SellerRegister.vue"
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = (component.exports);

/***/ }),

/***/ "./resources/js/views/SellerRegister.vue?vue&type=script&lang=js&":
/*!************************************************************************!*\
  !*** ./resources/js/views/SellerRegister.vue?vue&type=script&lang=js& ***!
  \************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony import */ var _node_modules_babel_loader_lib_index_js_clonedRuleSet_5_0_rules_0_use_0_node_modules_vue_loader_lib_index_js_vue_loader_options_SellerRegister_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../node_modules/babel-loader/lib/index.js??clonedRuleSet-5[0].rules[0].use[0]!../../../node_modules/vue-loader/lib/index.js??vue-loader-options!./SellerRegister.vue?vue&type=script&lang=js& */ "./node_modules/babel-loader/lib/index.js??clonedRuleSet-5[0].rules[0].use[0]!./node_modules/vue-loader/lib/index.js??vue-loader-options!./resources/js/views/SellerRegister.vue?vue&type=script&lang=js&");
 /* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = (_node_modules_babel_loader_lib_index_js_clonedRuleSet_5_0_rules_0_use_0_node_modules_vue_loader_lib_index_js_vue_loader_options_SellerRegister_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__["default"]); 

/***/ }),

/***/ "./resources/js/views/SellerRegister.vue?vue&type=template&id=70030521&":
/*!******************************************************************************!*\
  !*** ./resources/js/views/SellerRegister.vue?vue&type=template&id=70030521& ***!
  \******************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "render": () => (/* reexport safe */ _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_SellerRegister_vue_vue_type_template_id_70030521___WEBPACK_IMPORTED_MODULE_0__.render),
/* harmony export */   "staticRenderFns": () => (/* reexport safe */ _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_SellerRegister_vue_vue_type_template_id_70030521___WEBPACK_IMPORTED_MODULE_0__.staticRenderFns)
/* harmony export */ });
/* harmony import */ var _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_SellerRegister_vue_vue_type_template_id_70030521___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!../../../node_modules/vue-loader/lib/index.js??vue-loader-options!./SellerRegister.vue?vue&type=template&id=70030521& */ "./node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!./node_modules/vue-loader/lib/index.js??vue-loader-options!./resources/js/views/SellerRegister.vue?vue&type=template&id=70030521&");


/***/ }),

/***/ "./node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!./node_modules/vue-loader/lib/index.js??vue-loader-options!./resources/js/views/SellerRegister.vue?vue&type=template&id=70030521&":
/*!*********************************************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!./node_modules/vue-loader/lib/index.js??vue-loader-options!./resources/js/views/SellerRegister.vue?vue&type=template&id=70030521& ***!
  \*********************************************************************************************************************************************************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "render": () => (/* binding */ render),
/* harmony export */   "staticRenderFns": () => (/* binding */ staticRenderFns)
/* harmony export */ });
var render = function () {
  var _vm = this
  var _h = _vm.$createElement
  var _c = _vm._self._c || _h
  return _c("div", { attrs: { id: "auth" } }, [
    _c("div", { staticClass: "row h-100" }, [
      _c("div", { staticClass: "col-lg-8 col-12" }, [
        _c("div", { attrs: { id: "auth-left" } }, [
          _vm._m(0),
          _vm._v(" "),
          _c("h1", { staticClass: "auth-title" }, [_vm._v("Sign Up")]),
          _vm._v(" "),
          _c("p", { staticClass: "auth-subtitle mb-5" }, [
            _vm._v("Input your data to register to our website."),
          ]),
          _vm._v(" "),
          _c(
            "form",
            {
              ref: "my-form",
              on: {
                submit: function ($event) {
                  $event.preventDefault()
                  return _vm.loginCheck.apply(null, arguments)
                },
              },
            },
            [
              _c("div", { staticClass: "row" }, [
                _c(
                  "div",
                  {
                    staticClass:
                      "form-group position-relative has-icon-left mb-4",
                  },
                  [
                    _c("input", {
                      directives: [
                        {
                          name: "model",
                          rawName: "v-model",
                          value: _vm.user.email,
                          expression: "user.email",
                        },
                      ],
                      staticClass: "form-control form-control-xl",
                      attrs: {
                        type: "text",
                        placeholder: "Name",
                        required: "",
                      },
                      domProps: { value: _vm.user.email },
                      on: {
                        input: function ($event) {
                          if ($event.target.composing) {
                            return
                          }
                          _vm.$set(_vm.user, "email", $event.target.value)
                        },
                      },
                    }),
                  ]
                ),
                _vm._v(" "),
                _c("div", { staticClass: "form-group col-md-4" }, [
                  _c("div", { staticClass: "form-group" }, [
                    _c("label", [_vm._v("Email")]),
                    _vm._v(" "),
                    _c("input", {
                      directives: [
                        {
                          name: "model",
                          rawName: "v-model",
                          value: _vm.email,
                          expression: "email",
                        },
                      ],
                      staticClass: "form-control",
                      attrs: {
                        type: "email",
                        required: "",
                        placeholder: "Enter email.",
                      },
                      domProps: { value: _vm.email },
                      on: {
                        input: function ($event) {
                          if ($event.target.composing) {
                            return
                          }
                          _vm.email = $event.target.value
                        },
                      },
                    }),
                  ]),
                ]),
                _vm._v(" "),
                _c("div", { staticClass: "form-group col-md-4" }, [
                  _c("div", { staticClass: "form-group" }, [
                    _c("label", [_vm._v("Mobile")]),
                    _vm._v(" "),
                    _c("input", {
                      directives: [
                        {
                          name: "model",
                          rawName: "v-model",
                          value: _vm.mobile,
                          expression: "mobile",
                        },
                      ],
                      staticClass: "form-control",
                      attrs: {
                        type: "number",
                        required: "",
                        placeholder: "Enter mobile number",
                      },
                      domProps: { value: _vm.mobile },
                      on: {
                        input: function ($event) {
                          if ($event.target.composing) {
                            return
                          }
                          _vm.mobile = $event.target.value
                        },
                      },
                    }),
                  ]),
                ]),
                _vm._v(" "),
                _c("div", { staticClass: "form-group col-md-4" }, [
                  _c("div", { staticClass: "form-group" }, [
                    _c("label", [_vm._v("Password")]),
                    _vm._v(" "),
                    !_vm.id
                      ? _c("input", {
                          directives: [
                            {
                              name: "model",
                              rawName: "v-model",
                              value: _vm.password,
                              expression: "password",
                            },
                          ],
                          staticClass: "form-control",
                          attrs: {
                            type: "password",
                            required: "",
                            placeholder: "Enter password.",
                          },
                          domProps: { value: _vm.password },
                          on: {
                            input: function ($event) {
                              if ($event.target.composing) {
                                return
                              }
                              _vm.password = $event.target.value
                            },
                          },
                        })
                      : _vm._e(),
                    _vm._v(" "),
                    _vm.id
                      ? _c("input", {
                          directives: [
                            {
                              name: "model",
                              rawName: "v-model",
                              value: _vm.password,
                              expression: "password",
                            },
                          ],
                          staticClass: "form-control",
                          attrs: {
                            type: "password",
                            placeholder: "Enter password.",
                          },
                          domProps: { value: _vm.password },
                          on: {
                            input: function ($event) {
                              if ($event.target.composing) {
                                return
                              }
                              _vm.password = $event.target.value
                            },
                          },
                        })
                      : _vm._e(),
                  ]),
                ]),
                _vm._v(" "),
                _c("div", { staticClass: "form-group col-md-4" }, [
                  _c("div", { staticClass: "form-group" }, [
                    _c("label", [_vm._v("Confirm Password")]),
                    _vm._v(" "),
                    !_vm.id
                      ? _c("input", {
                          directives: [
                            {
                              name: "model",
                              rawName: "v-model",
                              value: _vm.confirm_password,
                              expression: "confirm_password",
                            },
                          ],
                          staticClass: "form-control",
                          attrs: {
                            type: "password",
                            required: "",
                            placeholder: "Enter confirm password.",
                          },
                          domProps: { value: _vm.confirm_password },
                          on: {
                            input: function ($event) {
                              if ($event.target.composing) {
                                return
                              }
                              _vm.confirm_password = $event.target.value
                            },
                          },
                        })
                      : _vm._e(),
                    _vm._v(" "),
                    _vm.id
                      ? _c("input", {
                          directives: [
                            {
                              name: "model",
                              rawName: "v-model",
                              value: _vm.confirm_password,
                              expression: "confirm_password",
                            },
                          ],
                          staticClass: "form-control",
                          attrs: {
                            type: "password",
                            placeholder: "Enter confirm password.",
                          },
                          domProps: { value: _vm.confirm_password },
                          on: {
                            input: function ($event) {
                              if ($event.target.composing) {
                                return
                              }
                              _vm.confirm_password = $event.target.value
                            },
                          },
                        })
                      : _vm._e(),
                  ]),
                ]),
              ]),
            ]
          ),
        ]),
      ]),
      _vm._v(" "),
      _vm._m(1),
    ]),
  ])
}
var staticRenderFns = [
  function () {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("div", { staticClass: "auth-logo" }, [
      _c("a", { attrs: { href: "/" } }, [
        _vm._v(
          "\n                           eGrocer | Seller\n                        "
        ),
      ]),
    ])
  },
  function () {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("div", { staticClass: "col-lg-4 d-none d-lg-block" }, [
      _c("div", { attrs: { id: "auth-right" } }),
    ])
  },
]
render._withStripped = true



/***/ })

}]);