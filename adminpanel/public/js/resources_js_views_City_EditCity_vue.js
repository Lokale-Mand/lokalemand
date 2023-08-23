"use strict";
(self["webpackChunk"] = self["webpackChunk"] || []).push([["resources_js_views_City_EditCity_vue"],{

/***/ "./node_modules/babel-loader/lib/index.js??clonedRuleSet-5[0].rules[0].use[0]!./node_modules/vue-loader/lib/index.js??vue-loader-options!./resources/js/views/City/EditCity.vue?vue&type=script&lang=js&":
/*!***************************************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/babel-loader/lib/index.js??clonedRuleSet-5[0].rules[0].use[0]!./node_modules/vue-loader/lib/index.js??vue-loader-options!./resources/js/views/City/EditCity.vue?vue&type=script&lang=js& ***!
  \***************************************************************************************************************************************************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony import */ var axios__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! axios */ "./node_modules/axios/index.js");
/* harmony import */ var axios__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(axios__WEBPACK_IMPORTED_MODULE_0__);
/* harmony import */ var vue2_google_maps__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! vue2-google-maps */ "./node_modules/vue2-google-maps/dist/main.js");
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
      //center: { lat: 45.508, lng: -73.587 },
      center: {
        lat: 0,
        lng: 0
      },
      currentPlace: null,
      markers: [],
      city: {
        id: "",
        latitude: "",
        longitude: "",
        name: "",
        state: "",
        formatted_address: "",
        time_to_travel: "",
        min_amount_for_free_delivery: "",
        max_deliverable_distance: "",
        delivery_charge_method: "",
        fixed_charge: "",
        per_km_charge: "",
        range_wise_charges: [{
          from_range: "",
          to_range: "",
          price: ""
        }]
      },
      formatted_address: "",
      infoWindow: {
        position: {
          lat: 0,
          lng: 0
        },
        open: false,
        template: ''
      }
    };
  },
  mounted: function mounted() {
    /*this.$refs.mapRef.$mapPromise.then((map) => {
        map.panTo({lat: 1.38, lng: 103.80})
    });*/
  },
  computed: {
    google: vue2_google_maps__WEBPACK_IMPORTED_MODULE_1__.gmapApi
  },
  created: function created() {
    this.city.id = this.$route.params.id;

    if (this.city.id) {
      this.getCity();
    }
  },
  methods: {
    addRow: function addRow() {
      this.city.range_wise_charges.push({
        from_range: "",
        to_range: "",
        price: ""
      });
    },
    remove: function remove(index) {
      this.city.range_wise_charges.splice(index, 1);
      /*let variant_id = (this.city.range_wise_charges[index].id)?this.city.range_wise_charges[index].id:"";
      if (this.id && variant_id !== ""){
          this.$swal.fire({
              title: "Are you Sure?",
              text: "You want be able to revert this",
              confirmButtonText: "Yes, Sure",
              cancelButtonText: "Cancel",
              icon: 'warning',
              showCancelButton: true,
              confirmButtonColor: '#37a279',
              cancelButtonColor: '#d33',
          }).then(result => {
              if (result.value) {
                  let postData = {
                      id: variant_id
                  }
                  axios.post(this.$apiUrl + '/products/delete', postData)
                      .then((response) => {
                          let data = response.data;
                          this.inputs.splice(index, 1)
                          this.showSuccess(data.message)
                      });
              }
          });
      } else{
          this.city.range_wise_charges.splice(index, 1)
      }*/
    },
    setPlace: function setPlace(place) {
      this.currentPlace = place;
      this.addMarker();
    },
    addMarker: function addMarker() {
      if (this.currentPlace) {
        var marker = {
          lat: this.currentPlace.geometry.location.lat(),
          lng: this.currentPlace.geometry.location.lng()
        };
        this.markers.push({
          position: marker
        });
        this.center = marker;
        this.city.latitude = this.currentPlace.geometry.location.lat();
        this.city.longitude = this.currentPlace.geometry.location.lng();
        this.city.name = this.currentPlace.name;
        var addressArr = this.currentPlace.formatted_address.split(",");
        this.city.state = addressArr[addressArr.length - 2];
        this.city.formatted_address = this.currentPlace.formatted_address;
        this.infoWindow.position = {
          lat: this.city.latitude,
          lng: this.city.longitude
        };
        this.infoWindow.template = "<b>".concat(this.city.name, "</b><br>").concat(this.city.formatted_address);
        this.infoWindow.open = true;
        this.currentPlace = null;
      }
    },
    getCity: function getCity() {
      var _this = this;

      this.isLoading = true;
      axios__WEBPACK_IMPORTED_MODULE_0___default().get(this.$apiUrl + '/cities/edit/' + this.city.id).then(function (response) {
        _this.isLoading = false;
        var data = response.data.data;

        for (var key in _this.city) {
          if (key === 'range_wise_charges') {
            _this.city[key] = JSON.parse(data[key]);
          } else {
            _this.city[key] = data[key];
          }
        }

        var marker = {
          lat: parseFloat(data.latitude),
          lng: parseFloat(data.longitude)
        };

        _this.markers.push({
          position: marker
        });

        _this.center = marker;
        _this.infoWindow.position = {
          lat: parseFloat(data.latitude),
          lng: parseFloat(data.longitude)
        };
        _this.infoWindow.template = "<b>".concat(data.name, "</b><br>").concat(_this.city.formatted_address);
        _this.infoWindow.open = true;
      });
    },
    checkMaximumDistance: function checkMaximumDistance() {
      var _this2 = this;

      if (this.city.delivery_charge_method === 'range_wise_charges') {
        var maxDistance = parseFloat(this.city.max_deliverable_distance);
        var charges = this.city.range_wise_charges;
        return charges.map(function (range, index) {
          var rowNum = index + 1;
          var to_range = parseFloat(range.to_range);
          var from_range = parseFloat(range.from_range);

          if (to_range > maxDistance || from_range > maxDistance) {
            _this2.showError("Range wise delivery distance is more then maximum deliverable distance no row no. :- " + rowNum);

            return false;
          }

          if (to_range <= from_range) {
            _this2.showError("Range wise From distance is more then To distance no row no. :- " + rowNum);

            return false;
          }
        });
      }
    },
    saveRecord: function saveRecord() {
      var _this3 = this;

      if (this.checkMaximumDistance() === false) {
        return false;
      }

      var vm = this;
      this.isLoading = true;
      var formObject = this.city;
      var formData = new FormData();

      for (var key in formObject) {
        if (key === 'range_wise_charges') {
          formData.append(key, JSON.stringify(formObject[key]));
        } else {
          formData.append(key, formObject[key]);
        }
      }

      var url = this.$apiUrl + '/cities/save';

      if (this.city.id) {
        url = this.$apiUrl + '/cities/update';
      }

      axios__WEBPACK_IMPORTED_MODULE_0___default().post(url, formData).then(function (res) {
        var data = res.data;

        if (data.status === 1) {
          //this.showSuccess(data.message);
          _this3.showMessage("success", data.message);

          setTimeout(function () {
            vm.$swal.close();
            vm.$router.push({
              path: '/cities'
            });
          }, 2000);
        } else {
          vm.showError(data.message);
          vm.isLoading = false;
        }
      })["catch"](function (error) {
        vm.isLoading = false;

        if (error.request.statusText) {
          _this3.showError(error.request.statusText);
        } else if (error.message) {
          _this3.showError(error.message);
        } else {
          _this3.showError("Something went wrong!");
        }
      });
    }
  }
});

/***/ }),

/***/ "./resources/js/views/City/EditCity.vue":
/*!**********************************************!*\
  !*** ./resources/js/views/City/EditCity.vue ***!
  \**********************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony import */ var _EditCity_vue_vue_type_template_id_a8c9b86c___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./EditCity.vue?vue&type=template&id=a8c9b86c& */ "./resources/js/views/City/EditCity.vue?vue&type=template&id=a8c9b86c&");
/* harmony import */ var _EditCity_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./EditCity.vue?vue&type=script&lang=js& */ "./resources/js/views/City/EditCity.vue?vue&type=script&lang=js&");
/* harmony import */ var _node_modules_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! !../../../../node_modules/vue-loader/lib/runtime/componentNormalizer.js */ "./node_modules/vue-loader/lib/runtime/componentNormalizer.js");





/* normalize component */
;
var component = (0,_node_modules_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_2__["default"])(
  _EditCity_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__["default"],
  _EditCity_vue_vue_type_template_id_a8c9b86c___WEBPACK_IMPORTED_MODULE_0__.render,
  _EditCity_vue_vue_type_template_id_a8c9b86c___WEBPACK_IMPORTED_MODULE_0__.staticRenderFns,
  false,
  null,
  null,
  null
  
)

/* hot reload */
if (false) { var api; }
component.options.__file = "resources/js/views/City/EditCity.vue"
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = (component.exports);

/***/ }),

/***/ "./resources/js/views/City/EditCity.vue?vue&type=script&lang=js&":
/*!***********************************************************************!*\
  !*** ./resources/js/views/City/EditCity.vue?vue&type=script&lang=js& ***!
  \***********************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony import */ var _node_modules_babel_loader_lib_index_js_clonedRuleSet_5_0_rules_0_use_0_node_modules_vue_loader_lib_index_js_vue_loader_options_EditCity_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../node_modules/babel-loader/lib/index.js??clonedRuleSet-5[0].rules[0].use[0]!../../../../node_modules/vue-loader/lib/index.js??vue-loader-options!./EditCity.vue?vue&type=script&lang=js& */ "./node_modules/babel-loader/lib/index.js??clonedRuleSet-5[0].rules[0].use[0]!./node_modules/vue-loader/lib/index.js??vue-loader-options!./resources/js/views/City/EditCity.vue?vue&type=script&lang=js&");
 /* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = (_node_modules_babel_loader_lib_index_js_clonedRuleSet_5_0_rules_0_use_0_node_modules_vue_loader_lib_index_js_vue_loader_options_EditCity_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__["default"]); 

/***/ }),

/***/ "./resources/js/views/City/EditCity.vue?vue&type=template&id=a8c9b86c&":
/*!*****************************************************************************!*\
  !*** ./resources/js/views/City/EditCity.vue?vue&type=template&id=a8c9b86c& ***!
  \*****************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "render": () => (/* reexport safe */ _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_EditCity_vue_vue_type_template_id_a8c9b86c___WEBPACK_IMPORTED_MODULE_0__.render),
/* harmony export */   "staticRenderFns": () => (/* reexport safe */ _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_EditCity_vue_vue_type_template_id_a8c9b86c___WEBPACK_IMPORTED_MODULE_0__.staticRenderFns)
/* harmony export */ });
/* harmony import */ var _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_EditCity_vue_vue_type_template_id_a8c9b86c___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!../../../../node_modules/vue-loader/lib/index.js??vue-loader-options!./EditCity.vue?vue&type=template&id=a8c9b86c& */ "./node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!./node_modules/vue-loader/lib/index.js??vue-loader-options!./resources/js/views/City/EditCity.vue?vue&type=template&id=a8c9b86c&");


/***/ }),

/***/ "./node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!./node_modules/vue-loader/lib/index.js??vue-loader-options!./resources/js/views/City/EditCity.vue?vue&type=template&id=a8c9b86c&":
/*!********************************************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!./node_modules/vue-loader/lib/index.js??vue-loader-options!./resources/js/views/City/EditCity.vue?vue&type=template&id=a8c9b86c& ***!
  \********************************************************************************************************************************************************************************************************************/
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
  return _c("div", [
    _c("div", { staticClass: "page-heading" }, [
      _c("div", { staticClass: "row" }, [
        _vm._m(0),
        _vm._v(" "),
        _c("div", { staticClass: "col-12 col-md-6 order-md-2 order-first" }, [
          _c(
            "nav",
            {
              staticClass: "breadcrumb-header float-start float-lg-end",
              attrs: { "aria-label": "breadcrumb" },
            },
            [
              _c("ol", { staticClass: "breadcrumb" }, [
                _c(
                  "li",
                  { staticClass: "breadcrumb-item" },
                  [
                    _c("router-link", { attrs: { to: "/dashboard" } }, [
                      _vm._v(_vm._s(_vm.__("dashboard"))),
                    ]),
                  ],
                  1
                ),
                _vm._v(" "),
                _c(
                  "li",
                  {
                    staticClass: "breadcrumb-item active",
                    attrs: { "aria-current": "page" },
                  },
                  [
                    _vm.city.id
                      ? [
                          _vm._v(
                            "\n                                    Edit\n                                "
                          ),
                        ]
                      : [
                          _vm._v(
                            "\n                                    Create\n                                "
                          ),
                        ],
                    _vm._v(
                      "\n                                City\n                            "
                    ),
                  ],
                  2
                ),
              ]),
            ]
          ),
        ]),
      ]),
      _vm._v(" "),
      _c("div", { staticClass: "row" }, [
        _c("div", { staticClass: "col-6 col-md-6 order-md-1 order-last" }, [
          _c("div", { staticClass: "card h-100" }, [
            _c("div", { staticClass: "card-header" }, [
              _c(
                "h4",
                [
                  _vm.city.id ? [_vm._v("Edit")] : [_vm._v("Create")],
                  _vm._v(
                    "\n                                City\n                            "
                  ),
                ],
                2
              ),
            ]),
            _vm._v(" "),
            _c("div", { staticClass: "card-body" }, [
              _c(
                "form",
                {
                  ref: "my-form",
                  on: {
                    submit: function ($event) {
                      $event.preventDefault()
                      return _vm.saveRecord.apply(null, arguments)
                    },
                  },
                },
                [
                  _c(
                    "div",
                    { staticClass: "form-group" },
                    [
                      _c("label", { attrs: { for: "city_name" } }, [
                        _vm._v("Search City"),
                      ]),
                      _vm._v(" "),
                      _c("GmapAutocomplete", {
                        staticClass: "form-control",
                        attrs: {
                          type: "search",
                          placeholder: "Search City on map.",
                          options: {
                            fields: [
                              "address_components",
                              "formatted_address",
                              "geometry",
                              "name",
                              "place_id",
                              "plus_code",
                              "types",
                            ],
                            strictBounds: false,
                          },
                          id: "city_name",
                        },
                        on: { place_changed: _vm.setPlace },
                      }),
                      _vm._v(" "),
                      _c("input", {
                        directives: [
                          {
                            name: "model",
                            rawName: "v-model",
                            value: _vm.city.formatted_address,
                            expression: "city.formatted_address",
                          },
                        ],
                        attrs: { type: "hidden" },
                        domProps: { value: _vm.city.formatted_address },
                        on: {
                          input: function ($event) {
                            if ($event.target.composing) {
                              return
                            }
                            _vm.$set(
                              _vm.city,
                              "formatted_address",
                              $event.target.value
                            )
                          },
                        },
                      }),
                      _vm._v(" "),
                      _c("span", { staticClass: "text text-primary" }, [
                        _vm._v(
                          "Search your city where you will deliver the food and to find co-ordinates."
                        ),
                      ]),
                    ],
                    1
                  ),
                  _vm._v(" "),
                  _c("div", { staticClass: "form-group" }, [
                    _vm._m(1),
                    _vm._v(" "),
                    _c("input", {
                      directives: [
                        {
                          name: "model",
                          rawName: "v-model",
                          value: _vm.city.latitude,
                          expression: "city.latitude",
                        },
                      ],
                      staticClass: "form-control",
                      attrs: {
                        type: "text",
                        name: "latitude",
                        id: "latitude",
                        placeholder: "Enter Latitude.",
                        required: "",
                        readonly: "",
                      },
                      domProps: { value: _vm.city.latitude },
                      on: {
                        input: function ($event) {
                          if ($event.target.composing) {
                            return
                          }
                          _vm.$set(_vm.city, "latitude", $event.target.value)
                        },
                      },
                    }),
                  ]),
                  _vm._v(" "),
                  _c("div", { staticClass: "form-group" }, [
                    _vm._m(2),
                    _vm._v(" "),
                    _c("input", {
                      directives: [
                        {
                          name: "model",
                          rawName: "v-model",
                          value: _vm.city.longitude,
                          expression: "city.longitude",
                        },
                      ],
                      staticClass: "form-control",
                      attrs: {
                        type: "text",
                        name: "longitude",
                        id: "longitude",
                        placeholder: "Enter Longitude.",
                        required: "",
                        readonly: "",
                      },
                      domProps: { value: _vm.city.longitude },
                      on: {
                        input: function ($event) {
                          if ($event.target.composing) {
                            return
                          }
                          _vm.$set(_vm.city, "longitude", $event.target.value)
                        },
                      },
                    }),
                  ]),
                  _vm._v(" "),
                  _c("div", { staticClass: "form-group" }, [
                    _vm._m(3),
                    _vm._v(" "),
                    _c("input", {
                      directives: [
                        {
                          name: "model",
                          rawName: "v-model",
                          value: _vm.city.name,
                          expression: "city.name",
                        },
                      ],
                      staticClass: "form-control",
                      attrs: {
                        type: "text",
                        name: "name",
                        id: "name",
                        placeholder: "Enter City Name.",
                        required: "",
                        readonly: "",
                      },
                      domProps: { value: _vm.city.name },
                      on: {
                        input: function ($event) {
                          if ($event.target.composing) {
                            return
                          }
                          _vm.$set(_vm.city, "name", $event.target.value)
                        },
                      },
                    }),
                  ]),
                  _vm._v(" "),
                  _c("div", { staticClass: "form-group" }, [
                    _vm._m(4),
                    _vm._v(" "),
                    _c("input", {
                      directives: [
                        {
                          name: "model",
                          rawName: "v-model",
                          value: _vm.city.state,
                          expression: "city.state",
                        },
                      ],
                      staticClass: "form-control",
                      attrs: {
                        type: "text",
                        name: "state",
                        id: "state",
                        placeholder: "Enter State Name.",
                        required: "",
                        readonly: "",
                      },
                      domProps: { value: _vm.city.state },
                      on: {
                        input: function ($event) {
                          if ($event.target.composing) {
                            return
                          }
                          _vm.$set(_vm.city, "state", $event.target.value)
                        },
                      },
                    }),
                  ]),
                  _vm._v(" "),
                  _c("div", { staticClass: "form-group" }, [
                    _vm._m(5),
                    _vm._v(" "),
                    _c("input", {
                      directives: [
                        {
                          name: "model",
                          rawName: "v-model",
                          value: _vm.city.time_to_travel,
                          expression: "city.time_to_travel",
                        },
                      ],
                      staticClass: "form-control",
                      attrs: {
                        type: "number",
                        name: "time_to_travel",
                        id: "time_to_travel",
                        min: "0",
                        placeholder: "Enter Time to travel 1 (km).",
                        required: "",
                      },
                      domProps: { value: _vm.city.time_to_travel },
                      on: {
                        input: function ($event) {
                          if ($event.target.composing) {
                            return
                          }
                          _vm.$set(
                            _vm.city,
                            "time_to_travel",
                            $event.target.value
                          )
                        },
                      },
                    }),
                  ]),
                  _vm._v(" "),
                  _c("div", { staticClass: "form-group" }, [
                    _c(
                      "label",
                      { attrs: { for: "min_amount_for_free_delivery" } },
                      [
                        _vm._v("Minimum Amount for Free Delivery"),
                        _c("span", { staticClass: "text-danger text-xs" }, [
                          _vm._v("*"),
                        ]),
                        _vm._v(" "),
                        _c("small", [
                          _vm._v("[ " + _vm._s(_vm.$currency) + " ]"),
                        ]),
                      ]
                    ),
                    _vm._v(" "),
                    _c("input", {
                      directives: [
                        {
                          name: "model",
                          rawName: "v-model",
                          value: _vm.city.min_amount_for_free_delivery,
                          expression: "city.min_amount_for_free_delivery",
                        },
                      ],
                      staticClass: "form-control",
                      attrs: {
                        type: "number",
                        name: "min_amount_for_free_delivery",
                        id: "min_amount_for_free_delivery",
                        placeholder: "Enter Delivarable Maximum Distance in km",
                        min: "0",
                        required: "",
                      },
                      domProps: {
                        value: _vm.city.min_amount_for_free_delivery,
                      },
                      on: {
                        input: function ($event) {
                          if ($event.target.composing) {
                            return
                          }
                          _vm.$set(
                            _vm.city,
                            "min_amount_for_free_delivery",
                            $event.target.value
                          )
                        },
                      },
                    }),
                  ]),
                  _vm._v(" "),
                  _c("div", { staticClass: "form-group" }, [
                    _vm._m(6),
                    _vm._v(" "),
                    _c("input", {
                      directives: [
                        {
                          name: "model",
                          rawName: "v-model",
                          value: _vm.city.max_deliverable_distance,
                          expression: "city.max_deliverable_distance",
                        },
                      ],
                      staticClass: "form-control",
                      attrs: {
                        type: "number",
                        name: "max_deliverable_distance",
                        id: "max_deliverable_distance",
                        placeholder: "Enter Delivarable Maximum Distance in km",
                        min: "0",
                        required: "",
                      },
                      domProps: { value: _vm.city.max_deliverable_distance },
                      on: {
                        input: function ($event) {
                          if ($event.target.composing) {
                            return
                          }
                          _vm.$set(
                            _vm.city,
                            "max_deliverable_distance",
                            $event.target.value
                          )
                        },
                      },
                    }),
                  ]),
                  _vm._v(" "),
                  _c("div", { staticClass: "form-group" }, [
                    _vm._m(7),
                    _vm._v(" "),
                    _c(
                      "select",
                      {
                        directives: [
                          {
                            name: "model",
                            rawName: "v-model",
                            value: _vm.city.delivery_charge_method,
                            expression: "city.delivery_charge_method",
                          },
                        ],
                        staticClass: "form-control form-select",
                        attrs: {
                          name: "delivery_charge_method",
                          id: "delivery_charge_method",
                          required: "",
                        },
                        on: {
                          change: function ($event) {
                            var $$selectedVal = Array.prototype.filter
                              .call($event.target.options, function (o) {
                                return o.selected
                              })
                              .map(function (o) {
                                var val = "_value" in o ? o._value : o.value
                                return val
                              })
                            _vm.$set(
                              _vm.city,
                              "delivery_charge_method",
                              $event.target.multiple
                                ? $$selectedVal
                                : $$selectedVal[0]
                            )
                          },
                        },
                      },
                      [
                        _c("option", { attrs: { value: "" } }, [
                          _vm._v("Select Method"),
                        ]),
                        _vm._v(" "),
                        _c("option", { attrs: { value: "fixed_charge" } }, [
                          _vm._v("Fixed Delivery Charges"),
                        ]),
                        _vm._v(" "),
                        _c("option", { attrs: { value: "per_km_charge" } }, [
                          _vm._v("Per KM Delivery Charges"),
                        ]),
                        _vm._v(" "),
                        _c(
                          "option",
                          { attrs: { value: "range_wise_charges" } },
                          [_vm._v("Range Wise Delivery Charges")]
                        ),
                      ]
                    ),
                  ]),
                  _vm._v(" "),
                  _vm.city.delivery_charge_method === "fixed_charge"
                    ? _c("div", { staticClass: "form-group" }, [
                        _vm._m(8),
                        _vm._v(" "),
                        _c("input", {
                          directives: [
                            {
                              name: "model",
                              rawName: "v-model",
                              value: _vm.city.fixed_charge,
                              expression: "city.fixed_charge",
                            },
                          ],
                          staticClass: "form-control",
                          attrs: {
                            type: "number",
                            name: "fixed_charge",
                            id: "fixed_charge",
                            placeholder: "Global Flat Charges",
                            min: "0",
                          },
                          domProps: { value: _vm.city.fixed_charge },
                          on: {
                            input: function ($event) {
                              if ($event.target.composing) {
                                return
                              }
                              _vm.$set(
                                _vm.city,
                                "fixed_charge",
                                $event.target.value
                              )
                            },
                          },
                        }),
                      ])
                    : _vm._e(),
                  _vm._v(" "),
                  _vm.city.delivery_charge_method === "per_km_charge"
                    ? _c("div", { staticClass: "form-group" }, [
                        _vm._m(9),
                        _vm._v(" "),
                        _c("input", {
                          directives: [
                            {
                              name: "model",
                              rawName: "v-model",
                              value: _vm.city.per_km_charge,
                              expression: "city.per_km_charge",
                            },
                          ],
                          staticClass: "form-control",
                          attrs: {
                            type: "number",
                            name: "per_km_charge",
                            id: "per_km_charge",
                            placeholder: "Per Kilometer Delivery Charge",
                            min: "0",
                          },
                          domProps: { value: _vm.city.per_km_charge },
                          on: {
                            input: function ($event) {
                              if ($event.target.composing) {
                                return
                              }
                              _vm.$set(
                                _vm.city,
                                "per_km_charge",
                                $event.target.value
                              )
                            },
                          },
                        }),
                      ])
                    : _vm._e(),
                  _vm._v(" "),
                  _vm.city.delivery_charge_method === "range_wise_charges"
                    ? _c(
                        "div",
                        { staticClass: "form-group col-sm-12" },
                        [
                          _vm._m(10),
                          _vm._v(" "),
                          _vm._l(
                            _vm.city.range_wise_charges,
                            function (range, index) {
                              return _c(
                                "div",
                                {
                                  key: (_vm.key = index + 1),
                                  staticClass: "form-group row",
                                },
                                [
                                  _c("div", { staticClass: "col-sm-1" }, [
                                    _vm._v(_vm._s(_vm.key) + "."),
                                  ]),
                                  _vm._v(" "),
                                  _c("div", { staticClass: "col-sm-3" }, [
                                    _c("input", {
                                      directives: [
                                        {
                                          name: "model",
                                          rawName: "v-model",
                                          value: range.from_range,
                                          expression: "range.from_range",
                                        },
                                      ],
                                      staticClass: "form-control",
                                      attrs: {
                                        type: "number",
                                        name: "from_range[]",
                                        id: "from_range",
                                        placeholder: "From Range",
                                        min: "0",
                                      },
                                      domProps: { value: range.from_range },
                                      on: {
                                        input: function ($event) {
                                          if ($event.target.composing) {
                                            return
                                          }
                                          _vm.$set(
                                            range,
                                            "from_range",
                                            $event.target.value
                                          )
                                        },
                                      },
                                    }),
                                  ]),
                                  _vm._v(" "),
                                  _c(
                                    "div",
                                    {
                                      staticClass: "col-sm-1 btn btn-secondary",
                                    },
                                    [_vm._v("To")]
                                  ),
                                  _vm._v(" "),
                                  _c("div", { staticClass: "col-sm-3" }, [
                                    _c("input", {
                                      directives: [
                                        {
                                          name: "model",
                                          rawName: "v-model",
                                          value: range.to_range,
                                          expression: "range.to_range",
                                        },
                                      ],
                                      staticClass: "form-control",
                                      attrs: {
                                        type: "number",
                                        name: "to_range[]",
                                        id: "to_range",
                                        placeholder: "To Range",
                                        min: "0",
                                      },
                                      domProps: { value: range.to_range },
                                      on: {
                                        focusout: function ($event) {
                                          return _vm.checkMaximumDistance()
                                        },
                                        input: function ($event) {
                                          if ($event.target.composing) {
                                            return
                                          }
                                          _vm.$set(
                                            range,
                                            "to_range",
                                            $event.target.value
                                          )
                                        },
                                      },
                                    }),
                                  ]),
                                  _vm._v(" "),
                                  _c("div", { staticClass: "col-sm-3" }, [
                                    _c("input", {
                                      directives: [
                                        {
                                          name: "model",
                                          rawName: "v-model",
                                          value: range.price,
                                          expression: "range.price",
                                        },
                                      ],
                                      staticClass: "form-control",
                                      attrs: {
                                        type: "number",
                                        name: "price[]",
                                        id: "price",
                                        placeholder: "Price",
                                        min: "0",
                                      },
                                      domProps: { value: range.price },
                                      on: {
                                        input: function ($event) {
                                          if ($event.target.composing) {
                                            return
                                          }
                                          _vm.$set(
                                            range,
                                            "price",
                                            $event.target.value
                                          )
                                        },
                                      },
                                    }),
                                  ]),
                                  _vm._v(" "),
                                  index === 0
                                    ? _c("div", { staticClass: "col-sm-1" }, [
                                        _c(
                                          "a",
                                          {
                                            directives: [
                                              {
                                                name: "b-tooltip",
                                                rawName: "v-b-tooltip.hover",
                                                modifiers: { hover: true },
                                              },
                                            ],
                                            staticStyle: { cursor: "pointer" },
                                            attrs: { title: "Add Row" },
                                            on: { click: _vm.addRow },
                                          },
                                          [
                                            _c("i", {
                                              staticClass:
                                                "fa fa-plus-square fa-2x",
                                            }),
                                          ]
                                        ),
                                      ])
                                    : _vm._e(),
                                  _vm._v(" "),
                                  index !== 0
                                    ? _c("div", { staticClass: "col-sm-1" }, [
                                        _c(
                                          "a",
                                          {
                                            directives: [
                                              {
                                                name: "b-tooltip",
                                                rawName: "v-b-tooltip.hover",
                                                modifiers: { hover: true },
                                              },
                                            ],
                                            staticStyle: { cursor: "pointer" },
                                            attrs: { title: "Remove Row" },
                                            on: {
                                              click: function ($event) {
                                                return _vm.remove(index)
                                              },
                                            },
                                          },
                                          [
                                            _c("i", {
                                              staticClass: "fa fa-times fa-2x",
                                            }),
                                          ]
                                        ),
                                      ])
                                    : _vm._e(),
                                ]
                              )
                            }
                          ),
                        ],
                        2
                      )
                    : _vm._e(),
                  _vm._v(" "),
                  _c("div", { staticClass: "form-group" }, [
                    _c(
                      "button",
                      {
                        staticClass: "btn btn-primary",
                        attrs: { type: "submit" },
                      },
                      [_vm._v(" " + _vm._s(_vm.__("save")))]
                    ),
                    _vm._v(" "),
                    _c(
                      "button",
                      {
                        staticClass: "btn btn-secondary",
                        attrs: { type: "reset" },
                      },
                      [_vm._v(_vm._s(_vm.__("clear")))]
                    ),
                  ]),
                ]
              ),
            ]),
          ]),
        ]),
        _vm._v(" "),
        _c("div", { staticClass: "col-6 col-md-6 order-md-1 order-last" }, [
          _c("div", { staticClass: "card h-100" }, [
            _vm._m(11),
            _vm._v(" "),
            _c("div", { staticClass: "card-body" }, [
              _c(
                "div",
                {
                  staticStyle: { position: "relative", overflow: "hidden" },
                  attrs: { id: "map" },
                },
                [
                  _c(
                    "GmapMap",
                    {
                      ref: "mapRef",
                      staticStyle: {
                        width: "100%",
                        height: "600px",
                        "margin-top": "20px",
                      },
                      attrs: {
                        center: _vm.center,
                        zoom: 13,
                        mapTypeControl: true,
                      },
                    },
                    [
                      _vm._l(_vm.markers, function (m, index) {
                        return _c("GmapMarker", {
                          key: index,
                          attrs: { position: m.position },
                          on: {
                            click: function ($event) {
                              _vm.center = m.position
                            },
                          },
                        })
                      }),
                      _vm._v(" "),
                      _c(
                        "gmap-info-window",
                        {
                          attrs: {
                            options: {
                              maxWidth: 300,
                              pixelOffset: { width: 0, height: -35 },
                            },
                            position: _vm.infoWindow.position,
                            opened: _vm.infoWindow.open,
                          },
                          on: {
                            closeclick: function ($event) {
                              _vm.infoWindow.open = false
                            },
                          },
                        },
                        [
                          _c("div", {
                            domProps: {
                              innerHTML: _vm._s(_vm.infoWindow.template),
                            },
                          }),
                        ]
                      ),
                    ],
                    2
                  ),
                ],
                1
              ),
              _vm._v(" "),
              _vm.city.formatted_address
                ? _c("div", [
                    _c("span", { staticClass: "title font-weight-bolder" }, [
                      _vm._v(_vm._s(_vm.city.formatted_address)),
                    ]),
                  ])
                : _vm._e(),
            ]),
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
    return _c("div", { staticClass: "col-12 col-md-6 order-md-1 order-last" }, [
      _c("h3", [_vm._v("Manage City")]),
    ])
  },
  function () {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("label", { attrs: { for: "latitude" } }, [
      _vm._v("Latitude "),
      _c("span", { staticClass: "text-danger text-sm" }, [_vm._v("*")]),
    ])
  },
  function () {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("label", { attrs: { for: "longitude" } }, [
      _vm._v("Longitude "),
      _c("span", { staticClass: "text-danger text-sm" }, [_vm._v("*")]),
    ])
  },
  function () {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("label", { attrs: { for: "name" } }, [
      _vm._v("City Name "),
      _c("span", { staticClass: "text-danger text-sm" }, [_vm._v("*")]),
    ])
  },
  function () {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("label", { attrs: { for: "state" } }, [
      _vm._v("State Name "),
      _c("span", { staticClass: "text-danger text-sm" }, [_vm._v("*")]),
    ])
  },
  function () {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("label", { attrs: { for: "time_to_travel" } }, [
      _vm._v("Time to travel 1 (km) "),
      _c("span", { staticClass: "text-danger text-sm" }, [_vm._v("*")]),
      _vm._v(" "),
      _c("small", [_vm._v("(Enter in minutes)")]),
    ])
  },
  function () {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("label", { attrs: { for: "max_deliverable_distance" } }, [
      _vm._v(" Maximum Delivarable Distance"),
      _c("span", { staticClass: "text-danger text-xs" }, [_vm._v("*")]),
      _vm._v(" "),
      _c("small", [_vm._v("[Kilometre]")]),
    ])
  },
  function () {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c(
      "label",
      {
        staticClass: " col-12 col-form-label",
        attrs: { for: "delivery_charge_method" },
      },
      [
        _vm._v(
          "Delivery Charge\n                                        Methods "
        ),
        _c("span", { staticClass: "text-danger text-sm" }, [_vm._v("*")]),
      ]
    )
  },
  function () {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("label", { attrs: { for: "fixed_charge" } }, [
      _vm._v("Fixed Delivery Charges "),
      _c("span", { staticClass: "text-danger text-sm" }, [_vm._v("*")]),
    ])
  },
  function () {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("label", { attrs: { for: "per_km_charge" } }, [
      _vm._v("Per KM Delivery Charges "),
      _c("span", { staticClass: "text-danger text-sm" }, [_vm._v("*")]),
    ])
  },
  function () {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("label", [
      _vm._v("Range Wise Delivery Charges "),
      _c("span", { staticClass: "text-danger text-sm" }, [_vm._v("* ")]),
      _vm._v(" "),
      _c("span", { staticClass: "text-secondary text-sm" }, [
        _vm._v(
          "(Set Proper ranges for delivery charge. Do not repeat the range value to next range. For e.g. 1-3,4-6)"
        ),
      ]),
    ])
  },
  function () {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("div", { staticClass: "card-header" }, [
      _c("h4", [_vm._v("Map View")]),
    ])
  },
]
render._withStripped = true



/***/ })

}]);