"use strict";
(self["webpackChunk"] = self["webpackChunk"] || []).push([["resources_js_views_Product_Products_vue"],{

/***/ "./node_modules/babel-loader/lib/index.js??clonedRuleSet-5[0].rules[0].use[0]!./node_modules/vue-loader/lib/index.js??vue-loader-options!./resources/js/views/Product/Products.vue?vue&type=script&lang=js&":
/*!******************************************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/babel-loader/lib/index.js??clonedRuleSet-5[0].rules[0].use[0]!./node_modules/vue-loader/lib/index.js??vue-loader-options!./resources/js/views/Product/Products.vue?vue&type=script&lang=js& ***!
  \******************************************************************************************************************************************************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony import */ var vuejs_datatable__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! vuejs-datatable */ "./node_modules/vuejs-datatable/dist/vuejs-datatable.esm.js");
/* harmony import */ var axios__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! axios */ "./node_modules/axios/index.js");
/* harmony import */ var axios__WEBPACK_IMPORTED_MODULE_1___default = /*#__PURE__*/__webpack_require__.n(axios__WEBPACK_IMPORTED_MODULE_1__);
/* harmony import */ var _Auth_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../../Auth.js */ "./resources/js/Auth.js");
function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _unsupportedIterableToArray(arr) || _nonIterableSpread(); }

function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _iterableToArray(iter) { if (typeof Symbol !== "undefined" && iter[Symbol.iterator] != null || iter["@@iterator"] != null) return Array.from(iter); }

function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) return _arrayLikeToArray(arr); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
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
  components: {
    VuejsDatatableFactory: vuejs_datatable__WEBPACK_IMPORTED_MODULE_0__.VuejsDatatableFactory
  },
  data: function data() {
    return {
      login_user: _Auth_js__WEBPACK_IMPORTED_MODULE_2__["default"].user,
      fields: [{
        key: 'select',
        label: '',
        visible: true
      }, {
        key: 'product_variant_id',
        label: __('id'),
        visible: true,
        sortable: true,
        sortDirection: 'desc'
      }, {
        key: 'product_id',
        label: __('product_id'),
        visible: true,
        sortable: true,
        sortDirection: 'desc'
      }, {
        key: 'tax_id',
        label: __('tax_id'),
        visible: false,
        sortable: true,
        "class": 'text-center'
      }, {
        key: 'seller_name',
        label: __('seller_name'),
        visible: true,
        "class": 'text-center',
        sortable: true
      }, {
        key: 'name',
        label: __('name'),
        visible: true,
        sortable: true,
        "class": 'text-center'
      }, {
        key: 'image',
        label: __('image'),
        visible: true,
        "class": 'text-center'
      }, {
        key: 'price',
        label: __('price') + '(' + this.$currency + ')',
        visible: true,
        "class": 'text-center',
        sortable: true
      }, {
        key: 'discounted_price',
        label: __('discounted_price') + '(' + this.$currency + ')',

        /*label: 'D.Price',*/
        visible: true,
        "class": 'text-center',
        sortable: true
      }, {
        key: 'measurement',
        label: __('measurement'),
        visible: true,
        "class": 'text-center',
        sortable: true
      }, {
        key: 'stock',
        label: __('stock'),
        visible: true,
        "class": 'text-center',
        sortable: true
      }, {
        key: 'availability',
        label: __('availability'),
        visible: true,
        "class": 'text-center',
        sortable: true
      }, {
        key: 'status',
        label: __('status'),
        visible: true,
        "class": 'text-center',
        sortable: true
      }, {
        key: 'indicator',
        label: __('indicator'),
        visible: false,
        "class": 'text-center',
        sortable: true
      }, {
        key: 'is_approved',
        label: __('is_approved'),
        visible: false,
        "class": 'text-center',
        sortable: true
      }, {
        key: 'return_status',
        label: __('return'),
        visible: false,
        "class": 'text-center',
        sortable: true
      }, {
        key: 'cancelable_status',
        label: __('cancellation'),
        visible: false,
        "class": 'text-center',
        sortable: true
      }, {
        key: 'till_status',
        label: __('till_status'),
        visible: false,
        "class": 'text-center',
        sortable: true
      }, {
        key: 'actions',
        label: __('actions'),
        visible: true
      }],
      totalRows: 1,
      currentPage: 1,
      perPage: this.$perPage,
      pageOptions: this.$pageOptions,
      sortBy: '',
      sortDesc: false,
      sortDirection: 'asc',
      filter: null,
      filterOn: [],
      categories: [],
      sellers: [],
      products: [],
      category: "",
      seller: "",
      is_approved: "",
      selectedItems: [],
      select: '',
      all_select: false,
      isLoading: false
    };
  },
  computed: {
    visibleFields: function visibleFields() {
      return this.fields.filter(function (field) {
        return field.visible;
      });
    }
  },
  mounted: function mounted() {},
  created: function created() {
    var _this = this;

    if (this.$roleSeller === this.login_user.role.name) {
      this.fields.forEach(function (field, index) {
        if (field.key === 'seller_name') {
          //delete this.fields[index];
          _this.fields.splice(index, 1);
        }
      });
    }

    this.getRecords();
  },
  methods: {
    getRecords: function getRecords() {
      var _this2 = this;

      this.isLoading = true;
      var param = {
        "category": this.category,
        "seller": this.seller,
        "is_approved": this.is_approved
      };
      axios__WEBPACK_IMPORTED_MODULE_1___default().get(this.$apiUrl + '/products', {
        params: param
      }).then(function (response) {
        _this2.isLoading = false;
        _this2.categories = response.data.data.categories;
        _this2.sellers = response.data.data.sellers;
        _this2.products = response.data.data.products;
        _this2.totalRows = _this2.products.length; //console.log("products =>", this.products);
      });
    },
    getSubCategories: function getSubCategories() {
      var _this3 = this;

      this.isLoading = true;
      var url = this.$apiUrl + '/subcategories';

      if (this.category_id) {
        url = this.$apiUrl + '/subcategories/' + this.category_id;
      }

      axios__WEBPACK_IMPORTED_MODULE_1___default().get(url).then(function (response) {
        _this3.isLoading = false;
        var data = response.data;
        _this3.subcategories = data.data;
      });
    },
    deleteRecord: function deleteRecord(index, id) {
      var _this4 = this;

      this.$swal.fire({
        title: "Are you Sure?",
        text: "You want be able to revert this",
        confirmButtonText: "Yes, Sure",
        cancelButtonText: "Cancel",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#37a279',
        cancelButtonColor: '#d33'
      }).then(function (result) {
        if (result.value) {
          _this4.isLoading = true;
          var postData = {
            id: id
          };
          axios__WEBPACK_IMPORTED_MODULE_1___default().post(_this4.$apiUrl + '/products/delete', postData).then(function (response) {
            _this4.isLoading = false;
            var data = response.data;

            _this4.products.splice(index, 1); //this.showSuccess(data.message);


            _this4.showMessage("success", data.message);
          });
        }
      });
    },
    updateStatusProduct: function updateStatusProduct(index, id) {
      var _this5 = this;

      this.$swal.fire({
        title: "Are you Sure?",
        text: "You want to change status.",
        confirmButtonText: "Yes, Sure",
        cancelButtonText: "Cancel",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#37a279',
        cancelButtonColor: '#d33'
      }).then(function (result) {
        if (result.value) {
          _this5.isLoading = true;
          var postData = {
            id: id
          };
          axios__WEBPACK_IMPORTED_MODULE_1___default().post(_this5.$apiUrl + '/products/change', postData).then(function (response) {
            _this5.isLoading = false; //this.customers.splice(index, 1)

            _this5.getRecords(); //this.showSuccess(response.data.message);


            _this5.showMessage("success", response.data.message);
          });
        }
      });
    },
    allSelectCheckBox: function allSelectCheckBox() {
      var _this6 = this;

      if (this.all_select == false) {
        this.all_select = true;
        this.products.forEach(function (product) {
          _this6.selectedItems.push(product.product_variant_id);
        });
      } else {
        this.all_select = false;
        this.selectedItems = [];
      }
    },
    selectCheckBox: function selectCheckBox() {
      var uniqueSelectedItems = _toConsumableArray(new Set(this.selectedItems));

      if (this.products.length === uniqueSelectedItems.length) {
        this.all_select = true;
      } else {
        this.all_select = false;
      }
    },
    multipleDelete: function multipleDelete() {
      var _this7 = this;

      var uniqueSelectedItems = _toConsumableArray(new Set(this.selectedItems));

      if (uniqueSelectedItems.length !== 0) {
        this.$swal.fire({
          title: "Are you Sure?",
          text: "You want be able to revert this",
          confirmButtonText: "Yes, Sure",
          cancelButtonText: "Cancel",
          icon: 'warning',
          showCancelButton: true,
          confirmButtonColor: '#37a279',
          cancelButtonColor: '#d33'
        }).then(function (result) {
          if (result.value) {
            var ids = uniqueSelectedItems.toString();
            _this7.isLoading = true;
            var postData = {
              ids: ids
            };
            axios__WEBPACK_IMPORTED_MODULE_1___default().post(_this7.$apiUrl + '/products/multiple_delete', postData).then(function (response) {
              _this7.isLoading = false;
              var data = response.data; //this.products.splice(index, 1)

              _this7.getRecords();

              _this7.selectedItems = [];
              _this7.all_select = false; //this.all_select === true ? this.all_select = false : this.all_select = true;
              //this.showSuccess(data.message);

              _this7.showMessage("success", data.message);
            });
          }
        });
      } else {
        this.showWarning("Select at least one record!");
      }
    }
  }
});

/***/ }),

/***/ "./resources/js/views/Product/Products.vue":
/*!*************************************************!*\
  !*** ./resources/js/views/Product/Products.vue ***!
  \*************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony import */ var _Products_vue_vue_type_template_id_560efc7a___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./Products.vue?vue&type=template&id=560efc7a& */ "./resources/js/views/Product/Products.vue?vue&type=template&id=560efc7a&");
/* harmony import */ var _Products_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./Products.vue?vue&type=script&lang=js& */ "./resources/js/views/Product/Products.vue?vue&type=script&lang=js&");
/* harmony import */ var _node_modules_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! !../../../../node_modules/vue-loader/lib/runtime/componentNormalizer.js */ "./node_modules/vue-loader/lib/runtime/componentNormalizer.js");





/* normalize component */
;
var component = (0,_node_modules_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_2__["default"])(
  _Products_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__["default"],
  _Products_vue_vue_type_template_id_560efc7a___WEBPACK_IMPORTED_MODULE_0__.render,
  _Products_vue_vue_type_template_id_560efc7a___WEBPACK_IMPORTED_MODULE_0__.staticRenderFns,
  false,
  null,
  null,
  null
  
)

/* hot reload */
if (false) { var api; }
component.options.__file = "resources/js/views/Product/Products.vue"
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = (component.exports);

/***/ }),

/***/ "./resources/js/views/Product/Products.vue?vue&type=script&lang=js&":
/*!**************************************************************************!*\
  !*** ./resources/js/views/Product/Products.vue?vue&type=script&lang=js& ***!
  \**************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony import */ var _node_modules_babel_loader_lib_index_js_clonedRuleSet_5_0_rules_0_use_0_node_modules_vue_loader_lib_index_js_vue_loader_options_Products_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../node_modules/babel-loader/lib/index.js??clonedRuleSet-5[0].rules[0].use[0]!../../../../node_modules/vue-loader/lib/index.js??vue-loader-options!./Products.vue?vue&type=script&lang=js& */ "./node_modules/babel-loader/lib/index.js??clonedRuleSet-5[0].rules[0].use[0]!./node_modules/vue-loader/lib/index.js??vue-loader-options!./resources/js/views/Product/Products.vue?vue&type=script&lang=js&");
 /* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = (_node_modules_babel_loader_lib_index_js_clonedRuleSet_5_0_rules_0_use_0_node_modules_vue_loader_lib_index_js_vue_loader_options_Products_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__["default"]); 

/***/ }),

/***/ "./resources/js/views/Product/Products.vue?vue&type=template&id=560efc7a&":
/*!********************************************************************************!*\
  !*** ./resources/js/views/Product/Products.vue?vue&type=template&id=560efc7a& ***!
  \********************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "render": () => (/* reexport safe */ _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_Products_vue_vue_type_template_id_560efc7a___WEBPACK_IMPORTED_MODULE_0__.render),
/* harmony export */   "staticRenderFns": () => (/* reexport safe */ _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_Products_vue_vue_type_template_id_560efc7a___WEBPACK_IMPORTED_MODULE_0__.staticRenderFns)
/* harmony export */ });
/* harmony import */ var _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_Products_vue_vue_type_template_id_560efc7a___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!../../../../node_modules/vue-loader/lib/index.js??vue-loader-options!./Products.vue?vue&type=template&id=560efc7a& */ "./node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!./node_modules/vue-loader/lib/index.js??vue-loader-options!./resources/js/views/Product/Products.vue?vue&type=template&id=560efc7a&");


/***/ }),

/***/ "./node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!./node_modules/vue-loader/lib/index.js??vue-loader-options!./resources/js/views/Product/Products.vue?vue&type=template&id=560efc7a&":
/*!***********************************************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!./node_modules/vue-loader/lib/index.js??vue-loader-options!./resources/js/views/Product/Products.vue?vue&type=template&id=560efc7a& ***!
  \***********************************************************************************************************************************************************************************************************************/
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
        _c("div", { staticClass: "col-12 col-md-6 order-md-1 order-last" }, [
          _c("h3", [_vm._v(_vm._s(_vm.__("manage_products")))]),
        ]),
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
                  [_vm._v(_vm._s(_vm.__("manage_products")))]
                ),
              ]),
            ]
          ),
        ]),
      ]),
      _vm._v(" "),
      _c("div", { staticClass: "row" }, [
        _c("div", { staticClass: "col-12 col-md-12 order-md-1 order-last" }, [
          _c("div", { staticClass: "card" }, [
            _c("div", { staticClass: "card-header" }, [
              _c("h4", [_vm._v(_vm._s(_vm.__("products")))]),
              _vm._v(" "),
              _c(
                "span",
                { staticClass: "pull-right" },
                [
                  _vm.$roleSeller == _vm.login_user.role.name
                    ? [
                        _c(
                          "router-link",
                          {
                            directives: [
                              {
                                name: "b-tooltip",
                                rawName: "v-b-tooltip.hover",
                                modifiers: { hover: true },
                              },
                            ],
                            staticClass: "btn btn-primary",
                            attrs: {
                              to: "/seller/manage_products/create",
                              title: "Add Product",
                            },
                          },
                          [_vm._v(_vm._s(_vm.__("add_product")))]
                        ),
                      ]
                    : [
                        _c(
                          "router-link",
                          {
                            directives: [
                              {
                                name: "b-tooltip",
                                rawName: "v-b-tooltip.hover",
                                modifiers: { hover: true },
                              },
                            ],
                            staticClass: "btn btn-primary",
                            attrs: {
                              to: "/manage_products/create",
                              title: "Add Product",
                            },
                          },
                          [_vm._v(_vm._s(_vm.__("add_product")))]
                        ),
                      ],
                ],
                2
              ),
            ]),
            _vm._v(" "),
            _c(
              "div",
              { staticClass: "card-body" },
              [
                _c("div", { staticClass: "row" }, [
                  _c(
                    "div",
                    { staticClass: "form-group col-md-3" },
                    [
                      _c(
                        "b-dropdown",
                        {
                          staticClass: "m-2",
                          attrs: {
                            size: "sm",
                            dropright: "",
                            text: _vm.__("actions"),
                            "split-variant": "outline-primary",
                            variant: "primary",
                            disabled: _vm.selectedItems.length === 0,
                          },
                        },
                        [
                          _c(
                            "b-dropdown-item",
                            {
                              attrs: { href: "javascript:void(0);" },
                              on: { click: _vm.multipleDelete },
                            },
                            [
                              _c(
                                "span",
                                {
                                  staticClass: "text-danger",
                                  staticStyle: { "font-weight": "bold" },
                                },
                                [
                                  _c("i", { staticClass: "fa fa-trash" }),
                                  _vm._v(
                                    " " +
                                      _vm._s(_vm.__("delete_selected_products"))
                                  ),
                                ]
                              ),
                            ]
                          ),
                        ],
                        1
                      ),
                    ],
                    1
                  ),
                ]),
                _vm._v(" "),
                _c(
                  "b-row",
                  { staticClass: "mb-2" },
                  [
                    _c("b-col", { attrs: { md: "2" } }, [
                      _c("h6", { staticClass: "box-title" }, [
                        _vm._v(_vm._s(_vm.__("filter_by_products_category"))),
                      ]),
                      _vm._v(" "),
                      _c("form", { attrs: { method: "post" } }, [
                        _c(
                          "select",
                          {
                            directives: [
                              {
                                name: "model",
                                rawName: "v-model",
                                value: _vm.category,
                                expression: "category",
                              },
                            ],
                            staticClass: "form-control form-select",
                            on: {
                              change: [
                                function ($event) {
                                  var $$selectedVal = Array.prototype.filter
                                    .call($event.target.options, function (o) {
                                      return o.selected
                                    })
                                    .map(function (o) {
                                      var val =
                                        "_value" in o ? o._value : o.value
                                      return val
                                    })
                                  _vm.category = $event.target.multiple
                                    ? $$selectedVal
                                    : $$selectedVal[0]
                                },
                                function ($event) {
                                  return _vm.getRecords()
                                },
                              ],
                            },
                          },
                          [
                            _c("option", { attrs: { value: "" } }, [
                              _vm._v("All Categories"),
                            ]),
                            _vm._v(" "),
                            _vm._l(_vm.categories, function (category) {
                              return _c(
                                "option",
                                { domProps: { value: category.id } },
                                [
                                  _vm._v(
                                    "\n                                                " +
                                      _vm._s(category.name) +
                                      "\n                                            "
                                  ),
                                ]
                              )
                            }),
                          ],
                          2
                        ),
                      ]),
                    ]),
                    _vm._v(" "),
                    _c("b-col", { attrs: { md: "2" } }, [
                      _c("h6", { staticClass: "box-title" }, [
                        _vm._v(
                          _vm._s(_vm.__("filter_products_by_status")) + " "
                        ),
                      ]),
                      _vm._v(" "),
                      _c(
                        "select",
                        {
                          directives: [
                            {
                              name: "model",
                              rawName: "v-model",
                              value: _vm.is_approved,
                              expression: "is_approved",
                            },
                          ],
                          staticClass: "form-control form-select",
                          attrs: { id: "is_approved", name: "is_approved" },
                          on: {
                            change: [
                              function ($event) {
                                var $$selectedVal = Array.prototype.filter
                                  .call($event.target.options, function (o) {
                                    return o.selected
                                  })
                                  .map(function (o) {
                                    var val = "_value" in o ? o._value : o.value
                                    return val
                                  })
                                _vm.is_approved = $event.target.multiple
                                  ? $$selectedVal
                                  : $$selectedVal[0]
                              },
                              function ($event) {
                                return _vm.getRecords()
                              },
                            ],
                          },
                        },
                        [
                          _c("option", { attrs: { value: "" } }, [
                            _vm._v("Select Status"),
                          ]),
                          _vm._v(" "),
                          _c("option", { attrs: { value: "1" } }, [
                            _vm._v("Approved"),
                          ]),
                          _vm._v(" "),
                          _c("option", { attrs: { value: "2" } }, [
                            _vm._v("Not-Approved"),
                          ]),
                        ]
                      ),
                    ]),
                    _vm._v(" "),
                    _vm.$roleSeller == _vm.login_user.role.name
                      ? [
                          _c("input", {
                            directives: [
                              {
                                name: "model",
                                rawName: "v-model",
                                value: (_vm.seller = _vm.login_user.seller.id),
                                expression: "seller = login_user.seller.id",
                              },
                            ],
                            attrs: { type: "hidden" },
                            domProps: {
                              value: (_vm.seller = _vm.login_user.seller.id),
                            },
                            on: {
                              input: function ($event) {
                                if ($event.target.composing) {
                                  return
                                }
                                _vm.$set(
                                  (_vm.seller = _vm.login_user.seller),
                                  "id",
                                  $event.target.value
                                )
                              },
                            },
                          }),
                        ]
                      : [
                          _c("b-col", { attrs: { md: "3" } }, [
                            _c("h6", { staticClass: "box-title" }, [
                              _vm._v(
                                _vm._s(_vm.__("filter_products_by_seller")) +
                                  " "
                              ),
                            ]),
                            _vm._v(" "),
                            _c(
                              "select",
                              {
                                directives: [
                                  {
                                    name: "model",
                                    rawName: "v-model",
                                    value: _vm.seller,
                                    expression: "seller",
                                  },
                                ],
                                staticClass: "form-control form-select",
                                on: {
                                  change: [
                                    function ($event) {
                                      var $$selectedVal = Array.prototype.filter
                                        .call(
                                          $event.target.options,
                                          function (o) {
                                            return o.selected
                                          }
                                        )
                                        .map(function (o) {
                                          var val =
                                            "_value" in o ? o._value : o.value
                                          return val
                                        })
                                      _vm.seller = $event.target.multiple
                                        ? $$selectedVal
                                        : $$selectedVal[0]
                                    },
                                    function ($event) {
                                      return _vm.getRecords()
                                    },
                                  ],
                                },
                              },
                              [
                                _c("option", { attrs: { value: "" } }, [
                                  _vm._v("All Sellers"),
                                ]),
                                _vm._v(" "),
                                _vm._l(_vm.sellers, function (seller) {
                                  return _c(
                                    "option",
                                    { domProps: { value: seller.id } },
                                    [_vm._v(_vm._s(seller.name))]
                                  )
                                }),
                              ],
                              2
                            ),
                          ]),
                        ],
                    _vm._v(" "),
                    _c(
                      "b-col",
                      {
                        class:
                          _vm.$roleSeller == _vm.login_user.role.name
                            ? "offset-3"
                            : "",
                        attrs: { md: "3" },
                      },
                      [
                        _c("h6", { staticClass: "box-title" }, [
                          _vm._v(_vm._s(_vm.__("search"))),
                        ]),
                        _vm._v(" "),
                        _c("b-form-input", {
                          attrs: {
                            id: "filter-input",
                            type: "search",
                            placeholder: _vm.__("search"),
                          },
                          model: {
                            value: _vm.filter,
                            callback: function ($$v) {
                              _vm.filter = $$v
                            },
                            expression: "filter",
                          },
                        }),
                      ],
                      1
                    ),
                    _vm._v(" "),
                    _c(
                      "b-col",
                      { staticClass: "text-center", attrs: { md: "2" } },
                      [
                        _c(
                          "div",
                          {
                            staticClass: "btn-group btn_tool",
                            attrs: {
                              role: "group",
                              "aria-label": "Basic example",
                            },
                          },
                          [
                            _c(
                              "button",
                              {
                                directives: [
                                  {
                                    name: "b-tooltip",
                                    rawName: "v-b-tooltip.hover",
                                    modifiers: { hover: true },
                                  },
                                ],
                                staticClass: "btn btn-primary",
                                attrs: {
                                  type: "button",
                                  title: _vm.__("refresh"),
                                },
                                on: {
                                  click: function ($event) {
                                    return _vm.getRecords()
                                  },
                                },
                              },
                              [
                                _c("i", {
                                  staticClass: "fa fa-refresh",
                                  attrs: { "aria-hidden": "true" },
                                }),
                              ]
                            ),
                            _vm._v(" "),
                            _c(
                              "b-dropdown",
                              {
                                directives: [
                                  {
                                    name: "b-tooltip",
                                    rawName: "v-b-tooltip.hover",
                                    modifiers: { hover: true },
                                  },
                                ],
                                attrs: {
                                  dropleft: "",
                                  "menu-class": "w-100 border dropdownOverflow",
                                  title: "Columns",
                                },
                                scopedSlots: _vm._u([
                                  {
                                    key: "button-content",
                                    fn: function () {
                                      return [
                                        _c("i", {
                                          staticClass: "fa fa-th-list",
                                        }),
                                      ]
                                    },
                                    proxy: true,
                                  },
                                ]),
                              },
                              [
                                _vm._v(" "),
                                _vm._l(_vm.fields, function (field) {
                                  return field.key !== "select"
                                    ? _c(
                                        "li",
                                        { key: field.key, staticClass: "m-1" },
                                        [
                                          _c("input", {
                                            directives: [
                                              {
                                                name: "model",
                                                rawName: "v-model",
                                                value: field.visible,
                                                expression: "field.visible",
                                              },
                                            ],
                                            staticClass: "form-check-input",
                                            attrs: {
                                              type: "checkbox",
                                              id: field.key,
                                              disabled:
                                                _vm.visibleFields.length == 1 &&
                                                field.visible,
                                            },
                                            domProps: {
                                              checked: Array.isArray(
                                                field.visible
                                              )
                                                ? _vm._i(field.visible, null) >
                                                  -1
                                                : field.visible,
                                            },
                                            on: {
                                              change: function ($event) {
                                                var $$a = field.visible,
                                                  $$el = $event.target,
                                                  $$c = $$el.checked
                                                    ? true
                                                    : false
                                                if (Array.isArray($$a)) {
                                                  var $$v = null,
                                                    $$i = _vm._i($$a, $$v)
                                                  if ($$el.checked) {
                                                    $$i < 0 &&
                                                      _vm.$set(
                                                        field,
                                                        "visible",
                                                        $$a.concat([$$v])
                                                      )
                                                  } else {
                                                    $$i > -1 &&
                                                      _vm.$set(
                                                        field,
                                                        "visible",
                                                        $$a
                                                          .slice(0, $$i)
                                                          .concat(
                                                            $$a.slice($$i + 1)
                                                          )
                                                      )
                                                  }
                                                } else {
                                                  _vm.$set(
                                                    field,
                                                    "visible",
                                                    $$c
                                                  )
                                                }
                                              },
                                            },
                                          }),
                                          _vm._v(" "),
                                          _c(
                                            "label",
                                            { attrs: { for: field.key } },
                                            [_vm._v(_vm._s(field.label))]
                                          ),
                                          _vm._v(" "),
                                          _c("b-dropdown-divider"),
                                        ],
                                        1
                                      )
                                    : _vm._e()
                                }),
                              ],
                              2
                            ),
                          ],
                          1
                        ),
                        _vm._v(" "),
                        _c(
                          "b-sidebar",
                          {
                            attrs: {
                              id: "sidebar-right",
                              title: "Sidebar",
                              backdrop: "",
                              right: "",
                              shadow: "",
                            },
                          },
                          [
                            _c(
                              "div",
                              { staticClass: "px-3 py-2" },
                              [
                                _c("p", [
                                  _vm._v(
                                    "\n                                                Cras mattis consectetur purus sit amet fermentum. Cras justo odio, dapibus ac facilisis\n                                                in, egestas eget quam. Morbi leo risus, porta ac consectetur ac, vestibulum at eros.\n                                            "
                                  ),
                                ]),
                                _vm._v(" "),
                                _c("b-img", {
                                  attrs: {
                                    src: "https://picsum.photos/500/500/?image=54",
                                    fluid: "",
                                    thumbnail: "",
                                  },
                                }),
                              ],
                              1
                            ),
                          ]
                        ),
                      ],
                      1
                    ),
                  ],
                  2
                ),
                _vm._v(" "),
                _c(
                  "div",
                  { staticClass: "table-responsive" },
                  [
                    _c("b-table", {
                      attrs: {
                        items: _vm.products,
                        fields: _vm.visibleFields,
                        "current-page": _vm.currentPage,
                        "per-page": _vm.perPage,
                        filter: _vm.filter,
                        "filter-included-fields": _vm.filterOn,
                        "sort-by": _vm.sortBy,
                        "sort-desc": _vm.sortDesc,
                        "sort-direction": _vm.sortDirection,
                        bordered: true,
                        busy: _vm.isLoading,
                        stacked: "md",
                        "show-empty": "",
                        small: "",
                      },
                      on: {
                        "update:sortBy": function ($event) {
                          _vm.sortBy = $event
                        },
                        "update:sort-by": function ($event) {
                          _vm.sortBy = $event
                        },
                        "update:sortDesc": function ($event) {
                          _vm.sortDesc = $event
                        },
                        "update:sort-desc": function ($event) {
                          _vm.sortDesc = $event
                        },
                      },
                      scopedSlots: _vm._u([
                        {
                          key: "table-busy",
                          fn: function () {
                            return [
                              _c(
                                "div",
                                { staticClass: "text-center text-black my-2" },
                                [
                                  _c("b-spinner", {
                                    staticClass: "align-middle",
                                  }),
                                  _vm._v(" "),
                                  _c("strong", [
                                    _vm._v(_vm._s(_vm.__("loading")) + "..."),
                                  ]),
                                ],
                                1
                              ),
                            ]
                          },
                          proxy: true,
                        },
                        {
                          key: "head(select)",
                          fn: function (row) {
                            return [
                              _c("input", {
                                directives: [
                                  {
                                    name: "model",
                                    rawName: "v-model",
                                    value: _vm.all_select,
                                    expression: "all_select",
                                  },
                                ],
                                staticClass: "form-check-input",
                                attrs: { type: "checkbox" },
                                domProps: {
                                  checked: Array.isArray(_vm.all_select)
                                    ? _vm._i(_vm.all_select, null) > -1
                                    : _vm.all_select,
                                },
                                on: {
                                  click: _vm.allSelectCheckBox,
                                  change: function ($event) {
                                    var $$a = _vm.all_select,
                                      $$el = $event.target,
                                      $$c = $$el.checked ? true : false
                                    if (Array.isArray($$a)) {
                                      var $$v = null,
                                        $$i = _vm._i($$a, $$v)
                                      if ($$el.checked) {
                                        $$i < 0 &&
                                          (_vm.all_select = $$a.concat([$$v]))
                                      } else {
                                        $$i > -1 &&
                                          (_vm.all_select = $$a
                                            .slice(0, $$i)
                                            .concat($$a.slice($$i + 1)))
                                      }
                                    } else {
                                      _vm.all_select = $$c
                                    }
                                  },
                                },
                              }),
                            ]
                          },
                        },
                        {
                          key: "cell(select)",
                          fn: function (row) {
                            return [
                              _c("input", {
                                directives: [
                                  {
                                    name: "model",
                                    rawName: "v-model",
                                    value: _vm.selectedItems,
                                    expression: "selectedItems",
                                  },
                                ],
                                staticClass: "form-check-input",
                                attrs: { type: "checkbox" },
                                domProps: {
                                  value: "" + row.item.product_variant_id,
                                  checked: Array.isArray(_vm.selectedItems)
                                    ? _vm._i(
                                        _vm.selectedItems,
                                        "" + row.item.product_variant_id
                                      ) > -1
                                    : _vm.selectedItems,
                                },
                                on: {
                                  change: [
                                    function ($event) {
                                      var $$a = _vm.selectedItems,
                                        $$el = $event.target,
                                        $$c = $$el.checked ? true : false
                                      if (Array.isArray($$a)) {
                                        var $$v =
                                            "" + row.item.product_variant_id,
                                          $$i = _vm._i($$a, $$v)
                                        if ($$el.checked) {
                                          $$i < 0 &&
                                            (_vm.selectedItems = $$a.concat([
                                              $$v,
                                            ]))
                                        } else {
                                          $$i > -1 &&
                                            (_vm.selectedItems = $$a
                                              .slice(0, $$i)
                                              .concat($$a.slice($$i + 1)))
                                        }
                                      } else {
                                        _vm.selectedItems = $$c
                                      }
                                    },
                                    _vm.selectCheckBox,
                                  ],
                                },
                              }),
                            ]
                          },
                        },
                        {
                          key: "cell(seller_name)",
                          fn: function (row) {
                            return [
                              _vm._v(
                                "\n                                        " +
                                  _vm._s(row.item.seller_name) +
                                  "\n                                    "
                              ),
                            ]
                          },
                        },
                        {
                          key: "cell(image)",
                          fn: function (row) {
                            return [
                              row.item.image
                                ? _c("img", {
                                    attrs: {
                                      src: _vm.$storageUrl + row.item.image,
                                      height: "50",
                                    },
                                  })
                                : _vm._e(),
                            ]
                          },
                        },
                        {
                          key: "cell(measurement)",
                          fn: function (row) {
                            return [
                              _vm._v(
                                "\n                                        " +
                                  _vm._s(row.item.measurement) +
                                  "\n                                    "
                              ),
                            ]
                          },
                        },
                        {
                          key: "cell(stock)",
                          fn: function (row) {
                            return [
                              row.item.is_unlimited_stock
                                ? _c("span", [_vm._v("Unlimited")])
                                : [
                                    _vm._v(
                                      "\n                                            " +
                                        _vm._s(row.item.stock) +
                                        " "
                                    ),
                                    row.item.stock_unit
                                      ? _c("span", [
                                          _vm._v(_vm._s(row.item.stock_unit)),
                                        ])
                                      : _vm._e(),
                                  ],
                            ]
                          },
                        },
                        {
                          key: "cell(availability)",
                          fn: function (row) {
                            return [
                              _vm.$can("product_update")
                                ? _c(
                                    "a",
                                    {
                                      staticClass: "btn btn-sm",
                                      on: {
                                        click: function ($event) {
                                          return _vm.updateStatusProduct(
                                            row.index,
                                            row.item.id
                                          )
                                        },
                                      },
                                    },
                                    [
                                      row.item.status == 1
                                        ? _c(
                                            "span",
                                            { staticClass: "primary-toggal" },
                                            [
                                              _c("i", {
                                                staticClass:
                                                  "fa fa-toggle-on fa-2x",
                                              }),
                                            ]
                                          )
                                        : _c(
                                            "span",
                                            { staticClass: "text-danger" },
                                            [
                                              _c("i", {
                                                staticClass:
                                                  "fa fa-toggle-off fa-2x",
                                              }),
                                            ]
                                          ),
                                    ]
                                  )
                                : _vm._e(),
                            ]
                          },
                        },
                        {
                          key: "cell(status)",
                          fn: function (row) {
                            return [
                              row.item.status == 1
                                ? _c(
                                    "span",
                                    { staticClass: "badge bg-success" },
                                    [_vm._v("Available")]
                                  )
                                : _vm._e(),
                              _vm._v(" "),
                              row.item.status == 0
                                ? _c(
                                    "span",
                                    { staticClass: "badge bg-danger" },
                                    [_vm._v("Sold Out")]
                                  )
                                : _vm._e(),
                            ]
                          },
                        },
                        {
                          key: "cell(indicator)",
                          fn: function (row) {
                            return [
                              row.item.indicator == 0
                                ? _c("span", { staticClass: "badge bg-info" }, [
                                    _vm._v("None"),
                                  ])
                                : _vm._e(),
                              _vm._v(" "),
                              row.item.indicator == 1
                                ? _c(
                                    "span",
                                    { staticClass: "badge bg-success" },
                                    [_vm._v("Veg")]
                                  )
                                : _vm._e(),
                              _vm._v(" "),
                              row.item.indicator == 2
                                ? _c(
                                    "span",
                                    { staticClass: "badge bg-danger" },
                                    [_vm._v("Non-Veg")]
                                  )
                                : _vm._e(),
                            ]
                          },
                        },
                        {
                          key: "cell(is_approved)",
                          fn: function (row) {
                            return [
                              row.item.is_approved == 1
                                ? _c(
                                    "span",
                                    { staticClass: "badge bg-success" },
                                    [_vm._v("Approved")]
                                  )
                                : _vm._e(),
                              _vm._v(" "),
                              row.item.is_approved == 0
                                ? _c(
                                    "span",
                                    { staticClass: "badge bg-danger" },
                                    [_vm._v("Not-Approved")]
                                  )
                                : _vm._e(),
                            ]
                          },
                        },
                        {
                          key: "cell(return_status)",
                          fn: function (row) {
                            return [
                              row.item.return_status == 0
                                ? _c(
                                    "span",
                                    { staticClass: "badge bg-danger" },
                                    [_vm._v("Not-Allowed")]
                                  )
                                : _vm._e(),
                              _vm._v(" "),
                              row.item.return_status == 1
                                ? _c(
                                    "span",
                                    { staticClass: "badge bg-success" },
                                    [_vm._v("Allowed")]
                                  )
                                : _vm._e(),
                            ]
                          },
                        },
                        {
                          key: "cell(cancelable_status)",
                          fn: function (row) {
                            return [
                              row.item.cancelable_status === 0
                                ? _c(
                                    "span",
                                    { staticClass: "badge bg-danger" },
                                    [_vm._v("Not-Allowed")]
                                  )
                                : _vm._e(),
                              _vm._v(" "),
                              row.item.cancelable_status == 1
                                ? _c(
                                    "span",
                                    { staticClass: "badge bg-success" },
                                    [_vm._v("Allowed")]
                                  )
                                : _vm._e(),
                            ]
                          },
                        },
                        {
                          key: "cell(till_status)",
                          fn: function (row) {
                            return [
                              row.item.till_status == "0"
                                ? _c(
                                    "span",
                                    { staticClass: "badge bg-danger" },
                                    [_vm._v("Not Applicable")]
                                  )
                                : _vm._e(),
                              _vm._v(" "),
                              row.item.till_status == "2"
                                ? _c(
                                    "span",
                                    { staticClass: "badge bg-success" },
                                    [_vm._v(_vm._s(row.item.till_status_name))]
                                  )
                                : _vm._e(),
                              _vm._v(" "),
                              row.item.till_status == "3"
                                ? _c(
                                    "span",
                                    { staticClass: "badge bg-success" },
                                    [_vm._v(_vm._s(row.item.till_status_name))]
                                  )
                                : _vm._e(),
                              _vm._v(" "),
                              row.item.till_status == "4"
                                ? _c(
                                    "span",
                                    { staticClass: "badge bg-success" },
                                    [_vm._v(_vm._s(row.item.till_status_name))]
                                  )
                                : _vm._e(),
                              _vm._v(" "),
                              row.item.till_status == "6"
                                ? _c(
                                    "span",
                                    { staticClass: "badge bg-success" },
                                    [_vm._v(_vm._s(row.item.till_status_name))]
                                  )
                                : _vm._e(),
                            ]
                          },
                        },
                        {
                          key: "cell(actions)",
                          fn: function (row) {
                            return [
                              _c(
                                "div",
                                { staticStyle: { width: "120px" } },
                                [
                                  _vm.$roleSeller == _vm.login_user.role.name
                                    ? [
                                        _c(
                                          "router-link",
                                          {
                                            directives: [
                                              {
                                                name: "b-tooltip",
                                                rawName: "v-b-tooltip.hover",
                                                modifiers: { hover: true },
                                              },
                                            ],
                                            staticClass:
                                              "btn btn-primary btn-sm",
                                            attrs: {
                                              to: {
                                                name: "SellerViewProduct",
                                                params: {
                                                  id: row.item.id,
                                                  record: row.item,
                                                },
                                              },
                                              title: _vm.__("view"),
                                            },
                                          },
                                          [
                                            _c("i", {
                                              staticClass: "fa fa-eye",
                                            }),
                                          ]
                                        ),
                                        _vm._v(" "),
                                        _vm.$can("product_update")
                                          ? _c(
                                              "router-link",
                                              {
                                                directives: [
                                                  {
                                                    name: "b-tooltip",
                                                    rawName:
                                                      "v-b-tooltip.hover",
                                                    modifiers: { hover: true },
                                                  },
                                                ],
                                                staticClass:
                                                  "btn btn-success btn-sm",
                                                attrs: {
                                                  to: {
                                                    name: "SellerEditProduct",
                                                    params: {
                                                      id: row.item.id,
                                                      record: row.item,
                                                    },
                                                  },
                                                  title: _vm.__("edit"),
                                                },
                                              },
                                              [
                                                _c("i", {
                                                  staticClass: "fa fa-pencil",
                                                }),
                                              ]
                                            )
                                          : _vm._e(),
                                      ]
                                    : [
                                        _c(
                                          "router-link",
                                          {
                                            directives: [
                                              {
                                                name: "b-tooltip",
                                                rawName: "v-b-tooltip.hover",
                                                modifiers: { hover: true },
                                              },
                                            ],
                                            staticClass:
                                              "btn btn-primary btn-sm",
                                            attrs: {
                                              to: {
                                                name: "ViewProduct",
                                                params: {
                                                  id: row.item.id,
                                                  record: row.item,
                                                },
                                              },
                                              title: _vm.__("view"),
                                            },
                                          },
                                          [
                                            _c("i", {
                                              staticClass: "fa fa-eye",
                                            }),
                                          ]
                                        ),
                                        _vm._v(" "),
                                        _vm.$can("product_update")
                                          ? _c(
                                              "router-link",
                                              {
                                                directives: [
                                                  {
                                                    name: "b-tooltip",
                                                    rawName:
                                                      "v-b-tooltip.hover",
                                                    modifiers: { hover: true },
                                                  },
                                                ],
                                                staticClass:
                                                  "btn btn-success btn-sm",
                                                attrs: {
                                                  to: {
                                                    name: "EditProduct",
                                                    params: {
                                                      id: row.item.id,
                                                      record: row.item,
                                                    },
                                                  },
                                                  title: _vm.__("edit"),
                                                },
                                              },
                                              [
                                                _c("i", {
                                                  staticClass: "fa fa-pencil",
                                                }),
                                              ]
                                            )
                                          : _vm._e(),
                                      ],
                                  _vm._v(" "),
                                  _vm.$can("product_delete")
                                    ? _c(
                                        "button",
                                        {
                                          directives: [
                                            {
                                              name: "b-tooltip",
                                              rawName: "v-b-tooltip.hover",
                                              modifiers: { hover: true },
                                            },
                                          ],
                                          staticClass: "btn btn-danger btn-sm",
                                          attrs: { title: _vm.__("delete") },
                                          on: {
                                            click: function ($event) {
                                              return _vm.deleteRecord(
                                                row.index,
                                                row.item.product_variant_id
                                              )
                                            },
                                          },
                                        },
                                        [
                                          _c("i", {
                                            staticClass: "fa fa-trash",
                                          }),
                                        ]
                                      )
                                    : _vm._e(),
                                ],
                                2
                              ),
                            ]
                          },
                        },
                      ]),
                    }),
                  ],
                  1
                ),
                _vm._v(" "),
                _c(
                  "b-row",
                  [
                    _c("b-col", { attrs: { md: "2" } }, [
                      _c(
                        "label",
                        [
                          _c(
                            "b-form-group",
                            {
                              staticClass: "mb-0",
                              attrs: {
                                label: _vm.__("per_page"),
                                "label-for": "per-page-select",
                                "label-align-sm": "right",
                                "label-size": "sm",
                              },
                            },
                            [
                              _c("b-form-select", {
                                staticClass: "form-control form-select",
                                attrs: {
                                  id: "per-page-select",
                                  options: _vm.pageOptions,
                                  size: "sm",
                                },
                                model: {
                                  value: _vm.perPage,
                                  callback: function ($$v) {
                                    _vm.perPage = $$v
                                  },
                                  expression: "perPage",
                                },
                              }),
                            ],
                            1
                          ),
                        ],
                        1
                      ),
                    ]),
                    _vm._v(" "),
                    _c(
                      "b-col",
                      { attrs: { md: "4", "offset-md": "6" } },
                      [
                        _c("label", [
                          _vm._v(
                            "Total Records :- " + _vm._s(_vm.totalRows) + " "
                          ),
                        ]),
                        _vm._v(" "),
                        _c("b-pagination", {
                          staticClass: "my-0",
                          attrs: {
                            "total-rows": _vm.totalRows,
                            "per-page": _vm.perPage,
                            align: "fill",
                            size: "sm",
                          },
                          model: {
                            value: _vm.currentPage,
                            callback: function ($$v) {
                              _vm.currentPage = $$v
                            },
                            expression: "currentPage",
                          },
                        }),
                      ],
                      1
                    ),
                  ],
                  1
                ),
              ],
              1
            ),
          ]),
        ]),
      ]),
    ]),
  ])
}
var staticRenderFns = []
render._withStripped = true



/***/ })

}]);