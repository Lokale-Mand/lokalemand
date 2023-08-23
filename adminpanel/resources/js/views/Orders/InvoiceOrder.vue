<template>
    <div>
        <div class="page-heading">
            <div class="row">
                <div class="col-12 col-md-6 order-md-1 order-last">
                    <h3>Invoice</h3>
                </div>
                <div class="col-12 col-md-6 order-md-2 order-first">
                    <nav aria-label="breadcrumb" class="breadcrumb-header float-start float-lg-end">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><router-link to="/dashboard">{{ __('dashboard') }}</router-link></li>
                            <li class="breadcrumb-item" aria-current="page"><router-link to="/orders">View Order</router-link></li>
                            <li class="breadcrumb-item" aria-current="page"><router-link :to="'/orders/view/'+id">Order Details</router-link></li>
                            <li class="breadcrumb-item active" aria-current="page">Invoice</li>
                        </ol>
                    </nav>
                </div>
            </div>

            <div class="row">
                <div class="col-12 col-md-12 order-md-1 order-last">
                    <div class="card">
                        <div class="card-header">
                            <h4>Invoice</h4>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-12">
                                    <section class="invoice" id="printMe" v-html="invoice">

                                    </section>
                                </div>
                            </div>
<!--                            <div class="row">
                                <div class="col-md-12">
                                    <table class="table table-bordered ">
                                        <tbody>
                                        <tr>
                                            <th style="width: 150px">ID</th>
                                            <td>{{ order.id }}</td>
                                            <th style="width: 150px">Name</th>
                                            <td>{{ order.user_name }}</td>
                                        </tr>
                                        <tr>
                                            <th style="width: 150px">Email</th>
                                            <td>{{ order.user_email }}</td>
                                            <th style="width: 150px">Contact</th>
                                            <td>{{ order.user_mobile }}</td>
                                        </tr>
                                        <tr>
                                            <th style="width: 150px">O. Note</th>
                                            <td>{{ order.order_note }}</td>
                                            <th style="width: 150px">Area</th>
                                            <td>{{ order.address }}</td>
                                        </tr>
                                        <tr>
                                            <th style="width: 150px">Pincode</th>
                                            <td>{{ order.pincode }}</td>
                                            <th style="width: 150px">OTP</th>
                                            <td>{{ order.otp }}</td>
                                        </tr>
                                        <tr>
                                            <th style="width: 150px">Items</th>
                                            <td colspan="3">
                                                <div class="row">
                                                    <div class="col-md-12">
                                                        <h4>Standard Shipping Order items</h4>
                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <a href="javascript:void(0)"
                                                               @click="shipprocketModalShow=true">How to manage
                                                                shiprocket order ?</a>
                                                            <button type="button" class="btn btn-sm btn-primary">
                                                                Create Shipprocket Order
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="divider">
                                                    <div class="divider-text"><h5>List of Order Items</h5></div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-md-4 mb-4" v-for="item in order_items">
                                                        <ul class="list-group">


                                                            <li class="list-group-item" v-if="item.user_name" ><b>Order Item Id :- </b>{{ item.user_name }}</li>

                                                            <li class="list-group-item"><b>D.boy :- </b>{{ item.id }}</li>

                                                            <li class="list-group-item"><b>Product Id :- </b>{{ item.product_id }}
                                                                <router-link :to="{ name: 'ViewProduct',params: { id: item.product_id }}" v-b-tooltip.hover title="View" class="btn btn-primary btn-sm"><i class="fa fa-eye"></i></router-link>
                                                            </li>

                                                            <li class="list-group-item" v-if="item.seller_name" ><b>Seller Name :- </b>{{ item.seller_name }}</li>

                                                            <li class="list-group-item"><b>User Name :- </b>{{ item.user_name }}</li>

                                                            <li class="list-group-item"><b>Variant Id :- </b>{{ item.product_variant_id }}</li>
                                                            <li class="list-group-item"><b>Name :- </b>{{ item.product_name+" ("+item.variant_name+")" }}</li>
                                                            <li class="list-group-item"><b>Quantity :- </b>{{ item.quantity }}</li>

                                                            <li class="list-group-item"><b>Price :- </b>{{ item.price }}</li>
                                                            <li class="list-group-item"><b>Discounted Price( {{ $currency }} ) :- </b>{{ item.discounted_price }}</li>
                                                            <li class="list-group-item"><b>Tax Amount( {{ $currency }} ) :- </b>{{ item.tax_amount }}</li>
                                                            <li class="list-group-item"><b>Tax Percentage(%) :- </b>{{ item.tax_percentage }}</li>
                                                            <li class="list-group-item"><b>Subtotal( {{ $currency }} ) :- </b>{{ item.sub_total }}</li>
                                                            <li class="list-group-item">


&lt;!&ndash;                                                                <a class=" col-sm-12 btn btn-success"
                                                                   href="https://api.whatsapp.com/send?phone={{ '+' + order.country_code + ' ' + order.mobile }}&text=Hello {{ order.user_name }} ,Your order with ID :
                                                                   {{ order.id }} is  {{ item.id }} . Please take a note of it. If you have further queries feel free to contact us. Thank you." target='_blank' title="Send Whatsapp Notification"><i class="fa fa-whatsapp"></i></a>&ndash;&gt;

&lt;!&ndash;                                                                <a class=" col-sm-12 btn btn-success" href="https://api.whatsapp.com/send?phone={{ '+' + order.country_code + ' ' + order.mobile }}&text={{ whatsapp_message }}" target='_blank' title="Send Whatsapp Notification">
                                                                    <i class="fa fa-whatsapp"></i>
                                                                </a>&ndash;&gt;

                                                                <a class=" col-sm-12 btn btn-success"
                                                                   href="https://api.whatsapp.com/send?phone=++91 07600924450&amp;text=Hello Vijya Hirani123567, Your order with ID : 437 is Received. Please take a note of it. If you have further queries feel free to contact us. Thank you."
                                                                   target="_blank" title="Send Whatsapp Notification">
                                                                    <i class="fa fa-whatsapp"></i>
                                                                </a>

                                                            </li>
                                                        </ul>
                                                    </div>
                                                    &lt;!&ndash;                                                    <div class="card col-md-4" v-for="item in order_items">
                                                                                                            <div class="card-body">

                                                                                                                <input type="checkbox" name="order_items[]" class="form-check-input"><br><br>
                                                                                                                <label class="label label-primary">Order Not Created</label><br><br>
                                                                                                                <b>Order Item Id : </b>815<br>
                                                                                                                <b>D.boy : </b>Not assigned<br>
                                                                                                                <b>Product Id : </b>562
                                                                                                                <a href="https://ecartvendor.wrteam.co.in//view-product-variants.php?id=562" class="btn btn-success btn-xs" title="View Product"><i class="fa fa-eye"></i></a><br>
                                                                                                                <b>Seller : </b>Cappuccino Store<br>
                                                                                                                <b>User Name : </b>WRTeam Customer<br>
                                                                                                                <b>Variant Id : </b>960<br>
                                                                                                                <b>Name : </b>Fresh Brew Co. French Press Singles | Mysore Nugget ( Medium Dark Roast ) | 10 servings(1pack)<br>
                                                                                                                <b>Quantity : </b>1<br>
                                                                                                                <b>Price($) : </b>350<br>
                                                                                                                <b>Discounted Price($) : </b>0<br>
                                                                                                                <b>Tax Amount($) : </b>0<br>
                                                                                                                <b>Tax Percentage(%) : </b>0<br> <b>Subtotal($) : </b>350                                              <div class="clearfix">
                                                                                                                <a class=" col-sm-12 btn btn-success" href="https://api.whatsapp.com/send?phone=+91 9876543210&amp;text=Hello WRTeam Customer, Your order with ID : 313 is Awaiting_payment. Please take a note of it. If you have further queries feel free to contact us. Thank you." target="_blank" title="Send Whatsapp Notification">
                                                                                                                    <i class="fa fa-whatsapp"></i>
                                                                                                                </a>
                                                                                                            </div>
                                                                                                            </div>
                                                                                                        </div>&ndash;&gt;
                                                </div>
                                            </td>
                                        </tr>


                                        <tr>
                                            <th style="width: 150px">Total ({{ $currency }})</th>
                                            <td>{{ order.total }}</td>
                                            <th style="width: 150px">D.Charge ({{ $currency }})</th>
                                            <td>{{ order.delivery_charge }}</td>
                                        </tr>


                                        <tr>
                                            <th style="width: 150px">Disc. {{ $currency }}( % )</th>
                                            <td>{{ discount_in_rupees+' ( '+ order.discount+'% )' }}</td>

                                            <th style="width: 150px">Promo Disc. ({{ $currency }})</th>
                                            <td>{{ order.promo_discount }}</td>
                                        </tr>
                                        <tr>
                                            <th style="width: 150px">Discount %</th>
                                            <td>
                                                <div class="input-group mb-3">
                                                    <input type="number" class="form-control" name="input_discount" :value="order.discount" min=0 max=100 placeholder="Discount %" aria-label="Discount %" aria-describedby="save">
                                                    <button class="btn btn-primary" type="button" id="save">Save</button>
                                                </div>
                                            </td>
                                            <th style="width: 150px">Payable Total( {{ $currency }} )</th>
                                            <td>
                                                <input type="number" class="form-control" id="final_total" name="final_total" :value="order.payable_total" disabled>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th style="width: 150px">Payment Method</th>
                                            <td>{{ order.payment_method.toUpperCase() }}</td>
                                            <th style="width: 150px">Wallet Used</th>
                                            <td>{{ order.wallet_balance }}</td>
                                        </tr>

                                        <tr>
                                            <th style="width: 150px">Promo Code</th>
                                            <td>{{ order.promo_code }}</td>

                                            <th style="width: 150px">Address</th>
                                            <td>{{ order.address+', '+order.landmark+', '+order.area+', '+order.city+', '+order.state+'-'+order.pincode+', '+order.country }}</td>
                                        </tr>

                                        <tr>
                                            <th style="width: 150px">Order Date</th>
                                            <td>{{ order.created_at }}</td>
                                            <th style="width: 150px">Delivery Time</th>
                                            <td>{{ order.delivery_time }}</td>
                                        </tr>

                                        </tbody>
                                    </table>
                                </div>
                            </div>-->
                        </div>
                        <div class="card-footer">
                            <button type="button" v-print="'#printMe'"  v-b-tooltip.hover title="Print" class="btn btn-sm btn-secondary" ><i class="fa fa-print"></i> Print</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
import axios from "axios";
import moment from "moment";
import print from 'vue-print-nb'
export default {
    directives: {
        print
    },
    data: function () {
        return {
            id: null,
            invoice:""
        }
    },
    created: function () {
        //console.log(this.$route.params);
        this.id = this.$route.params.id;
        //this.record = this.$route.params.record;
        if (this.id) {
            this.getInvoice();
        }
    },
    filters: {
        moment: function (date) {
            //return moment(date).format('MMMM Do YYYY, h:mm:ss A');
            return moment(date).format('D-MMMM-YYYY, h:mm:ss A');
        }
    },
    methods: {
        moment: function () {
            return moment();
        },
        getInvoice(){
            this.isLoading = true
            let param = {
                "order_id": this.id,
            }
            axios.get(this.$apiUrl + '/orders/invoice/', {
                params: param
            })
            .then((response) => {
                this.isLoading = false
                let data = response.data;
                if (data.status === 1) {
                    this.invoice = response.data.data;
                } else {
                    this.showError(data.message);
                    setTimeout(() => {
                        //this.$router.push('/login');
                        this.$router.back();
                    }, 1000);
                }
            }).catch(error => {
                this.isLoading = false;
                if (error.request.statusText) {
                    this.showError(error.request.statusText);
                }else if (error.message) {
                    this.showError(error.message);
                } else {
                    this.showError(__('something_went_wrong'));
                }
            });
        },
    }
};
</script>
<style scoped>
@page {
    size: auto;
    margin: 0mm;
}

.borderless td,
.heading th {
    border: none !important;
    padding: 0px !important;
}

address {
    margin-bottom: 1px;
    font-style: normal;
    line-height: 1.42857143;
}

p {
    margin: 0 0 0px;
}

.invoice {
    position: relative;
    background: #fff;
    border: 1px solid #f4f4f4;
    padding: 20px;
    margin: 10px 25px
}
.invoice-title {
    margin-top: 0
}

.well {
    min-height: 20px;
    padding: 19px;
    margin-bottom: 20px;
    background-color: #f5f5f5;
    border: 1px solid #e3e3e3;
    border-radius: 4px;
    -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .05);
    box-shadow: inset 0 1px 1px rgba(0, 0, 0, .05)
}
.well blockquote {
    border-color: #ddd;
    border-color: rgba(0, 0, 0, .15)
}
.well-lg {
    padding: 24px;
    border-radius: 6px
}
.well-sm {
    padding: 9px;
    border-radius: 3px
}


</style>
