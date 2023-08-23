"use strict";
(self["webpackChunk"] = self["webpackChunk"] || []).push([["resources_js_views_DeliveryBoy_DeliveryBoyRegister_vue"],{

/***/ "./node_modules/babel-loader/lib/index.js??clonedRuleSet-5[0].rules[0].use[0]!./node_modules/vue-loader/lib/index.js??vue-loader-options!./resources/js/views/DeliveryBoy/DeliveryBoyRegister.vue?vue&type=script&lang=js&":
/*!*********************************************************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/babel-loader/lib/index.js??clonedRuleSet-5[0].rules[0].use[0]!./node_modules/vue-loader/lib/index.js??vue-loader-options!./resources/js/views/DeliveryBoy/DeliveryBoyRegister.vue?vue&type=script&lang=js& ***!
  \*********************************************************************************************************************************************************************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony import */ var axios__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! axios */ "./node_modules/axios/index.js");
/* harmony import */ var axios__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(axios__WEBPACK_IMPORTED_MODULE_0__);
/* harmony import */ var _Auth_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../../Auth.js */ "./resources/js/Auth.js");
/* harmony import */ var vuelidate_lib_validators__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! vuelidate/lib/validators */ "./node_modules/vuelidate/lib/validators/index.js");
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



var onlyDigits = vuelidate_lib_validators__WEBPACK_IMPORTED_MODULE_2__.helpers.regex('onlyDigits', /^\d+$/);
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ({
  data: function data() {
    return {
      isLoading: false,
      showPassword: false,
      showConfirmPassword: false,
      delivery_boy: {
        username: '',
        email: '',
        mobile: '',
        password: '',
        password_confirmation: ''
      },
      submitStatus: null,
      loggedUser: _Auth_js__WEBPACK_IMPORTED_MODULE_1__["default"].user
    };
  },
  validations: {
    delivery_boy: {
      username: {
        required: vuelidate_lib_validators__WEBPACK_IMPORTED_MODULE_2__.required
      },
      email: {
        required: vuelidate_lib_validators__WEBPACK_IMPORTED_MODULE_2__.required,
        email: vuelidate_lib_validators__WEBPACK_IMPORTED_MODULE_2__.email
      },
      mobile: {
        required: vuelidate_lib_validators__WEBPACK_IMPORTED_MODULE_2__.required,
        numeric: vuelidate_lib_validators__WEBPACK_IMPORTED_MODULE_2__.numeric,
        minLength: (0,vuelidate_lib_validators__WEBPACK_IMPORTED_MODULE_2__.minLength)(8),
        onlyDigits: onlyDigits
      },
      password: {
        required: vuelidate_lib_validators__WEBPACK_IMPORTED_MODULE_2__.required,
        minLength: (0,vuelidate_lib_validators__WEBPACK_IMPORTED_MODULE_2__.minLength)(6)
      },
      password_confirmation: {
        sameAsPassword: (0,vuelidate_lib_validators__WEBPACK_IMPORTED_MODULE_2__.sameAs)('password')
      }
    }
  },
  mounted: function mounted() {
    if (this.loggedUser) {
      this.$router.push('/dashboard');
    }
  },
  methods: {
    registerDeliveryBoy: function registerDeliveryBoy() {
      var _this = this;

      var vm = this;
      this.isLoading = true;
      console.log('submit!');
      this.$v.$touch();

      if (this.$v.$invalid) {
        this.submitStatus = 'ERROR';
        vm.isLoading = false;
      } else {
        // do your submit logic here
        this.submitStatus = 'PENDING';
        setTimeout(function () {
          var url = _this.$apiUrl + '/delivery_boy/register';
          axios__WEBPACK_IMPORTED_MODULE_0___default().post(url, _this.delivery_boy).then(function (res) {
            vm.isLoading = false;
            var data = res.data;

            if (data.status === 1) {
              _this.submitStatus = 'SUCCESS';

              _this.showMessage("success", data.message);

              setTimeout(function () {
                _this.$router.push('/delivery_boy/login');
              }, 1000);
            } else {
              _this.submitStatus = null;
              vm.showError(data.message);
            }
          })["catch"](function (error) {
            console.log(error);
            _this.submitStatus = null;
            vm.isLoading = false;

            if (error.request.statusText) {
              _this.showError(error.request.statusText);
            } else if (error.message) {
              _this.showError(error.message);
            } else {
              _this.showError(__('something_went_wrong'));
            }
          });
        }, 500);
      }
    }
  }
});

/***/ }),

/***/ "./resources/js/views/DeliveryBoy/DeliveryBoyRegister.vue":
/*!****************************************************************!*\
  !*** ./resources/js/views/DeliveryBoy/DeliveryBoyRegister.vue ***!
  \****************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony import */ var _DeliveryBoyRegister_vue_vue_type_template_id_7e2c5896___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./DeliveryBoyRegister.vue?vue&type=template&id=7e2c5896& */ "./resources/js/views/DeliveryBoy/DeliveryBoyRegister.vue?vue&type=template&id=7e2c5896&");
/* harmony import */ var _DeliveryBoyRegister_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./DeliveryBoyRegister.vue?vue&type=script&lang=js& */ "./resources/js/views/DeliveryBoy/DeliveryBoyRegister.vue?vue&type=script&lang=js&");
/* harmony import */ var _node_modules_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! !../../../../node_modules/vue-loader/lib/runtime/componentNormalizer.js */ "./node_modules/vue-loader/lib/runtime/componentNormalizer.js");





/* normalize component */
;
var component = (0,_node_modules_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_2__["default"])(
  _DeliveryBoyRegister_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__["default"],
  _DeliveryBoyRegister_vue_vue_type_template_id_7e2c5896___WEBPACK_IMPORTED_MODULE_0__.render,
  _DeliveryBoyRegister_vue_vue_type_template_id_7e2c5896___WEBPACK_IMPORTED_MODULE_0__.staticRenderFns,
  false,
  null,
  null,
  null
  
)

/* hot reload */
if (false) { var api; }
component.options.__file = "resources/js/views/DeliveryBoy/DeliveryBoyRegister.vue"
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = (component.exports);

/***/ }),

/***/ "./resources/js/views/DeliveryBoy/DeliveryBoyRegister.vue?vue&type=script&lang=js&":
/*!*****************************************************************************************!*\
  !*** ./resources/js/views/DeliveryBoy/DeliveryBoyRegister.vue?vue&type=script&lang=js& ***!
  \*****************************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony import */ var _node_modules_babel_loader_lib_index_js_clonedRuleSet_5_0_rules_0_use_0_node_modules_vue_loader_lib_index_js_vue_loader_options_DeliveryBoyRegister_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../node_modules/babel-loader/lib/index.js??clonedRuleSet-5[0].rules[0].use[0]!../../../../node_modules/vue-loader/lib/index.js??vue-loader-options!./DeliveryBoyRegister.vue?vue&type=script&lang=js& */ "./node_modules/babel-loader/lib/index.js??clonedRuleSet-5[0].rules[0].use[0]!./node_modules/vue-loader/lib/index.js??vue-loader-options!./resources/js/views/DeliveryBoy/DeliveryBoyRegister.vue?vue&type=script&lang=js&");
 /* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = (_node_modules_babel_loader_lib_index_js_clonedRuleSet_5_0_rules_0_use_0_node_modules_vue_loader_lib_index_js_vue_loader_options_DeliveryBoyRegister_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__["default"]); 

/***/ }),

/***/ "./resources/js/views/DeliveryBoy/DeliveryBoyRegister.vue?vue&type=template&id=7e2c5896&":
/*!***********************************************************************************************!*\
  !*** ./resources/js/views/DeliveryBoy/DeliveryBoyRegister.vue?vue&type=template&id=7e2c5896& ***!
  \***********************************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "render": () => (/* reexport safe */ _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_DeliveryBoyRegister_vue_vue_type_template_id_7e2c5896___WEBPACK_IMPORTED_MODULE_0__.render),
/* harmony export */   "staticRenderFns": () => (/* reexport safe */ _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_DeliveryBoyRegister_vue_vue_type_template_id_7e2c5896___WEBPACK_IMPORTED_MODULE_0__.staticRenderFns)
/* harmony export */ });
/* harmony import */ var _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_DeliveryBoyRegister_vue_vue_type_template_id_7e2c5896___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!../../../../node_modules/vue-loader/lib/index.js??vue-loader-options!./DeliveryBoyRegister.vue?vue&type=template&id=7e2c5896& */ "./node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!./node_modules/vue-loader/lib/index.js??vue-loader-options!./resources/js/views/DeliveryBoy/DeliveryBoyRegister.vue?vue&type=template&id=7e2c5896&");


/***/ }),

/***/ "./node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!./node_modules/vue-loader/lib/index.js??vue-loader-options!./resources/js/views/DeliveryBoy/DeliveryBoyRegister.vue?vue&type=template&id=7e2c5896&":
/*!**************************************************************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!./node_modules/vue-loader/lib/index.js??vue-loader-options!./resources/js/views/DeliveryBoy/DeliveryBoyRegister.vue?vue&type=template&id=7e2c5896& ***!
  \**************************************************************************************************************************************************************************************************************************************/
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
  return _c("div", { staticClass: "auth" }, [
    _c("div", { staticClass: "login-wrapper" }, [
      _c("div", { staticClass: "auth-section" }, [
        _c(
          "div",
          { staticClass: "auth-back" },
          [
            _c("router-link", { attrs: { to: "/delivery_boy/login" } }, [
              _c("span", { staticClass: "fa fa-arrow-left" }),
            ]),
          ],
          1
        ),
        _vm._v(" "),
        _c("div", { staticClass: "auth-card" }, [
          _c("div", { staticClass: "auth-logo" }, [
            _c(
              "a",
              {
                staticStyle: {
                  display: "flex",
                  "align-items": "center",
                  "justify-content": "flex-start",
                },
                attrs: { href: "javascript:void(0)" },
              },
              [
                _vm.$appLogo != ""
                  ? _c("img", {
                      staticStyle: { height: "70px", width: "70px" },
                      attrs: {
                        src: _vm.$storageUrl + _vm.$appLogo,
                        alt: "Logo",
                      },
                    })
                  : _c("img", {
                      staticStyle: { height: "70px", width: "70px" },
                      attrs: {
                        src: _vm.$baseUrl + "/images/logo.png",
                        alt: "Logo",
                      },
                    }),
                _vm._v(" "),
                _c("h2", { staticStyle: { margin: "10px" } }, [
                  _vm._v(_vm._s(_vm.$appName)),
                ]),
              ]
            ),
          ]),
          _vm._v(" "),
          _c("h4", [_vm._v("Delivery Boy Register")]),
          _vm._v(" "),
          _c("p", { staticClass: "auth-subtitle text-primary" }, [
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
                  return _vm.registerDeliveryBoy.apply(null, arguments)
                },
              },
            },
            [
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
                        rawName: "v-model.trim",
                        value: _vm.$v.delivery_boy.username.$model,
                        expression: "$v.delivery_boy.username.$model",
                        modifiers: { trim: true },
                      },
                    ],
                    staticClass: "form-control form-control-xl",
                    attrs: { type: "text", placeholder: "Username" },
                    domProps: { value: _vm.$v.delivery_boy.username.$model },
                    on: {
                      input: function ($event) {
                        if ($event.target.composing) {
                          return
                        }
                        _vm.$set(
                          _vm.$v.delivery_boy.username,
                          "$model",
                          $event.target.value.trim()
                        )
                      },
                      blur: function ($event) {
                        return _vm.$forceUpdate()
                      },
                    },
                  }),
                  _vm._v(" "),
                  _vm._m(0),
                  _vm._v(" "),
                  _vm.$v.delivery_boy.username.$error
                    ? [
                        !_vm.$v.delivery_boy.username.required
                          ? _c("span", { staticClass: "text-danger" }, [
                              _vm._v("Username is required"),
                            ])
                          : _vm._e(),
                      ]
                    : _vm._e(),
                ],
                2
              ),
              _vm._v(" "),
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
                        rawName: "v-model.trim",
                        value: _vm.$v.delivery_boy.email.$model,
                        expression: "$v.delivery_boy.email.$model",
                        modifiers: { trim: true },
                      },
                    ],
                    staticClass: "form-control form-control-xl",
                    attrs: { type: "email", placeholder: "Email" },
                    domProps: { value: _vm.$v.delivery_boy.email.$model },
                    on: {
                      input: function ($event) {
                        if ($event.target.composing) {
                          return
                        }
                        _vm.$set(
                          _vm.$v.delivery_boy.email,
                          "$model",
                          $event.target.value.trim()
                        )
                      },
                      blur: function ($event) {
                        return _vm.$forceUpdate()
                      },
                    },
                  }),
                  _vm._v(" "),
                  _vm._m(1),
                  _vm._v(" "),
                  _vm.$v.delivery_boy.email.$error
                    ? [
                        !_vm.$v.delivery_boy.email.required
                          ? _c("span", { staticClass: "text-danger" }, [
                              _vm._v("Email is required"),
                            ])
                          : _vm._e(),
                        _vm._v(" "),
                        !_vm.$v.delivery_boy.email.email
                          ? _c("span", { staticClass: "text-danger" }, [
                              _vm._v("Email is invalid"),
                            ])
                          : _vm._e(),
                      ]
                    : _vm._e(),
                ],
                2
              ),
              _vm._v(" "),
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
                        rawName: "v-model.trim",
                        value: _vm.$v.delivery_boy.mobile.$model,
                        expression: "$v.delivery_boy.mobile.$model",
                        modifiers: { trim: true },
                      },
                    ],
                    staticClass: "form-control form-control-xl",
                    attrs: { type: "number", placeholder: "Mobile" },
                    domProps: { value: _vm.$v.delivery_boy.mobile.$model },
                    on: {
                      input: function ($event) {
                        if ($event.target.composing) {
                          return
                        }
                        _vm.$set(
                          _vm.$v.delivery_boy.mobile,
                          "$model",
                          $event.target.value.trim()
                        )
                      },
                      blur: function ($event) {
                        return _vm.$forceUpdate()
                      },
                    },
                  }),
                  _vm._v(" "),
                  _vm._m(2),
                  _vm._v(" "),
                  _vm.$v.delivery_boy.mobile.$error
                    ? [
                        !_vm.$v.delivery_boy.mobile.numeric
                          ? _c("span", { staticClass: "text-danger" }, [
                              _vm._v("Please enter a valid number."),
                            ])
                          : _vm._e(),
                        _vm._v(" "),
                        !_vm.$v.delivery_boy.mobile.onlyDigits
                          ? _c("span", { staticClass: "text-danger" }, [
                              _vm._v("Enter only digits"),
                            ])
                          : _vm._e(),
                        _vm._v(" "),
                        !_vm.$v.delivery_boy.mobile.required
                          ? _c("span", { staticClass: "text-danger" }, [
                              _vm._v("Mobile number is required"),
                            ])
                          : _vm._e(),
                        _vm._v(" "),
                        !_vm.$v.delivery_boy.mobile.minLength
                          ? _c("span", { staticClass: "text-danger" }, [
                              _vm._v(
                                "Mobile number must have at least " +
                                  _vm._s(
                                    _vm.$v.delivery_boy.mobile.$params.minLength
                                      .min
                                  ) +
                                  " digits."
                              ),
                            ])
                          : _vm._e(),
                      ]
                    : _vm._e(),
                ],
                2
              ),
              _vm._v(" "),
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
                        rawName: "v-model.trim",
                        value: _vm.$v.delivery_boy.password.$model,
                        expression: "$v.delivery_boy.password.$model",
                        modifiers: { trim: true },
                      },
                    ],
                    staticClass: "form-control form-control-xl",
                    attrs: {
                      type: _vm.showPassword ? "text" : "password",
                      placeholder: "Password",
                    },
                    domProps: { value: _vm.$v.delivery_boy.password.$model },
                    on: {
                      input: function ($event) {
                        if ($event.target.composing) {
                          return
                        }
                        _vm.$set(
                          _vm.$v.delivery_boy.password,
                          "$model",
                          $event.target.value.trim()
                        )
                      },
                      blur: function ($event) {
                        return _vm.$forceUpdate()
                      },
                    },
                  }),
                  _vm._v(" "),
                  _vm._m(3),
                  _vm._v(" "),
                  _c(
                    "button",
                    {
                      staticClass:
                        "btn btn-sm btn-outline-light font-bold text-primary",
                      staticStyle: {
                        "margin-top": "-45px",
                        position: "absolute",
                        right: "10px",
                      },
                      attrs: { type: "button" },
                      on: {
                        click: function ($event) {
                          _vm.showPassword = !_vm.showPassword
                        },
                      },
                    },
                    [
                      _vm._v(
                        "\n                                " +
                          _vm._s(_vm.showPassword ? "Hide" : "Show") +
                          "\n                            "
                      ),
                    ]
                  ),
                  _vm._v(" "),
                  _vm.$v.delivery_boy.password.$error
                    ? [
                        !_vm.$v.delivery_boy.password.required
                          ? _c("span", { staticClass: "text-danger" }, [
                              _vm._v("Password is required"),
                            ])
                          : _vm._e(),
                        _vm._v(" "),
                        !_vm.$v.delivery_boy.password.minLength
                          ? _c("span", { staticClass: "text-danger" }, [
                              _vm._v(
                                "Password must have at least " +
                                  _vm._s(
                                    _vm.$v.delivery_boy.password.$params
                                      .minLength.min
                                  ) +
                                  " letters."
                              ),
                            ])
                          : _vm._e(),
                      ]
                    : _vm._e(),
                ],
                2
              ),
              _vm._v(" "),
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
                        rawName: "v-model.trim",
                        value: _vm.$v.delivery_boy.password_confirmation.$model,
                        expression:
                          "$v.delivery_boy.password_confirmation.$model",
                        modifiers: { trim: true },
                      },
                    ],
                    staticClass: "form-control has-icon-left form-control-xl",
                    attrs: {
                      type: _vm.showConfirmPassword ? "text" : "password",
                      placeholder: "Confirm Password",
                    },
                    domProps: {
                      value: _vm.$v.delivery_boy.password_confirmation.$model,
                    },
                    on: {
                      input: function ($event) {
                        if ($event.target.composing) {
                          return
                        }
                        _vm.$set(
                          _vm.$v.delivery_boy.password_confirmation,
                          "$model",
                          $event.target.value.trim()
                        )
                      },
                      blur: function ($event) {
                        return _vm.$forceUpdate()
                      },
                    },
                  }),
                  _vm._v(" "),
                  _vm._m(4),
                  _vm._v(" "),
                  _c(
                    "button",
                    {
                      staticClass:
                        "btn btn-sm btn-outline-light font-bold text-primary",
                      staticStyle: {
                        "margin-top": "-45px",
                        position: "absolute",
                        right: "10px",
                      },
                      attrs: { type: "button" },
                      on: {
                        click: function ($event) {
                          _vm.showConfirmPassword = !_vm.showConfirmPassword
                        },
                      },
                    },
                    [
                      _vm._v(
                        "\n                                " +
                          _vm._s(_vm.showConfirmPassword ? "Hide" : "Show") +
                          "\n                            "
                      ),
                    ]
                  ),
                  _vm._v(" "),
                  _vm.$v.delivery_boy.password_confirmation.$error
                    ? [
                        !_vm.$v.delivery_boy.password_confirmation
                          .sameAsPassword
                          ? _c("span", { staticClass: "text-danger" }, [
                              _vm._v("Passwords must be identical."),
                            ])
                          : _vm._e(),
                      ]
                    : _vm._e(),
                ],
                2
              ),
              _vm._v(" "),
              _c(
                "button",
                {
                  staticClass:
                    "btn btn-primary btn-block btn-lg shadow-lg mt-3 mb-2",
                  attrs: { disabled: _vm.submitStatus === "PENDING" },
                },
                [
                  _vm._v(
                    "\n                            Sign Up\n                            "
                  ),
                  _vm.isLoading
                    ? _c("b-spinner", {
                        attrs: { small: "", label: "Spinning" },
                      })
                    : _vm._e(),
                ],
                1
              ),
              _vm._v(" "),
              _vm.submitStatus === "ERROR"
                ? _c(
                    "div",
                    {
                      staticClass:
                        "alert alert-light-danger color-danger text-danger",
                    },
                    [
                      _c("h6", { staticClass: "alert-heading" }, [
                        _c("i", { staticClass: "fa fa-exclamation-circle" }),
                        _vm._v(" " + _vm._s(_vm.submitStatus)),
                      ]),
                      _vm._v(" "),
                      _c("p", [_vm._v(" Please fill the form correctly.")]),
                    ]
                  )
                : _vm._e(),
              _vm._v(" "),
              _vm.submitStatus === "PENDING"
                ? _c(
                    "div",
                    {
                      staticClass:
                        "alert alert-light-warning color-warning text-warning",
                    },
                    [
                      _c("h6", { staticClass: "alert-heading" }, [
                        _c("i", { staticClass: "fa fa-exclamation-triangle" }),
                        _vm._v(" " + _vm._s(_vm.submitStatus)),
                      ]),
                      _vm._v(" "),
                      _c(
                        "p",
                        [
                          _c("b-spinner", {
                            attrs: { small: "", label: "Spinning" },
                          }),
                          _vm._v(" Sending..."),
                        ],
                        1
                      ),
                    ]
                  )
                : _vm._e(),
              _vm._v(" "),
              _vm.submitStatus === "SUCCESS"
                ? _c(
                    "div",
                    {
                      staticClass:
                        "alert alert-light-success color-success text-success",
                    },
                    [
                      _c("h6", { staticClass: "alert-heading" }, [
                        _c("i", { staticClass: "fa fa-check-circle" }),
                        _vm._v(" " + _vm._s(_vm.submitStatus)),
                      ]),
                      _vm._v(" "),
                      _c("p", [_vm._v("Thanks for your submission!")]),
                    ]
                  )
                : _vm._e(),
            ]
          ),
          _vm._v(" "),
          _c("div", { staticClass: "auth-copyright" }, [
            _c(
              "a",
              {
                staticClass: "text-primary font-weight-normal",
                attrs: { href: "javascript:void(0)" },
              },
              [_vm._v(" " + _vm._s(_vm.$copyrightDetails))]
            ),
          ]),
        ]),
      ]),
    ]),
  ])
}
var staticRenderFns = [
  function () {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("div", { staticClass: "form-control-icon" }, [
      _c("i", { staticClass: "bi bi-person" }),
    ])
  },
  function () {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("div", { staticClass: "form-control-icon" }, [
      _c("i", { staticClass: "bi bi-envelope" }),
    ])
  },
  function () {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("div", { staticClass: "form-control-icon" }, [
      _c("i", { staticClass: "bi bi-phone" }),
    ])
  },
  function () {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("div", { staticClass: "form-control-icon" }, [
      _c("i", { staticClass: "bi bi-shield-lock" }),
    ])
  },
  function () {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("div", { staticClass: "form-control-icon" }, [
      _c("i", { staticClass: "bi bi-lock" }),
    ])
  },
]
render._withStripped = true



/***/ }),

/***/ "./node_modules/vuelidate/lib/validators/alpha.js":
/*!********************************************************!*\
  !*** ./node_modules/vuelidate/lib/validators/alpha.js ***!
  \********************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports["default"] = void 0;

var _common = __webpack_require__(/*! ./common */ "./node_modules/vuelidate/lib/validators/common.js");

var _default = (0, _common.regex)('alpha', /^[a-zA-Z]*$/);

exports["default"] = _default;

/***/ }),

/***/ "./node_modules/vuelidate/lib/validators/alphaNum.js":
/*!***********************************************************!*\
  !*** ./node_modules/vuelidate/lib/validators/alphaNum.js ***!
  \***********************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports["default"] = void 0;

var _common = __webpack_require__(/*! ./common */ "./node_modules/vuelidate/lib/validators/common.js");

var _default = (0, _common.regex)('alphaNum', /^[a-zA-Z0-9]*$/);

exports["default"] = _default;

/***/ }),

/***/ "./node_modules/vuelidate/lib/validators/and.js":
/*!******************************************************!*\
  !*** ./node_modules/vuelidate/lib/validators/and.js ***!
  \******************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports["default"] = void 0;

var _common = __webpack_require__(/*! ./common */ "./node_modules/vuelidate/lib/validators/common.js");

var _default = function _default() {
  for (var _len = arguments.length, validators = new Array(_len), _key = 0; _key < _len; _key++) {
    validators[_key] = arguments[_key];
  }

  return (0, _common.withParams)({
    type: 'and'
  }, function () {
    var _this = this;

    for (var _len2 = arguments.length, args = new Array(_len2), _key2 = 0; _key2 < _len2; _key2++) {
      args[_key2] = arguments[_key2];
    }

    return validators.length > 0 && validators.reduce(function (valid, fn) {
      return valid && fn.apply(_this, args);
    }, true);
  });
};

exports["default"] = _default;

/***/ }),

/***/ "./node_modules/vuelidate/lib/validators/between.js":
/*!**********************************************************!*\
  !*** ./node_modules/vuelidate/lib/validators/between.js ***!
  \**********************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports["default"] = void 0;

var _common = __webpack_require__(/*! ./common */ "./node_modules/vuelidate/lib/validators/common.js");

var _default = function _default(min, max) {
  return (0, _common.withParams)({
    type: 'between',
    min: min,
    max: max
  }, function (value) {
    return !(0, _common.req)(value) || (!/\s/.test(value) || value instanceof Date) && +min <= +value && +max >= +value;
  });
};

exports["default"] = _default;

/***/ }),

/***/ "./node_modules/vuelidate/lib/validators/common.js":
/*!*********************************************************!*\
  !*** ./node_modules/vuelidate/lib/validators/common.js ***!
  \*********************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports.req = exports.regex = exports.ref = exports.len = void 0;
Object.defineProperty(exports, "withParams", ({
  enumerable: true,
  get: function get() {
    return _withParams.default;
  }
}));

var _withParams = _interopRequireDefault(__webpack_require__(/*! ../withParams */ "./node_modules/vuelidate/lib/withParams.js"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

var req = function req(value) {
  if (Array.isArray(value)) return !!value.length;

  if (value === undefined || value === null) {
    return false;
  }

  if (value === false) {
    return true;
  }

  if (value instanceof Date) {
    return !isNaN(value.getTime());
  }

  if (_typeof(value) === 'object') {
    for (var _ in value) {
      return true;
    }

    return false;
  }

  return !!String(value).length;
};

exports.req = req;

var len = function len(value) {
  if (Array.isArray(value)) return value.length;

  if (_typeof(value) === 'object') {
    return Object.keys(value).length;
  }

  return String(value).length;
};

exports.len = len;

var ref = function ref(reference, vm, parentVm) {
  return typeof reference === 'function' ? reference.call(vm, parentVm) : parentVm[reference];
};

exports.ref = ref;

var regex = function regex(type, expr) {
  return (0, _withParams.default)({
    type: type
  }, function (value) {
    return !req(value) || expr.test(value);
  });
};

exports.regex = regex;

/***/ }),

/***/ "./node_modules/vuelidate/lib/validators/decimal.js":
/*!**********************************************************!*\
  !*** ./node_modules/vuelidate/lib/validators/decimal.js ***!
  \**********************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports["default"] = void 0;

var _common = __webpack_require__(/*! ./common */ "./node_modules/vuelidate/lib/validators/common.js");

var _default = (0, _common.regex)('decimal', /^[-]?\d*(\.\d+)?$/);

exports["default"] = _default;

/***/ }),

/***/ "./node_modules/vuelidate/lib/validators/email.js":
/*!********************************************************!*\
  !*** ./node_modules/vuelidate/lib/validators/email.js ***!
  \********************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports["default"] = void 0;

var _common = __webpack_require__(/*! ./common */ "./node_modules/vuelidate/lib/validators/common.js");

var emailRegex = /^(?:[A-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]{2,}(?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])$/i;

var _default = (0, _common.regex)('email', emailRegex);

exports["default"] = _default;

/***/ }),

/***/ "./node_modules/vuelidate/lib/validators/index.js":
/*!********************************************************!*\
  !*** ./node_modules/vuelidate/lib/validators/index.js ***!
  \********************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

Object.defineProperty(exports, "__esModule", ({
  value: true
}));
Object.defineProperty(exports, "alpha", ({
  enumerable: true,
  get: function get() {
    return _alpha.default;
  }
}));
Object.defineProperty(exports, "alphaNum", ({
  enumerable: true,
  get: function get() {
    return _alphaNum.default;
  }
}));
Object.defineProperty(exports, "and", ({
  enumerable: true,
  get: function get() {
    return _and.default;
  }
}));
Object.defineProperty(exports, "between", ({
  enumerable: true,
  get: function get() {
    return _between.default;
  }
}));
Object.defineProperty(exports, "decimal", ({
  enumerable: true,
  get: function get() {
    return _decimal.default;
  }
}));
Object.defineProperty(exports, "email", ({
  enumerable: true,
  get: function get() {
    return _email.default;
  }
}));
exports.helpers = void 0;
Object.defineProperty(exports, "integer", ({
  enumerable: true,
  get: function get() {
    return _integer.default;
  }
}));
Object.defineProperty(exports, "ipAddress", ({
  enumerable: true,
  get: function get() {
    return _ipAddress.default;
  }
}));
Object.defineProperty(exports, "macAddress", ({
  enumerable: true,
  get: function get() {
    return _macAddress.default;
  }
}));
Object.defineProperty(exports, "maxLength", ({
  enumerable: true,
  get: function get() {
    return _maxLength.default;
  }
}));
Object.defineProperty(exports, "maxValue", ({
  enumerable: true,
  get: function get() {
    return _maxValue.default;
  }
}));
Object.defineProperty(exports, "minLength", ({
  enumerable: true,
  get: function get() {
    return _minLength.default;
  }
}));
Object.defineProperty(exports, "minValue", ({
  enumerable: true,
  get: function get() {
    return _minValue.default;
  }
}));
Object.defineProperty(exports, "not", ({
  enumerable: true,
  get: function get() {
    return _not.default;
  }
}));
Object.defineProperty(exports, "numeric", ({
  enumerable: true,
  get: function get() {
    return _numeric.default;
  }
}));
Object.defineProperty(exports, "or", ({
  enumerable: true,
  get: function get() {
    return _or.default;
  }
}));
Object.defineProperty(exports, "required", ({
  enumerable: true,
  get: function get() {
    return _required.default;
  }
}));
Object.defineProperty(exports, "requiredIf", ({
  enumerable: true,
  get: function get() {
    return _requiredIf.default;
  }
}));
Object.defineProperty(exports, "requiredUnless", ({
  enumerable: true,
  get: function get() {
    return _requiredUnless.default;
  }
}));
Object.defineProperty(exports, "sameAs", ({
  enumerable: true,
  get: function get() {
    return _sameAs.default;
  }
}));
Object.defineProperty(exports, "url", ({
  enumerable: true,
  get: function get() {
    return _url.default;
  }
}));

var _alpha = _interopRequireDefault(__webpack_require__(/*! ./alpha */ "./node_modules/vuelidate/lib/validators/alpha.js"));

var _alphaNum = _interopRequireDefault(__webpack_require__(/*! ./alphaNum */ "./node_modules/vuelidate/lib/validators/alphaNum.js"));

var _numeric = _interopRequireDefault(__webpack_require__(/*! ./numeric */ "./node_modules/vuelidate/lib/validators/numeric.js"));

var _between = _interopRequireDefault(__webpack_require__(/*! ./between */ "./node_modules/vuelidate/lib/validators/between.js"));

var _email = _interopRequireDefault(__webpack_require__(/*! ./email */ "./node_modules/vuelidate/lib/validators/email.js"));

var _ipAddress = _interopRequireDefault(__webpack_require__(/*! ./ipAddress */ "./node_modules/vuelidate/lib/validators/ipAddress.js"));

var _macAddress = _interopRequireDefault(__webpack_require__(/*! ./macAddress */ "./node_modules/vuelidate/lib/validators/macAddress.js"));

var _maxLength = _interopRequireDefault(__webpack_require__(/*! ./maxLength */ "./node_modules/vuelidate/lib/validators/maxLength.js"));

var _minLength = _interopRequireDefault(__webpack_require__(/*! ./minLength */ "./node_modules/vuelidate/lib/validators/minLength.js"));

var _required = _interopRequireDefault(__webpack_require__(/*! ./required */ "./node_modules/vuelidate/lib/validators/required.js"));

var _requiredIf = _interopRequireDefault(__webpack_require__(/*! ./requiredIf */ "./node_modules/vuelidate/lib/validators/requiredIf.js"));

var _requiredUnless = _interopRequireDefault(__webpack_require__(/*! ./requiredUnless */ "./node_modules/vuelidate/lib/validators/requiredUnless.js"));

var _sameAs = _interopRequireDefault(__webpack_require__(/*! ./sameAs */ "./node_modules/vuelidate/lib/validators/sameAs.js"));

var _url = _interopRequireDefault(__webpack_require__(/*! ./url */ "./node_modules/vuelidate/lib/validators/url.js"));

var _or = _interopRequireDefault(__webpack_require__(/*! ./or */ "./node_modules/vuelidate/lib/validators/or.js"));

var _and = _interopRequireDefault(__webpack_require__(/*! ./and */ "./node_modules/vuelidate/lib/validators/and.js"));

var _not = _interopRequireDefault(__webpack_require__(/*! ./not */ "./node_modules/vuelidate/lib/validators/not.js"));

var _minValue = _interopRequireDefault(__webpack_require__(/*! ./minValue */ "./node_modules/vuelidate/lib/validators/minValue.js"));

var _maxValue = _interopRequireDefault(__webpack_require__(/*! ./maxValue */ "./node_modules/vuelidate/lib/validators/maxValue.js"));

var _integer = _interopRequireDefault(__webpack_require__(/*! ./integer */ "./node_modules/vuelidate/lib/validators/integer.js"));

var _decimal = _interopRequireDefault(__webpack_require__(/*! ./decimal */ "./node_modules/vuelidate/lib/validators/decimal.js"));

var helpers = _interopRequireWildcard(__webpack_require__(/*! ./common */ "./node_modules/vuelidate/lib/validators/common.js"));

exports.helpers = helpers;

function _getRequireWildcardCache(nodeInterop) { if (typeof WeakMap !== "function") return null; var cacheBabelInterop = new WeakMap(); var cacheNodeInterop = new WeakMap(); return (_getRequireWildcardCache = function _getRequireWildcardCache(nodeInterop) { return nodeInterop ? cacheNodeInterop : cacheBabelInterop; })(nodeInterop); }

function _interopRequireWildcard(obj, nodeInterop) { if (!nodeInterop && obj && obj.__esModule) { return obj; } if (obj === null || _typeof(obj) !== "object" && typeof obj !== "function") { return { default: obj }; } var cache = _getRequireWildcardCache(nodeInterop); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (key !== "default" && Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } newObj.default = obj; if (cache) { cache.set(obj, newObj); } return newObj; }

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

/***/ }),

/***/ "./node_modules/vuelidate/lib/validators/integer.js":
/*!**********************************************************!*\
  !*** ./node_modules/vuelidate/lib/validators/integer.js ***!
  \**********************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports["default"] = void 0;

var _common = __webpack_require__(/*! ./common */ "./node_modules/vuelidate/lib/validators/common.js");

var _default = (0, _common.regex)('integer', /(^[0-9]*$)|(^-[0-9]+$)/);

exports["default"] = _default;

/***/ }),

/***/ "./node_modules/vuelidate/lib/validators/ipAddress.js":
/*!************************************************************!*\
  !*** ./node_modules/vuelidate/lib/validators/ipAddress.js ***!
  \************************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports["default"] = void 0;

var _common = __webpack_require__(/*! ./common */ "./node_modules/vuelidate/lib/validators/common.js");

var _default = (0, _common.withParams)({
  type: 'ipAddress'
}, function (value) {
  if (!(0, _common.req)(value)) {
    return true;
  }

  if (typeof value !== 'string') {
    return false;
  }

  var nibbles = value.split('.');
  return nibbles.length === 4 && nibbles.every(nibbleValid);
});

exports["default"] = _default;

var nibbleValid = function nibbleValid(nibble) {
  if (nibble.length > 3 || nibble.length === 0) {
    return false;
  }

  if (nibble[0] === '0' && nibble !== '0') {
    return false;
  }

  if (!nibble.match(/^\d+$/)) {
    return false;
  }

  var numeric = +nibble | 0;
  return numeric >= 0 && numeric <= 255;
};

/***/ }),

/***/ "./node_modules/vuelidate/lib/validators/macAddress.js":
/*!*************************************************************!*\
  !*** ./node_modules/vuelidate/lib/validators/macAddress.js ***!
  \*************************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports["default"] = void 0;

var _common = __webpack_require__(/*! ./common */ "./node_modules/vuelidate/lib/validators/common.js");

var _default = function _default() {
  var separator = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : ':';
  return (0, _common.withParams)({
    type: 'macAddress'
  }, function (value) {
    if (!(0, _common.req)(value)) {
      return true;
    }

    if (typeof value !== 'string') {
      return false;
    }

    var parts = typeof separator === 'string' && separator !== '' ? value.split(separator) : value.length === 12 || value.length === 16 ? value.match(/.{2}/g) : null;
    return parts !== null && (parts.length === 6 || parts.length === 8) && parts.every(hexValid);
  });
};

exports["default"] = _default;

var hexValid = function hexValid(hex) {
  return hex.toLowerCase().match(/^[0-9a-f]{2}$/);
};

/***/ }),

/***/ "./node_modules/vuelidate/lib/validators/maxLength.js":
/*!************************************************************!*\
  !*** ./node_modules/vuelidate/lib/validators/maxLength.js ***!
  \************************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports["default"] = void 0;

var _common = __webpack_require__(/*! ./common */ "./node_modules/vuelidate/lib/validators/common.js");

var _default = function _default(length) {
  return (0, _common.withParams)({
    type: 'maxLength',
    max: length
  }, function (value) {
    return !(0, _common.req)(value) || (0, _common.len)(value) <= length;
  });
};

exports["default"] = _default;

/***/ }),

/***/ "./node_modules/vuelidate/lib/validators/maxValue.js":
/*!***********************************************************!*\
  !*** ./node_modules/vuelidate/lib/validators/maxValue.js ***!
  \***********************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports["default"] = void 0;

var _common = __webpack_require__(/*! ./common */ "./node_modules/vuelidate/lib/validators/common.js");

var _default = function _default(max) {
  return (0, _common.withParams)({
    type: 'maxValue',
    max: max
  }, function (value) {
    return !(0, _common.req)(value) || (!/\s/.test(value) || value instanceof Date) && +value <= +max;
  });
};

exports["default"] = _default;

/***/ }),

/***/ "./node_modules/vuelidate/lib/validators/minLength.js":
/*!************************************************************!*\
  !*** ./node_modules/vuelidate/lib/validators/minLength.js ***!
  \************************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports["default"] = void 0;

var _common = __webpack_require__(/*! ./common */ "./node_modules/vuelidate/lib/validators/common.js");

var _default = function _default(length) {
  return (0, _common.withParams)({
    type: 'minLength',
    min: length
  }, function (value) {
    return !(0, _common.req)(value) || (0, _common.len)(value) >= length;
  });
};

exports["default"] = _default;

/***/ }),

/***/ "./node_modules/vuelidate/lib/validators/minValue.js":
/*!***********************************************************!*\
  !*** ./node_modules/vuelidate/lib/validators/minValue.js ***!
  \***********************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports["default"] = void 0;

var _common = __webpack_require__(/*! ./common */ "./node_modules/vuelidate/lib/validators/common.js");

var _default = function _default(min) {
  return (0, _common.withParams)({
    type: 'minValue',
    min: min
  }, function (value) {
    return !(0, _common.req)(value) || (!/\s/.test(value) || value instanceof Date) && +value >= +min;
  });
};

exports["default"] = _default;

/***/ }),

/***/ "./node_modules/vuelidate/lib/validators/not.js":
/*!******************************************************!*\
  !*** ./node_modules/vuelidate/lib/validators/not.js ***!
  \******************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports["default"] = void 0;

var _common = __webpack_require__(/*! ./common */ "./node_modules/vuelidate/lib/validators/common.js");

var _default = function _default(validator) {
  return (0, _common.withParams)({
    type: 'not'
  }, function (value, vm) {
    return !(0, _common.req)(value) || !validator.call(this, value, vm);
  });
};

exports["default"] = _default;

/***/ }),

/***/ "./node_modules/vuelidate/lib/validators/numeric.js":
/*!**********************************************************!*\
  !*** ./node_modules/vuelidate/lib/validators/numeric.js ***!
  \**********************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports["default"] = void 0;

var _common = __webpack_require__(/*! ./common */ "./node_modules/vuelidate/lib/validators/common.js");

var _default = (0, _common.regex)('numeric', /^[0-9]*$/);

exports["default"] = _default;

/***/ }),

/***/ "./node_modules/vuelidate/lib/validators/or.js":
/*!*****************************************************!*\
  !*** ./node_modules/vuelidate/lib/validators/or.js ***!
  \*****************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports["default"] = void 0;

var _common = __webpack_require__(/*! ./common */ "./node_modules/vuelidate/lib/validators/common.js");

var _default = function _default() {
  for (var _len = arguments.length, validators = new Array(_len), _key = 0; _key < _len; _key++) {
    validators[_key] = arguments[_key];
  }

  return (0, _common.withParams)({
    type: 'or'
  }, function () {
    var _this = this;

    for (var _len2 = arguments.length, args = new Array(_len2), _key2 = 0; _key2 < _len2; _key2++) {
      args[_key2] = arguments[_key2];
    }

    return validators.length > 0 && validators.reduce(function (valid, fn) {
      return valid || fn.apply(_this, args);
    }, false);
  });
};

exports["default"] = _default;

/***/ }),

/***/ "./node_modules/vuelidate/lib/validators/required.js":
/*!***********************************************************!*\
  !*** ./node_modules/vuelidate/lib/validators/required.js ***!
  \***********************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports["default"] = void 0;

var _common = __webpack_require__(/*! ./common */ "./node_modules/vuelidate/lib/validators/common.js");

var _default = (0, _common.withParams)({
  type: 'required'
}, function (value) {
  if (typeof value === 'string') {
    return (0, _common.req)(value.trim());
  }

  return (0, _common.req)(value);
});

exports["default"] = _default;

/***/ }),

/***/ "./node_modules/vuelidate/lib/validators/requiredIf.js":
/*!*************************************************************!*\
  !*** ./node_modules/vuelidate/lib/validators/requiredIf.js ***!
  \*************************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports["default"] = void 0;

var _common = __webpack_require__(/*! ./common */ "./node_modules/vuelidate/lib/validators/common.js");

var _default = function _default(prop) {
  return (0, _common.withParams)({
    type: 'requiredIf',
    prop: prop
  }, function (value, parentVm) {
    return (0, _common.ref)(prop, this, parentVm) ? (0, _common.req)(value) : true;
  });
};

exports["default"] = _default;

/***/ }),

/***/ "./node_modules/vuelidate/lib/validators/requiredUnless.js":
/*!*****************************************************************!*\
  !*** ./node_modules/vuelidate/lib/validators/requiredUnless.js ***!
  \*****************************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports["default"] = void 0;

var _common = __webpack_require__(/*! ./common */ "./node_modules/vuelidate/lib/validators/common.js");

var _default = function _default(prop) {
  return (0, _common.withParams)({
    type: 'requiredUnless',
    prop: prop
  }, function (value, parentVm) {
    return !(0, _common.ref)(prop, this, parentVm) ? (0, _common.req)(value) : true;
  });
};

exports["default"] = _default;

/***/ }),

/***/ "./node_modules/vuelidate/lib/validators/sameAs.js":
/*!*********************************************************!*\
  !*** ./node_modules/vuelidate/lib/validators/sameAs.js ***!
  \*********************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports["default"] = void 0;

var _common = __webpack_require__(/*! ./common */ "./node_modules/vuelidate/lib/validators/common.js");

var _default = function _default(equalTo) {
  return (0, _common.withParams)({
    type: 'sameAs',
    eq: equalTo
  }, function (value, parentVm) {
    return value === (0, _common.ref)(equalTo, this, parentVm);
  });
};

exports["default"] = _default;

/***/ }),

/***/ "./node_modules/vuelidate/lib/validators/url.js":
/*!******************************************************!*\
  !*** ./node_modules/vuelidate/lib/validators/url.js ***!
  \******************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports["default"] = void 0;

var _common = __webpack_require__(/*! ./common */ "./node_modules/vuelidate/lib/validators/common.js");

var urlRegex = /^(?:(?:(?:https?|ftp):)?\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z0-9\u00a1-\uffff][a-z0-9\u00a1-\uffff_-]{0,62})?[a-z0-9\u00a1-\uffff]\.)+(?:[a-z\u00a1-\uffff]{2,}\.?))(?::\d{2,5})?(?:[/?#]\S*)?$/i;

var _default = (0, _common.regex)('url', urlRegex);

exports["default"] = _default;

/***/ }),

/***/ "./node_modules/vuelidate/lib/withParams.js":
/*!**************************************************!*\
  !*** ./node_modules/vuelidate/lib/withParams.js ***!
  \**************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {

/* provided dependency */ var process = __webpack_require__(/*! process/browser.js */ "./node_modules/process/browser.js");


Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports["default"] = void 0;
var withParams = process.env.BUILD === 'web' ? (__webpack_require__(/*! ./withParamsBrowser */ "./node_modules/vuelidate/lib/withParamsBrowser.js").withParams) : (__webpack_require__(/*! ./params */ "./node_modules/vuelidate/lib/params.js").withParams);
var _default = withParams;
exports["default"] = _default;

/***/ }),

/***/ "./node_modules/vuelidate/lib/withParamsBrowser.js":
/*!*********************************************************!*\
  !*** ./node_modules/vuelidate/lib/withParamsBrowser.js ***!
  \*********************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports.withParams = void 0;

function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

var root = typeof window !== 'undefined' ? window : typeof __webpack_require__.g !== 'undefined' ? __webpack_require__.g : {};

var fakeWithParams = function fakeWithParams(paramsOrClosure, maybeValidator) {
  if (_typeof(paramsOrClosure) === 'object' && maybeValidator !== undefined) {
    return maybeValidator;
  }

  return paramsOrClosure(function () {});
};

var withParams = root.vuelidate ? root.vuelidate.withParams : fakeWithParams;
exports.withParams = withParams;

/***/ })

}]);