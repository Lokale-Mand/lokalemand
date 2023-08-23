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
                                    <section class="invoice" id="printMe">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <h5 class="page-header">{{ $appName }}</h5>
                                            <h5 class="page-header">Mo. {{ $supportNumber }}</h5>
                                        </div>
                                        <hr>
                                        <!-- info row -->
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div class="col-sm-4 invoice-col">
                                                From
                                                <address>
                                                    <strong>{{ $appName }}</strong>
                                                </address>
                                                <address>
                                                    Email: {{ $supportEmail }}<br>

                                                </address>
                                                <address>
                                                    Customer Care : {{ $supportNumber }}
                                                </address>
                                                <address>
                                                    Delivery By: {{ order.delivery_boy }}
                                                </address>
                                            </div>
                                            <div class="col-sm-5 invoice-col">
                                                Shipping Address
                                                <address>
                                                    <strong>{{ order.user_name }}</strong>
                                                </address>
                                                <address>
                                                    {{ order.address }}<br>
                                                </address>
                                                <address>
                                                    <strong>{{ order.mobile }}</strong><br>
                                                </address>
                                                <address>
                                                    <strong>{{ order.email }}</strong><br>
                                                </address>
                                            </div>
                                            <div class="col-sm-3 invoice-col">
                                                Retail Invoice
                                                <address>
                                                    <b>No : </b>#{{ order.order_item_id }}
                                                </address>
                                                <address>
                                                    <b>Date: </b>{{ order.created_at | moment }}
                                                </address>
                                            </div>
                                        </div>
                                        <hr>
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="well">
                                                    <div class="row"><strong>Item : {{ order_items.length }}</strong></div>

                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <div class="col-md-4">
                                                            <p>Sold By</p>
                                                            <strong>{{ order.store_name }}</strong>
                                                            <p>Email: {{ order.email }}</p>
                                                            <p> Customer Care : +91 {{ order.mobile }}</p>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <strong>
                                                                <p>Pan Number : {{ order.pan_number }}</p>
                                                                <p>{{ order.tax_name }} : {{ order.tax_number }}</p>
                                                            </strong>
    <!--                                                        <?php
                                if (!empty($res_items[0]['delivery_boy_id'])) {
                                    $delivery_noy_name = $function->get_data($columns = ['name'], 'id=' . $res_items[0]['delivery_boy_id'], 'delivery_boys');
                                                            }
                                                            ?>-->
                                                            <p v-if="order.delivery_boy_name">Delivery By : {{ order.delivery_boy_name }}</p>
                                                            <p v-else>Delivery By : Not Assigned</p>
                                                        </div>
                                                    </div>
                                                    <hr>
                                                    <div class="row">
                                                        <p class="h6 ">Product Details:</p>
                                                        <!-- <p>100 ml of Himalaya Gentle Baby Shampoo with id: #461  </p> -->
                                                        <div class="row">
                                                            <div class="col-xs-12 table-responsive">
                                                                <table class="table">
                                                                    <thead class="text-center">
                                                                        <tr>
                                                                            <th>Sr No.</th>
                                                                            <th>Product Code</th>
                                                                            <th>Name</th>
                                                                            <th>Unit</th>
                                                                            <th>Price</th>
                                                                            <th>Tax {{ $currency }} (%)</th>
                                                                            <th>Qty</th>
                                                                            <th>SubTotal ( {{ $currency }} )</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody class="text-center">
    <!--                                                                <?php
                                            // $decoded_items = json_decode(stripSlashes($order_list));
                                            $qty = 0;
                                            $h = 1;
                                            $total = $total_tax_amt = $tax_amount1 = 0;
                                            $total_tax = array();
                                            foreach ($seller_items as $item) {
                                                // if($item[11] ){
                                                if ($item[8] != 'cancelled' && $item[8] != 'returned') {
                                            ?>-->
                                                                        <tr v-for="(item, index) in order_items" :key="item.message" >
                                                                            <td>{{ index+1 }}<br></td>
                                                                            <td>{{ item.product_id }}<br></td>
                                                                            <td>{{ item.product_name }}<br></td>
                                                                            <td>{{ item.variant_name }}<br></td>
                                                                            <td>{{ item.price }}</td>
        <!--                                                                    <?php if ($item[9] != 0) {
                                                                                $sql_tax = "SELECT * FROM `taxes` where id=" . $item[9];
                                                                                $db->sql($sql_tax);
                                                                                $res_tax = $db->getResult();
                                                                                $tax_amount1 = ($res_tax[0]['percentage'] / 100) * $item[10] * $item[2];
                                                                            ?>-->
                                                                            <td>
                                                                                {{ item.tax_amount+ "  (" +item.tax_percentage+"%)" }}
        <!--                                                                        <?php echo $tax_amount1 . " (" . $res_tax[0]['percentage'] . "%) " . $res_tax[0]['title'];
                                                                                    } else {
                                                                                        $tax_amount1 = 0;
                                                                                        ?><br></td>
                                                                                                <td><?= "0 %";
                                                                                    } ?>-->
                                                                                <br>
                                                                            </td>

                                                                            <td>{{ item.quantity }}<br></td>
                                                                            <td>{{ item.sub_total }}<br></td>
                                                                        </tr>
                                                                    </tbody>
                                                                    <tfoot class="text-center">
                                                                        <tr>
                                                                            <th></th>
                                                                            <th></th>
                                                                            <th></th>
                                                                            <th></th>
                                                                            <th>Total</th>
                                                                            <td>{{ total_tax_amount }}<br></td>
                                                                            <td>{{ total_quantity }}<br></td>
                                                                            <td>{{ total_sub_total }}<br></td>
                                                                        </tr>
                                                                    </tfoot>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </div>


                                                </div>
                                            </div>
                                        </div>
                                        <div class="d-flex justify-content-between">
                                            <p><b>Payment Method : </b> {{ order.payment_method.toUpperCase() }}</p>
<!--                                        </div>
                                        <div class="row">-->
                                            <!-- accepted payments column -->
                                            <div class="col-xs-6 col-xs-offset-6">
                                                <!--<p class="lead">Payment Date: </p>-->
                                                <div class="table-responsive">
<!--                                                    <table class="table table-borderless">-->
                                                    <table>
                                                        <tbody>
                                                            <tr>
                                                                <th>Total Order Price ({{ $currency }})</th>
                                                                <td>{{ order.total }}</td>
                                                            </tr>
                                                            <tr>
                                                                <th>Delivery Charge ({{ $currency }})</th>
                                                                <td>{{ order.delivery_charge }}</td>
                                                            </tr>
                                                            <tr>
                                                                <th>Discount {{ $currency }} (%)</th>
                                                                <td>{{ '- ' + discount_in_rupees + ' (' + order.discount + '%)'}}</td>
                                                            </tr>
                                                            <tr>
                                                                <th>Promo ({{ order.promo_code }}) Discount ({{ $currency }})</th>
                                                                <td>{{ '- ' + order.promo_discount }}</td>
                                                            </tr>
                                                            <tr>
                                                                <th>Wallet Used ({{ $currency }})</th>
                                                                <td>{{ '- ' + order.wallet_balance }}</td>
                                                            </tr>
                                                            <tr>
                                                                <th>Final Total ({{ $currency }})</th>
    <!--                                                            <td>{{ '= ' + ceil(order.final_total)}}</td>-->
                                                                <td>{{ '= ' + Math.ceil(order.final_total)}}</td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div><!-- /.col -->
                                        </div><!-- /.row -->
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
            order: [],
            order_items: [],

            discount_in_rupees: 0,

            total_tax_amount:0,
            total_quantity:0,
            total_sub_total:0
        }
    },
    created: function () {
        //console.log(this.$route.params);
        this.id = this.$route.params.id;
        //this.record = this.$route.params.record;
        if (this.id) {
            this.getOrder();
        }
        if (this.order.discount > 0) {
            let discounted_amount = this.order.total * this.order.discount / 100; /*  */
            let final_total = this.order.total - discounted_amount;
            this.discount_in_rupees = this.order.total - final_total;
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
        getOrder() {
            //console.log("this.id",this.id);
            this.isLoading = true
            axios.get(this.$apiUrl + '/orders/view/' + this.id)
                .then((response) => {
                    this.isLoading = false
                    //console.log("data=>", response.data);

                    this.order = response.data.data.order;
                    this.order_items = response.data.data.order_items;





                    this.total_tax_amount = this.order_items.map(item => item.tax_amount).reduce((prev, curr) => prev + curr, 0);
                    this.total_quantity = this.order_items.map(item => item.quantity).reduce((prev, curr) => prev + curr, 0);
                    this.total_sub_total = this.order_items.map(item => item.sub_total).reduce((prev, curr) => prev + curr, 0);

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
